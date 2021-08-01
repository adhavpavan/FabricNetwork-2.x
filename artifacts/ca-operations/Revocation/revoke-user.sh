export FABRIC_CA_CLIENT_HOME=${PWD}/clients/admin
export TLS_CA=${PWD}/../../channel/crypto-config/peerOrganizations/org1.example.com/msp/tlscacerts/ca.crt


export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/../../channel/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export PEER0_ORG1_CA=${PWD}/../../channel/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export FABRIC_CFG_PATH=${PWD}/../../channel/config/

export CHANNEL_NAME=mychannel


setGlobalsForPeer0Org1() {
    export CORE_PEER_LOCALMSPID="Org1MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/../../channel/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
    export CORE_PEER_ADDRESS=localhost:7051
}

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

# echo $(one_line_pem crl_base64)


EnrollAdmin() {
    fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca.org1.example.com --tls.certfiles $TLS_CA
}

# EnrollAdmin



function revokeFromCA() {

    # fabric-ca-client identity list --tls.certfiles $TLS_CA

    # fabric-ca-client identity list --tls.certfiles  $TLS_CA --id admin

    # fabric-ca-client revoke -e user1 --gencrl --tls.certfiles $TLS_CA

    # base64 clients/admin/msp/crls/crl.pem > crl_base64
    base64 -i clients/admin/msp/crls/crl.pem > crl_base64

}

# revokeFromCA

function revokeFromFabricNetwork() {
    setGlobalsForPeer0Org1
    # peer channel fetch config -c mychannel

    # set -x
    # peer channel fetch config config_block.pb -o localhost:7050 \
    #     --ordererTLSHostnameOverride orderer.example.com \
    #     -c mychannel --tls --cafile $ORDERER_CA
    # set +x

    # configtxlator proto_decode --input config_block.pb --type common.Block --output config_block.json

    # jq .data.data[0].payload.data.config config_block.json >config.json

    # jq --arg new $(cat crl_base64) '.channel_group.groups.Application.groups.Org1MSP.values.MSP.value.config.revocation_list? += [$new]' config.json >modified_config.json
    
    # configtxlator proto_encode --input config.json --type common.Config --output config.pb
    # configtxlator proto_encode --input modified_config.json --type common.Config --output modified_config.pb
    # configtxlator compute_update --channel_id mychannel --original config.pb --updated modified_config.pb --output crl_update.pb

    # configtxlator proto_decode --input crl_update.pb --type common.ConfigUpdate --output crl_update.json

    # echo '{"payload":{"header":{"channel_header":{"channel_id":"mychannel", "type":2}},"data":{"config_update":'$(cat crl_update.json)'}}}' | jq . >crl_update_in_envelope.json

    # configtxlator proto_encode --input crl_update_in_envelope.json --type common.Envelope --output crl_update_in_envelope.pb

    peer channel update -f crl_update_in_envelope.pb -c mychannel -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls true --cafile $ORDERER_CA
}

revokeFromFabricNetwork
