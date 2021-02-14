package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"strconv"
	"time"

	"github.com/hyperledger/fabric-contract-api-go/contractapi"
	"github.com/hyperledger/fabric/common/flogging"
)

type SmartContract struct {
	contractapi.Contract
}

type DocumentContract struct {
	contractapi.Contract
}

var logger = flogging.MustGetLogger("fabcar_cc")

//
type Car struct {
	ID      string `json:"id"`
	Make    string `json:"make"`
	Model   string `json:"model"`
	Colour  string `json:"colour"`
	Owner   string `json:"owner"`
	AddedAt uint64 `json:"addedAt"`
}

type Document struct {
	ID          string `json:"id"`
	Name        string `json:"name"`
	AddedAt     uint64 `json:"addedAt"`
	URL         string `json:"url"`
	ContentHash string `json:"contentHash"`
}

func (s *SmartContract) CreateCar(ctx contractapi.TransactionContextInterface, carData string) (string, error) {

	if len(carData) == 0 {
		return "", fmt.Errorf("Please pass the correct car data")
	}

	var car Car
	err := json.Unmarshal([]byte(carData), &car)
	if err != nil {
		return "", fmt.Errorf("Failed while unmarshling car. %s", err.Error())
	}

	carAsBytes, err := json.Marshal(car)
	if err != nil {
		return "", fmt.Errorf("Failed while marshling car. %s", err.Error())
	}

	return ctx.GetStub().GetTxID(), ctx.GetStub().PutState(car.ID, carAsBytes)
}

func (s *SmartContract) UpdateCarOwner(ctx contractapi.TransactionContextInterface, carID string, newOwner string) (string, error) {

	if len(carID) == 0 {
		return "", fmt.Errorf("Please pass the correct car id")
	}

	carAsBytes, err := ctx.GetStub().GetState(carID)

	if err != nil {
		return "", fmt.Errorf("Failed to get car data. %s", err.Error())
	}

	if carAsBytes == nil {
		return "", fmt.Errorf("%s does not exist", carID)
	}

	car := new(Car)
	_ = json.Unmarshal(carAsBytes, car)

	car.Owner = newOwner

	carAsBytes, err = json.Marshal(car)
	if err != nil {
		return "", fmt.Errorf("Failed while marshling car. %s", err.Error())
	}

	//  txId := ctx.GetStub().GetTxID()

	return ctx.GetStub().GetTxID(), ctx.GetStub().PutState(car.ID, carAsBytes)

}

func (s *SmartContract) GetHistoryForAsset(ctx contractapi.TransactionContextInterface, carID string) (string, error) {

	resultsIterator, err := ctx.GetStub().GetHistoryForKey(carID)
	if err != nil {
		return "", fmt.Errorf(err.Error())
	}
	defer resultsIterator.Close()

	// buffer is a JSON array containing historic values for the marble
	var buffer bytes.Buffer
	buffer.WriteString("[")

	bArrayMemberAlreadyWritten := false
	for resultsIterator.HasNext() {
		response, err := resultsIterator.Next()
		if err != nil {
			return "", fmt.Errorf(err.Error())
		}
		// Add a comma before array members, suppress it for the first array member
		if bArrayMemberAlreadyWritten == true {
			buffer.WriteString(",")
		}
		buffer.WriteString("{\"TxId\":")
		buffer.WriteString("\"")
		buffer.WriteString(response.TxId)
		buffer.WriteString("\"")

		buffer.WriteString(", \"Value\":")
		if response.IsDelete {
			buffer.WriteString("null")
		} else {
			buffer.WriteString(string(response.Value))
		}

		buffer.WriteString(", \"Timestamp\":")
		buffer.WriteString("\"")
		buffer.WriteString(time.Unix(response.Timestamp.Seconds, int64(response.Timestamp.Nanos)).String())
		buffer.WriteString("\"")

		buffer.WriteString(", \"IsDelete\":")
		buffer.WriteString("\"")
		buffer.WriteString(strconv.FormatBool(response.IsDelete))
		buffer.WriteString("\"")

		buffer.WriteString("}")
		bArrayMemberAlreadyWritten = true
	}
	buffer.WriteString("]")

	return string(buffer.Bytes()), nil
}

func (s *SmartContract) GetCarById(ctx contractapi.TransactionContextInterface, carID string) (*Car, error) {
	if len(carID) == 0 {
		return nil, fmt.Errorf("Please provide correct contract Id")
		// return shim.Error("Incorrect number of arguments. Expecting 1")
	}

	carAsBytes, err := ctx.GetStub().GetState(carID)

	if err != nil {
		return nil, fmt.Errorf("Failed to read from world state. %s", err.Error())
	}

	if carAsBytes == nil {
		return nil, fmt.Errorf("%s does not exist", carID)
	}

	car := new(Car)
	_ = json.Unmarshal(carAsBytes, car)

	return car, nil

}

func (s *SmartContract) GetContractsForQuery(ctx contractapi.TransactionContextInterface, queryString string) ([]Car, error) {

	queryResults, err := s.getQueryResultForQueryString(ctx, queryString)

	if err != nil {
		return nil, fmt.Errorf("Failed to read from ----world state. %s", err.Error())
	}

	return queryResults, nil

}

func (s *SmartContract) getQueryResultForQueryString(ctx contractapi.TransactionContextInterface, queryString string) ([]Car, error) {

	// resultsIterator, err := ctx.GetStub().GetPrivateDataQueryResult("collectionMarbles", queryString)
	resultsIterator, err := ctx.GetStub().GetQueryResult(queryString)
	if err != nil {
		return nil, err
	}
	defer resultsIterator.Close()

	results := []Car{}

	for resultsIterator.HasNext() {
		response, err := resultsIterator.Next()
		if err != nil {
			return nil, err
		}

		newCar := new(Car)

		err = json.Unmarshal(response.Value, newCar)
		if err != nil {
			return nil, err
		}

		results = append(results, *newCar)
	}
	return results, nil
}

func (s *DocumentContract) CreateDocument(ctx contractapi.TransactionContextInterface, documentDate string) (string, error) {

	if len(documentDate) == 0 {
		return "", fmt.Errorf("Please pass the correct document data")
	}

	var document Document
	err := json.Unmarshal([]byte(documentDate), &document)
	if err != nil {
		return "", fmt.Errorf("Failed while unmarshling document. %s", err.Error())
	}

	documentAsBytes, err := json.Marshal(document)
	if err != nil {
		return "", fmt.Errorf("Failed while marshling car. %s", err.Error())
	}

	return ctx.GetStub().GetTxID(), ctx.GetStub().PutState(document.ID, documentAsBytes)
}

func (s *DocumentContract) GetDocumentById(ctx contractapi.TransactionContextInterface, documentID string) (*Document, error) {
	if len(documentID) == 0 {
		return nil, fmt.Errorf("Please provide correct document Id")
		// return shim.Error("Incorrect number of arguments. Expecting 1")
	}

	documentAsBytes, err := ctx.GetStub().GetState(documentID)

	if err != nil {
		return nil, fmt.Errorf("Failed to read from world state. %s", err.Error())
	}

	if documentAsBytes == nil {
		return nil, fmt.Errorf("%s does not exist", documentID)
	}

	document := new(Document)
	_ = json.Unmarshal(documentAsBytes, document)

	return document, nil

}

func (s *SmartContract) GetDocumentUsingCarContract(ctx contractapi.TransactionContextInterface, documentID string) (string, error) {
	if len(documentID) == 0 {
		return "", fmt.Errorf("Please provide correct contract Id")
		// return shim.Error("Incorrect number of arguments. Expecting 1")
	}

	params := []string{"DocumentContract:GetDocumentById", documentID}
	queryArgs := make([][]byte, len(params))
	for i, arg := range params {
		queryArgs[i] = []byte(arg)
	}

	response := ctx.GetStub().InvokeChaincode("DocumentContract", queryArgs, "mychannel")
	// if response.Status !=  "OK" {
	// 	return "", fmt.Errorf("Failed to query chaincode. Got error: %s", response.Payload)
	// }

	return string(response.Payload), nil

}

func main() {

	chaincode, err := contractapi.NewChaincode(new(SmartContract), new(DocumentContract))
	if err != nil {
		fmt.Printf("Error create fabcar chaincode: %s", err.Error())
		return
	}
	if err := chaincode.Start(); err != nil {
		fmt.Printf("Error starting chaincodes: %s", err.Error())
	}

}
