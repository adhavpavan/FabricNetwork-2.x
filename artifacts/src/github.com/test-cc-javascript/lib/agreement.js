"use strict";

const { Contract, Transaction } = require("fabric-contract-api");

class Agreement extends Contract {
  // createAsset issues a new asset to the world state with given details.
  async createAsset(ctx, id, color, size, owner, appraisedValue) {
    try {
      const asset = {
        ID: id,
        Color: color,
        Size: size,
        Owner: owner,
        AppraisedValue: appraisedValue,
      };

      await ctx.stub.putState(id, Buffer.from(JSON.stringify(asset)));
      return JSON.stringify(asset);
    } catch (err) {
      throw new Error(err.stack);
    }
  }
// ============================================================

  async CreateContract(ctx, agreementData) {
    try {
      let agreement = JSON.parse(agreementData)
      await ctx.stub.putState(agreement.id, agreementData);
      return ctx.stub.getTxID();
    } catch (err) {
      throw new Error(err.stack);
    }    
  }

  async ApproveContract(ctx, approvalData){
    try {
      let approval = JSON.parse(approvalData)
  
      await ctx.stub.putState(approval.id, approvalData)
      return ctx.stub.getTxID();
      
    } catch (error) {
      throw new Error(error);
    } 

  }


  // ReadAsset returns the asset stored in the world state with given id.
  async getAssetByID(ctx, id) {
    try {
      const assetJSON = await ctx.stub.getState(id);
      if (!assetJSON || assetJSON.length === 0) {
        throw new Error(`The asset ${id} does not exist`);
      }
      return assetJSON.toString();
    } catch (err) {
      throw new Error(err.stack);
    }
  }

  // createBulkAssets with given data
  async createBulkAssets(ctx, data) {
    try {
      const assets = JSON.parse(data);
      console.log(assets);

      for (let count = 0; count < assets.length; count++) {
        console.log(assets[count]);
        await ctx.stub.putState(
          assets[count].id,
          Buffer.from(JSON.stringify(assets[count].value))
        );
      }

      return ctx.stub.getTxID();
    } catch (err) {
      return new Error(err.message);
    }
  }


  // updateAsset updates an existing asset in the world state with provided parameters.
  async updateAsset(ctx, id, color, size, owner, appraisedValue) {
    try {
      const exists = await this.assetExists(ctx, id);
      if (!exists) {
        throw new Error(`The asset ${id} does not exist`);
      }

      // overwriting original asset with new asset
      const updatedAsset = {
        ID: id,
        Color: color,
        Size: size,
        Owner: owner,
        AppraisedValue: appraisedValue,
      };
      return ctx.stub.putState(id, Buffer.from(JSON.stringify(updatedAsset)));
    } catch (err) {
      return new Error(err.stack);
    }
  }

  // deleteAsset deletes an given asset from the world state.
  async deleteContract(ctx, id) {
    try {
      const exists = await this.assetExists(ctx, id);
      if (!exists) {
        throw new Error(`The contract ${id} does not exist`);
      }
      return ctx.stub.deleteState(id);
    } catch (err) {
      return new Error(err.stack);
    }
  }

  // assetExists returns true when asset with given ID exists in world state.
  async assetExists(ctx, id) {
    try {
      const assetJSON = await ctx.stub.getState(id);
      return assetJSON && assetJSON.length > 0;
    } catch (err) {
      return new Error(err.stack);
    }
  }

  // transferAsset updates the owner field of asset with given id in the world state.
  async transferAsset(ctx, id, newOwner) {
    try {
      const assetString = await this.readAsset(ctx, id);
      const asset = JSON.parse(assetString);
      asset.Owner = newOwner;
      return ctx.stub.putState(id, Buffer.from(JSON.stringify(asset)));
    } catch (err) {
      return new Error(err.stack);
    }
  }

  // getAllAssets returns all assets found in the world state.
  async getAllAssets(ctx) {
    try {
      const allResults = [];
      // range query with empty string for startKey and endKey does an open-ended query of all assets in the chaincode namespace.
      const iterator = await ctx.stub.getStateByRange("", "");
      let result = await iterator.next();
      while (!result.done) {
        const strValue = Buffer.from(result.value.value.toString()).toString(
          "utf8"
        );
        let record;
        try {
          record = JSON.parse(strValue);
        } catch (err) {
          console.log(err);
          record = strValue;
        }
        allResults.push({ Key: result.value.key, Record: record });
        result = await iterator.next();
      }
      return JSON.stringify(allResults);
    } catch (err) {
      return new Error(err.message);
    }
  }

  /**
   * Function getAllResults
   * @param {resultsIterator} iterator within scope passed in
   * @param {Boolean} isHistory query string created prior to calling this fn
   */
  async getAllResults(iterator, isHistory) {
    try {
      let allResults = [];
      while (true) {
        let res = await iterator.next();
        console.log(res.value);

        if (res.value && res.value.value.toString()) {
          let jsonRes = {};
          console.log(res.value.value.toString("utf8"));

          if (isHistory && isHistory === true) {
            jsonRes.txId = res.value.txId;
            jsonRes.Timestamp = res.value.timestamp;
            jsonRes.IsDelete = res.value.is_delete
              ? res.value.is_delete.toString()
              : "false";
            try {
              jsonRes.Value = JSON.parse(res.value.value.toString("utf8"));
            } catch (err) {
              console.log(err);
              jsonRes.Value = res.value.value.toString("utf8");
            }
          } else {
            jsonRes.Key = res.value.key;
            try {
              jsonRes.Record = JSON.parse(res.value.value.toString("utf8"));
            } catch (err) {
              console.log(err);
              jsonRes.Record = res.value.value.toString("utf8");
            }
          }
          allResults.push(jsonRes);
        }
        if (res.done) {
          console.log("end of data");
          await iterator.close();
          console.info("allResults : ", allResults);
          return allResults;
        }
      }
    } catch (err) {
      return new Error(err.message);
    }
  }

  /**
   * Function getQueryResultForQueryString
   * getQueryResultForQueryString woerk function executes the passed-in query string.
   * Result set is built and returned as a byte array containing the JSON results.
   * @param {Context} ctx the transaction context
   * @param {any}  self within scope passed in
   * @param {String} the query string created prior to calling this fn
   */
  async getDataForQuery(ctx, queryString) {
    try {
      console.log(
        "- getQueryResultForQueryString queryString:\n" + queryString
      );

      const resultsIterator = await ctx.stub.getQueryResult(queryString);
      let results = await this.getAllResults(resultsIterator, false);

      return results;
    } catch (err) {
      return new Error(err.message);
    }
  }

  /**
   * getAssetHistory takes the asset ID as arg, returns results as JSON
   * @param {String} id the asset ID
   */
  async getAssetHistory(ctx, id) {
    try {
      let resultsIterator = await ctx.stub.getHistoryForKey(id);
      let results = await this.getAllResults(resultsIterator, true);
      console.log("results : ", results);

      return results;
    } catch (err) {
      return new Error(err.stack);
    }
  }

  async getDataWithPagination(ctx, queryString, pageSize, bookmark) {
    try {
      const pageSizeInt = parseInt(pageSize, 10);
      const { iterator, metadata } =
        await ctx.stub.getQueryResultWithPagination(
          queryString,
          pageSizeInt,
          bookmark
        );
      const results = await this.getAllResults(iterator, false);
      let finalData = {
        data: results,
        metadata: {
          RecordsCount: metadata.fetchedRecordsCount,
          Bookmark: metadata.bookmark,
        },
      };
      return finalData;
    } catch (err) {
      return new Error(err.message);
    }
  }
}

module.exports = Agreement;
