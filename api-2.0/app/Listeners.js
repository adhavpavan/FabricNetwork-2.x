function showTransactionData(transactionData) {
    console.log(JSON.stringify(transactionData))
	const creator = transactionData.actions[0].header.creator;
	console.log(`    - submitted by: ${creator.mspid}-${creator.id_bytes.toString('hex')}`);
	for (const endorsement of transactionData.actions[0].payload.action.endorsements) {
		console.log(`    - endorsed by: ${endorsement.endorser.mspid}-${endorsement.endorser.id_bytes.toString('hex')}`);
	}
	const chaincode = transactionData.actions[0].payload.chaincode_proposal_payload.input.chaincode_spec;
	console.log(`    - chaincode:${chaincode.chaincode_id.name}`);
	console.log(`    - function:${chaincode.input.args[0].toString()}`);
	for (let x = 1; x < chaincode.input.args.length; x++) {
		console.log(`    - arg:${chaincode.input.args[x].toString()}`);
	}
}

contractListener = async (event) => {
    console.log("==========================================")
    console.log(event)
    // The payload of the chaincode event is the value place there by the
    // chaincode. Notice it is a byte data and the application will have
    // to know how to deserialize.
    // In this case we know that the chaincode will always place the asset
    // being worked with as the payload for all events produced.
    const asset = JSON.parse(event.payload.toString());
    console.log(`<-- Contract Event Received: ${event.eventName} - ${JSON.stringify(asset)}`);
    // show the information available with the event
    console.log(`*** Event: ${event.eventName}:${asset.ID}`);
    // notice how we have access to the transaction information that produced this chaincode event
    const eventTransaction = event.getTransactionEvent();
    console.log(`*** transaction: ${eventTransaction.transactionId} status:${eventTransaction.status}`);
    showTransactionData(eventTransaction.transactionData);
    // notice how we have access to the full block that contains this transaction
    const eventBlock = eventTransaction.getBlockEvent();
    console.log(`*** block: ${eventBlock.blockNumber.toString()}`);
};


blockListener = async (event) => {

    console.log("--------------------------------------------------------------")
    console.log(`<-- Block Event Received - block number: ${event.blockNumber.toString()}`);

    const transEvents = event.getTransactionEvents();
    for (const transEvent of transEvents) {
        console.log(`*** transaction event: ${transEvent.transactionId}`);
        // if (transEvent.privateData) {
        //     for (const namespace of transEvent.privateData.ns_pvt_rwset) {
        //         console.log(`    - private data: ${namespace.namespace}`);
        //         for (const collection of namespace.collection_pvt_rwset) {
        //             console.log(`     - collection: ${collection.collection_name}`);
        //             if (collection.rwset.reads) {
        //                 for (const read of collection.rwset.reads) {
        //                     console.log(`       - read set - ${BLUE}key:${RESET} ${read.key}  ${BLUE}value:${read.value.toString()}`);
        //                 }
        //             }
        //             if (collection.rwset.writes) {
        //                 for (const write of collection.rwset.writes) {
        //                     console.log(`      - write set - ${BLUE}key:${RESET}${write.key} ${BLUE}is_delete:${RESET}${write.is_delete} ${BLUE}value:${RESET}${write.value.toString()}`);
        //                 }
        //             }
        //         }
        //     }
        // }
        if (transEvent.transactionData) {
            showTransactionData(transEvent.transactionData);
        }
    }
};

module.exports = {
    contractListener,
    blockListener
}