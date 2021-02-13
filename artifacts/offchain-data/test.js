const express = require('express');
const mongodb = require('mongodb')
var app = express()
require('dotenv').config()

// var MongoClient = require('mongodb').MongoClient;
const {MongoClient} = require('mongodb');
var db;
let uri = `mongodb+srv://${process.env.MONGODB_USERNAME}:${process.env.MONGODB_PASSWORD}@cluster0.gxh9w.mongodb.net/fabric?retryWrites=true&w=majority`
const client = new MongoClient(uri);

const connect =async ()=>{
    let c = await client.connect();
    db = c.db()
    databasesList = await client.db().admin().listDatabases();
 
    console.log("Databases:");
    databasesList.databases.forEach(db => console.log(` - ${db.name}`));

    db.collection('mychannel_fabcar').insertOne({_id:111, test:"test data"},()=>{
        console.log("data inserted")
    })
}

connect()