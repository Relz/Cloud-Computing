export interface IMetricsDatabase {
  getVisitCount(callback: (visits: number) => void);
  addVisit(ip: string, timestamp: number): void;
}
