createcertificatesForOrg1() {
  # echo
  # echo "reenroll the CA admin"
  # echo
  # mkdir -p ../crypto-config_1/peerOrganizations/org1.example.com/
  # export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config_1/peerOrganizations/org1.example.com/

  # fabric-ca-client reenroll -u https://admin:adminpw@localhost:7054 --caname ca.org1.example.com  --csr.keyrequest.reusekey --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org1-example-com.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org1-example-com.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org1-example-com.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org1-example-com.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config_1/peerOrganizations/org1.example.com/msp/config.yaml

  # mkdir -p ../crypto-config_1/peerOrganizations/org1.example.com/peers

  # # -----------------------------------------------------------------------------------
  # #  Peer 0
  # mkdir -p ../crypto-config_1/peerOrganizations/org1.example.com/peers/peer0.org1.example.com

  echo
  echo "## Generate the peer0 msp"
  echo
  fabric-ca-client reenroll -u https://peer0:peer0pw@localhost:7054 \
  --caname ca.org1.example.com -d \
  -M ${PWD}/../crypto-config_1/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/msp \
  --csr.hosts peer0.org1.example.com --csr.keyrequest.reusekey \
  --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem

  fabric-ca-client reenroll -d --enrollment.profile tls -u https://orderer1.struatwalamo-net:orderer1.struatwalamo-net-pw@ca.struatwalamo-net:7054 -M ~/ca-tools/struatwalamo/cas/orderers/tls/orderer1.struatwalamo-net --csr.hosts orderer1.struatwalamo-net,orderer1.struatwalamo-net.prod-1.wbp.in.wal-mart.com --tls.certfiles /crypto-config/ordererOrganizations/struatwalamo-net/msp/tlscacerts/ca-struatwalamo-net-prod-1.wbp.in.wal-mart.com-8443.pem --csr.names O=struatwalamo,OU=struatwalamo,L=51.50/-0.13/Arkansas,C=US --csr.keyrequest.reusekey

  cp ${PWD}/../crypto-config_1/peerOrganizations/org1.example.com/msp/config.yaml ${PWD}/../crypto-config_1/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
  fabric-ca-client reenroll -u https://peer0:peer0pw@localhost:7054 --caname ca.org1.example.com -M ${PWD}/../crypto-config_1/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls --enrollment.profile tls --csr.hosts peer0.org1.example.com --csr.hosts localhost  --csr.keyrequest.reusekey --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem

  cp ${PWD}/../crypto-config_1/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/tlscacerts/* ${PWD}/../crypto-config_1/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
  cp ${PWD}/../crypto-config_1/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/signcerts/* ${PWD}/../crypto-config_1/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.crt
  cp ${PWD}/../crypto-config_1/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/keystore/* ${PWD}/../crypto-config_1/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.key

  echo
  echo "## Generate the user msp"
  echo
  fabric-ca-client reenroll -u https://user1:user1pw@localhost:7054 --caname ca.org1.example.com -M ${PWD}/../crypto-config_1/peerOrganizations/org1.example.com/users/User1@org1.example.com/msp  --csr.keyrequest.reusekey --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem

  mkdir -p ../crypto-config_1/peerOrganizations/org1.example.com/users/Admin@org1.example.com

  echo
  echo "## Generate the org admin msp"
  echo
  fabric-ca-client reenroll -u https://org1admin:org1adminpw@localhost:7054 --caname ca.org1.example.com -M ${PWD}/../crypto-config_1/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp  --csr.keyrequest.reusekey --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem

  cp ${PWD}/../crypto-config_1/peerOrganizations/org1.example.com/msp/config.yaml ${PWD}/../crypto-config_1/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/config.yaml

}

# createcertificatesForOrg1

createCertificatesForOrg2() {
  echo
  echo "reenroll the CA admin" --csr.keyrequest.reusekey
  echo
  mkdir -p /../crypto-config_1/peerOrganizations/org2.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config_1/peerOrganizations/org2.example.com/

  fabric-ca-client reenroll -u https://admin:adminpw@localhost:8054 --caname ca.org2.example.com \
   --tls.certfiles ${PWD}/fabric-ca/org2/tls-cert.pem \
   --csr.keyrequest.reusekey \
   --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-org2-example-com.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-org2-example-com.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-org2-example-com.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-org2-example-com.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config_1/peerOrganizations/org2.example.com/msp/config.yaml

  # --------------------------------------------------------------
  # Peer 0
  echo
  echo "## Generate the peer0 msp"
  echo

  fabric-ca-client reenroll -u https://peer0:peer0pw@localhost:8054 --caname ca.org2.example.com -M ${PWD}/../crypto-config_1/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/msp --csr.hosts peer0.org2.example.com --tls.certfiles ${PWD}/fabric-ca/org2/tls-cert.pem --csr.keyrequest.reusekey --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem

  cp ${PWD}/../crypto-config_1/peerOrganizations/org2.example.com/msp/config.yaml ${PWD}/../crypto-config_1/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo

  fabric-ca-client reenroll -u https://peer0:peer0pw@localhost:8054 --caname ca.org2.example.com -M ${PWD}/../crypto-config_1/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls --enrollment.profile tls --csr.hosts peer0.org2.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/org2/tls-cert.pem --csr.keyrequest.reusekey --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem

  cp ${PWD}/../crypto-config_1/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/tlscacerts/* ${PWD}/../crypto-config_1/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
  cp ${PWD}/../crypto-config_1/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/signcerts/* ${PWD}/../crypto-config_1/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/server.crt
  cp ${PWD}/../crypto-config_1/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/keystore/* ${PWD}/../crypto-config_1/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/server.key

  echo
  echo "## Generate the user msp"
  echo

  fabric-ca-client reenroll -u https://user1:user1pw@localhost:8054 --caname ca.org2.example.com -M ${PWD}/../crypto-config_1/peerOrganizations/org2.example.com/users/User1@org2.example.com/msp --tls.certfiles ${PWD}/fabric-ca/org2/tls-cert.pem --csr.keyrequest.reusekey --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem

  mkdir -p ../crypto-config_1/peerOrganizations/org2.example.com/users/Admin@org2.example.com

  echo
  echo "## Generate the org admin msp"
  echo

  fabric-ca-client reenroll -u https://org2admin:org2adminpw@localhost:8054 --caname ca.org2.example.com -M ${PWD}/../crypto-config_1/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp --tls.certfiles ${PWD}/fabric-ca/org2/tls-cert.pem --csr.keyrequest.reusekey --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem

  cp ${PWD}/../crypto-config_1/peerOrganizations/org2.example.com/msp/config.yaml ${PWD}/../crypto-config_1/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp/config.yaml

}

# createCertificateForOrg2

createCertificatesForOrg3() {
  echo
  echo "reenroll the CA admin" --csr.keyrequest.reusekey
  echo
  mkdir -p ../crypto-config_1/peerOrganizations/org3.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config_1/peerOrganizations/org3.example.com/

  fabric-ca-client reenroll -u https://admin:adminpw@localhost:10054 --caname ca.org3.example.com --tls.certfiles ${PWD}/fabric-ca/org3/tls-cert.pem --csr.keyrequest.reusekey --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-org3-example-com.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-org3-example-com.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-org3-example-com.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-org3-example-com.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config_1/peerOrganizations/org3.example.com/msp/config.yaml

  # --------------------------------------------------------------
  # Peer 0
  echo
  echo "## Generate the peer0 msp"
  echo

  fabric-ca-client reenroll -u https://peer0:peer0pw@localhost:10054 --caname ca.org3.example.com -M ${PWD}/../crypto-config_1/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/msp --csr.hosts peer0.org3.example.com --tls.certfiles ${PWD}/fabric-ca/org3/tls-cert.pem --csr.keyrequest.reusekey --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem

  cp ${PWD}/../crypto-config_1/peerOrganizations/org3.example.com/msp/config.yaml ${PWD}/../crypto-config_1/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo

  fabric-ca-client reenroll -u https://peer0:peer0pw@localhost:10054 --caname ca.org3.example.com -M ${PWD}/../crypto-config_1/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls --enrollment.profile tls --csr.hosts peer0.org3.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/org3/tls-cert.pem --csr.keyrequest.reusekey --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem

  cp ${PWD}/../crypto-config_1/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/tlscacerts/* ${PWD}/../crypto-config_1/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/ca.crt
  cp ${PWD}/../crypto-config_1/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/signcerts/* ${PWD}/../crypto-config_1/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/server.crt
  cp ${PWD}/../crypto-config_1/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/keystore/* ${PWD}/../crypto-config_1/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/server.key

  mkdir -p ../crypto-config_1/peerOrganizations/org3.example.com/users
  mkdir -p ../crypto-config_1/peerOrganizations/org3.example.com/users/User1@org3.example.com

  echo
  echo "## Generate the user msp"
  echo

  fabric-ca-client reenroll -u https://user1:user1pw@localhost:10054 --caname ca.org3.example.com -M ${PWD}/../crypto-config_1/peerOrganizations/org3.example.com/users/User1@org3.example.com/msp --tls.certfiles ${PWD}/fabric-ca/org3/tls-cert.pem --csr.keyrequest.reusekey --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem

  mkdir -p ../crypto-config_1/peerOrganizations/org3.example.com/users/Admin@org3.example.com

  echo
  echo "## Generate the org admin msp"
  echo

  fabric-ca-client reenroll -u https://org3admin:org3adminpw@localhost:10054 --caname ca.org3.example.com -M ${PWD}/../crypto-config_1/peerOrganizations/org3.example.com/users/Admin@org3.example.com/msp --tls.certfiles ${PWD}/fabric-ca/org3/tls-cert.pem --csr.keyrequest.reusekey --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem

  cp ${PWD}/../crypto-config_1/peerOrganizations/org3.example.com/msp/config.yaml ${PWD}/../crypto-config_1/peerOrganizations/org3.example.com/users/Admin@org3.example.com/msp/config.yaml

}

createCretificatesForOrderer() {
  echo
  echo "reenroll the CA admin" --csr.keyrequest.reusekey
  echo
  mkdir -p ../crypto-config_1/ordererOrganizations/example.com

  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config_1/ordererOrganizations/example.com

  fabric-ca-client reenroll -u https://admin:adminpw@localhost:9054 --caname ca-orderer --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem --csr.keyrequest.reusekey --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config_1/ordererOrganizations/example.com/msp/config.yaml

  # ---------------------------------------------------------------------------
  #  Orderer

  echo
  echo "## Generate the orderer msp"
  echo

  fabric-ca-client reenroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/../crypto-config_1/ordererOrganizations/example.com/orderers/orderer.example.com/msp --csr.hosts orderer.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem --csr.keyrequest.reusekey --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem

  cp ${PWD}/../crypto-config_1/ordererOrganizations/example.com/msp/config.yaml ${PWD}/../crypto-config_1/ordererOrganizations/example.com/orderers/orderer.example.com/msp/config.yaml

  echo
  echo "## Generate the orderer-tls certificates"
  echo

  fabric-ca-client reenroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/../crypto-config_1/ordererOrganizations/example.com/orderers/orderer.example.com/tls --enrollment.profile tls --csr.hosts orderer.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem --csr.keyrequest.reusekey --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem

  cp ${PWD}/../crypto-config_1/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/../crypto-config_1/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt
  cp ${PWD}/../crypto-config_1/ordererOrganizations/example.com/orderers/orderer.example.com/tls/signcerts/* ${PWD}/../crypto-config_1/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt
  cp ${PWD}/../crypto-config_1/ordererOrganizations/example.com/orderers/orderer.example.com/tls/keystore/* ${PWD}/../crypto-config_1/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.key

  # -----------------------------------------------------------------
  #  Orderer 2

  mkdir -p ../crypto-config_1/ordererOrganizations/example.com/orderers/orderer2.example.com

  echo
  echo "## Generate the orderer msp"
  echo

  fabric-ca-client reenroll -u https://orderer2:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/../crypto-config_1/ordererOrganizations/example.com/orderers/orderer2.example.com/msp --csr.hosts orderer2.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem --csr.keyrequest.reusekey --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem

  cp ${PWD}/../crypto-config_1/ordererOrganizations/example.com/msp/config.yaml ${PWD}/../crypto-config_1/ordererOrganizations/example.com/orderers/orderer2.example.com/msp/config.yaml

  echo
  echo "## Generate the orderer-tls certificates"
  echo

  fabric-ca-client reenroll -u https://orderer2:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/../crypto-config_1/ordererOrganizations/example.com/orderers/orderer2.example.com/tls --enrollment.profile tls --csr.hosts orderer2.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem --csr.keyrequest.reusekey --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem

  cp ${PWD}/../crypto-config_1/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/tlscacerts/* ${PWD}/../crypto-config_1/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/ca.crt
  cp ${PWD}/../crypto-config_1/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/signcerts/* ${PWD}/../crypto-config_1/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/server.crt
  cp ${PWD}/../crypto-config_1/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/keystore/* ${PWD}/../crypto-config_1/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/server.key

  # ---------------------------------------------------------------------------
  #  Orderer 3
  mkdir -p ../crypto-config_1/ordererOrganizations/example.com/orderers/orderer3.example.com

  echo
  echo "## Generate the orderer msp"
  echo

  fabric-ca-client reenroll -u https://orderer3:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/../crypto-config_1/ordererOrganizations/example.com/orderers/orderer3.example.com/msp --csr.hosts orderer3.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem --csr.keyrequest.reusekey --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem

  cp ${PWD}/../crypto-config_1/ordererOrganizations/example.com/msp/config.yaml ${PWD}/../crypto-config_1/ordererOrganizations/example.com/orderers/orderer3.example.com/msp/config.yaml

  echo
  echo "## Generate the orderer-tls certificates"
  echo

  fabric-ca-client reenroll -u https://orderer3:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/../crypto-config_1/ordererOrganizations/example.com/orderers/orderer3.example.com/tls --enrollment.profile tls --csr.hosts orderer3.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem --csr.keyrequest.reusekey --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem

  cp ${PWD}/../crypto-config_1/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/tlscacerts/* ${PWD}/../crypto-config_1/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/ca.crt
  cp ${PWD}/../crypto-config_1/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/signcerts/* ${PWD}/../crypto-config_1/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/server.crt
  cp ${PWD}/../crypto-config_1/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/keystore/* ${PWD}/../crypto-config_1/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/server.key

  echo
  echo "## Generate the admin msp"
  echo

  fabric-ca-client reenroll -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer -M ${PWD}/../crypto-config_1/ordererOrganizations/example.com/users/Admin@example.com/msp --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem --csr.keyrequest.reusekey --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem

  cp ${PWD}/../crypto-config_1/ordererOrganizations/example.com/msp/config.yaml ${PWD}/../crypto-config_1/ordererOrganizations/example.com/users/Admin@example.com/msp/config.yaml

}

# createCretificateForOrderer

createcertificatesForOrg1
createCertificatesForOrg2
createCertificatesForOrg3

createCretificatesForOrderer
