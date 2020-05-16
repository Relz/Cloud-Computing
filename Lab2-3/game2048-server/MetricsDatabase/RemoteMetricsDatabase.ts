import { IMetricsDatabase } from "./IMetricsDatabase";
import * as AWS from "aws-sdk";

export class RemoteMetricsDatabase implements IMetricsDatabase {
  private static _instance: RemoteMetricsDatabase;

  private _db: AWS.DynamoDB.DocumentClient;
  private constructor() {
    this._db = new AWS.DynamoDB.DocumentClient({
      credentials: new AWS.Credentials({
        accessKeyId: "",
        secretAccessKey: "",
      }),
      region: "eu-central-1",
    });
  }

  public static get instance() {
    if (RemoteMetricsDatabase._instance === undefined) {
      RemoteMetricsDatabase._instance = new RemoteMetricsDatabase();
    }
    return RemoteMetricsDatabase._instance;
  }

  public getVisitCount(callback: (visits: number) => void): void {
    this._db.scan(
      {
        TableName: "Visit",
        Select: "COUNT",
      },
      (error: AWS.AWSError, data: AWS.DynamoDB.ScanOutput) => {
        if (error === null) {
          callback(data.Count);
        } else {
          console.error(
            "Unable to scan the table. Error JSON:",
            JSON.stringify(error, null, 2)
          );
        }
      }
    );
  }

  public addVisit(ip: string, timestamp: number) {
    this._db.put(
      {
        TableName: "Visit",
        Item: {
          Timestamp: timestamp,
          Ip: ip,
        },
      },
      (error: AWS.AWSError, data: AWS.DynamoDB.PutItemOutput) => {
        if (error !== null) {
          console.error(
            "Unable to put item to the table. Error JSON:",
            JSON.stringify(error, null, 2)
          );
        }
      }
    );
  }
}
