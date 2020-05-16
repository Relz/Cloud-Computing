import * as sqlite3 from "sqlite3";
import { IMetricsDatabase } from "./IMetricsDatabase";

export class LocalMetricsDatabase implements IMetricsDatabase {
  private static _instance: LocalMetricsDatabase;

  private _db: sqlite3.Database;
  private constructor() {
    this._db = new sqlite3.Database("db.sqlite3");
    this._db.run(
      "CREATE TABLE IF NOT EXISTS visit (timestamp INTEGER, ip TEXT)"
    );
  }

  public static get instance() {
    if (LocalMetricsDatabase._instance === undefined) {
      LocalMetricsDatabase._instance = new LocalMetricsDatabase();
    }
    return LocalMetricsDatabase._instance;
  }

  public getVisitCount(callback: (visits: number) => void): void {
    this._db.get("SELECT COUNT(*) FROM visit", (error, row) =>
      callback(parseInt(Object.values(row)[0] as string))
    );
  }

  public addVisit(ip: string, timestamp: number) {
    this._db.run(
      `INSERT INTO visit (timestamp, ip) VALUES(${timestamp}, "${ip}")`
    );
  }
}
