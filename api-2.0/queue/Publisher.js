const amqp = require("amqplib");

const msg = {number: 444}
connect();
async function connect() {

    try {
        const amqpServer = "amqp://localhost:5672"
        const connection = await amqp.connect(amqpServer)
        const channel = await connection.createChannel();
        await channel.assertQueue("jobs");
        // await channel.sendToQueue("jobs", Buffer.from(JSON.stringify(msg)))
        for(let i=0;i<300;i++){
            console.log(`sending : ${i}`)
            await channel.sendToQueue("jobs", Buffer.from(JSON.stringify(`{number: ${i}}`)))
        }
        console.log(`Job sent successfully ${msg.number}`);
        await channel.close();
        await connection.close();
    }
    catch (ex){
        console.error(ex)
    }

}