# FabricNetwork-2.x

Youtube Channel: https://www.youtube.com/watch?v=SJTdJt6N6Ow&list=PLSBNVhWU6KjW4qo1RlmR7cvvV8XIILub6


Network Topology
Three Orgs(Peer Orgs)
    - Each Org have one peer(Each Endorsing Peer)
    - Each Org have separate Certificate Authority
One Orderer Org(Having three orderers)



Steps:

1) Clone the repo
2) Run Certificates Authority Services for all Orgs
3) Create Cryptomaterials for all organizations
4) Create Channel Artifacts using Org MSP
5) Create Channel and join peers
6) Deploy Chaincode
   1) Install All dependency
   2) Package Chaincode
   3) Install Chaincode on all Endorsing Peer
   4) Approve Chaincode as per Lifecycle Endorsment Policy
   5) Commit Chaincode Defination
7) Create Connection Profiles
8) Register User using API
9) Invoke Chaincode Transaction
10) Query Chaincode Transaction