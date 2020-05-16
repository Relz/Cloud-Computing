import * as sqlite3 from "sqlite3";
import { IScoreDatabase } from "./IScoreDatabase";
import { IScore } from "../IScore";

export class LocalScoreDatabase implements IScoreDatabase {
  private static _instance: LocalScoreDatabase;

  private _db: sqlite3.Database;
  private constructor() {
    this._db = new sqlite3.Database("db.sqlite3");
    this._db.run(
      "CREATE TABLE IF NOT EXISTS score (timestamp INTEGER, value INTEGER)"
    );
  }

  public static get instance() {
    if (LocalScoreDatabase._instance === undefined) {
      LocalScoreDatabase._instance = new LocalScoreDatabase();
    }
    return LocalScoreDatabase._instance;
  }

  public getScores(callback: (scores: IScore[]) => void): void {
    const scores: IScore[] = [];
    this._db.each(
      "SELECT * FROM score ORDER BY value DESC",
      (error, row) => {
        scores.push({
          timestamp: row.timestamp,
          value: row.value,
        });
      },
      () => callback(scores)
    );
  }

  public addScore(value: number, timestamp: number): void {
    this._db.run(
      `INSERT INTO score (timestamp, value) VALUES(${timestamp}, ${value})`
    );
  }
}
