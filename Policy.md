Here are a few examples of valid principals:

    'Org0.admin': any administrator of the Org0 MSP
    'Org1.member': any member of the Org1 MSP
    'Org1.client': any client of the Org1 MSP
    'Org1.peer': any peer of the Org1 MSP

Endorsement Policy Syntax

    AND('Org1.member', 'Org2.member', 'Org3.member')
    OR('Org1.member', 'Org2.member')
    OR('Org1.member', AND('Org2.member', 'Org3.member'))
    OutOf(1, 'Org1.member', 'Org2.member') -> OR('Org1.member', 'Org2.member')
    OutOf(2, 'Org1.member', 'Org2.member') -> AND('Org1.member', 'Org2.member')
    OutOf(2, 'Org1.member', 'Org2.member', 'Org3.member')  -> OR(AND('Org1.member', 'Org2.member'), AND('Org1.member', 'Org3.member'), AND('Org2.member', 'Org3.member'))

collection-level endorsement policies

    {
        "name": "collectionMarblePrivateDetails",
        "policy": "OR('Org1MSP.member')",
        "requiredPeerCount": 0,
        "maxPeerCount": 3,
        "blockToLive":3,
        "memberOnlyRead": true,
        "memberOnlyWrite":true,
        "endorsementPolicy": {
        "signaturePolicy": "OR('Org1MSP.member')"
        }
    }

Key-level endorsement policies