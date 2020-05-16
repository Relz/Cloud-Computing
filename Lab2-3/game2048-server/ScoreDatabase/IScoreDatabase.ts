import { IScore } from "../IScore";

export interface IScoreDatabase {
  getScores(callback: (scores: IScore[]) => void): void;
  addScore(value: number, timestamp: number): void;
}
