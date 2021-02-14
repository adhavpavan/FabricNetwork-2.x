package main

import (
	"encoding/json"
	"fmt"

	"github.com/hyperledger/fabric-contract-api-go/contractapi"
	"github.com/hyperledger/fabric/common/flogging"
)

type DocumentContract struct {
	contractapi.Contract
}
var logger = flogging.MustGetLogger("fabcar_cc")



type Document struct {
	ID string `json:"id"`
	Name string `json:"name"`
	AddedAt uint64 `json:"addedAt"`
	URL string `json:"url"`
	ContentHash string `json:"contentHash"`
}

func (s *DocumentContract) CreateDocument(ctx contractapi.TransactionContextInterface, documentDate string) (string, error) {

	if len(documentDate) == 0 {
		return "", fmt.Errorf("Please pass the correct document data")
	}

	var document Document
	err := json.Unmarshal([]byte(documentDate), &document)
	if err != nil {
		return "",  fmt.Errorf("Failed while unmarshling document. %s", err.Error())
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

func main() {

	chaincode, err := contractapi.NewChaincode(new(DocumentContract))
	if err != nil {
		fmt.Printf("Error create fabcar chaincode: %s", err.Error())
		return
	}
	if err := chaincode.Start(); err != nil {
		fmt.Printf("Error starting chaincodes: %s", err.Error())
	}

}
