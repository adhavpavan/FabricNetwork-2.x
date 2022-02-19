export CORE_PEER_TLS_ENABLED=true
# export ORDERER_CA=${PWD}/../../../../new-certs/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export ORDERER_CA=${PWD}/../../../../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export FABRIC_CFG_PATH=${PWD}/../../../../../channel/config/

export ORDERER_3_TLS_FILE=${PWD}/../../../../new-certs/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/server.crt

export CHANNEL_NAME=mychannel
export SYSTEM_CHANNEL_NAME=sys-channel

setGlobalsForOrderer() {
    export CORE_PEER_LOCALMSPID="OrdererMSP"
    # export CORE_PEER_MSPCONFIGPATH=${PWD}/../../../../crypto-config/ordererOrganizations/example.com/users/Admin@example.com/msp
    export CORE_PEER_MSPCONFIGPATH=${PWD}/../../../../new-certs/ordererOrganizations/example.com/users/Admin@example.com/msp

}

addTLSToSystemChannelOrderer3() {
    setGlobalsForOrderer

    # peer channel fetch config config_block.pb -o localhost:7050 -c $CHANNEL_NAME --tls --cafile $ORDERER_CA --tlsHandshakeTimeShift 200h

    # configtxlator proto_decode --input config_block.pb --type common.Block | jq .data.data[0].payload.data.config >config.json

    # cp config.json modified_config.json

    #  echo "## Encode Orderer3"
    # cat $ORDERER_3_TLS_FILE | base64 -w 0
    # echo -e "\n----------------------------"

    # Update modified_config.json with above base64 certs


    configtxlator proto_encode --input config.json --type common.Config --output config.pb
    configtxlator proto_encode --input modified_config.json --type common.Config --output modified_config.pb

    configtxlator compute_update --channel_id $CHANNEL_NAME --original config.pb --updated modified_config.pb --output config_update.pb
    configtxlator proto_decode --input config_update.pb --type common.ConfigUpdate --output config_update.json
    
    echo "{\"payload\":{\"header\":{\"channel_header\":{\"channel_id\":\"mychannel\", \"type\":2}},\"data\":{\"config_update\":"$(cat config_update.json)"}}}" | jq . >config_update_in_envelope.json
    
    configtxlator proto_encode --input config_update_in_envelope.json --type common.Envelope --output config_update_in_envelope.pb
    
    peer channel update -f config_update_in_envelope.pb -c $CHANNEL_NAME -o localhost:7050 --tls true --cafile $ORDERER_CA --tlsHandshakeTimeShift 200h


}

addTLSToSystemChannelOrderer3