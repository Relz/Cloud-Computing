import * as mysql from "mysql";
import { IScoreDatabase } from "./IScoreDatabase";
import { IScore } from "../IScore";

export class RemoteScoreDatabase implements IScoreDatabase {
  private static _instance: RemoteScoreDatabase;

  private _db: mysql.Connection;
  private constructor() {
    this._db = mysql.createConnection({
      host: "database-game2048.c5qc9nvjcqht.eu-central-1.rds.amazonaws.com",
      user: "admin",
      password: "",
      database: "game2048",
    });

    this._db.connect();
    this._db.query(
      "CREATE TABLE IF NOT EXISTS score (timestamp BIGINT, value INT)"
    );
  }

  public static get instance() {
    if (RemoteScoreDatabase._instance === undefined) {
      RemoteScoreDatabase._instance = new RemoteScoreDatabase();
    }
    return RemoteScoreDatabase._instance;
  }

  public getScores(callback: (scores: IScore[]) => void): void {
    this._db.query("SELECT * FROM score ORDER BY value DESC", (error, scores) =>
      callback(scores)
    );
  }

  public addScore(value: number, timestamp: number) {
    this._db.query(
      `INSERT INTO score (timestamp, value) VALUES(${timestamp}, ${value})`
    );
  }
}
