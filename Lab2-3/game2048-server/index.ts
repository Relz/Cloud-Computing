import * as restify from "restify";
import * as corsMiddleware from "restify-cors-middleware";
import { IScoreDatabase } from "./ScoreDatabase/IScoreDatabase";
import { LocalScoreDatabase } from "./ScoreDatabase/LocalScoreDatabase";
import { IScore } from "./IScore";
import { RemoteScoreDatabase } from "./ScoreDatabase/RemoteScoreDatabase";
import { IMetricsDatabase } from "./MetricsDatabase/IMetricsDatabase";
import { LocalMetricsDatabase } from "./MetricsDatabase/LocalMetricsDatabase";
import { RemoteMetricsDatabase } from "./MetricsDatabase/RemoteMetricsDatabase";

const scoreDatabase: IScoreDatabase = LocalScoreDatabase.instance;
// const scoreDatabase: IScoreDatabase = RemoteScoreDatabase.instance;
const metricsDatabase: IMetricsDatabase = LocalMetricsDatabase.instance;
// const metricsDatabase: IMetricsDatabase = RemoteMetricsDatabase.instance;

const getScores: restify.RequestHandlerType = (req, res, next) => {
  scoreDatabase.getScores((scores: IScore[]) => {
    res.send(scores);
    next();
  });
};

const addScore: restify.RequestHandlerType = (req, res, next) => {
  const value: number = req.body.value;
  const timestamp: number = req.body.timestamp;

  scoreDatabase.addScore(value, timestamp);
};

const getVisitCount: restify.RequestHandlerType = (req, res, next) => {
  metricsDatabase.getVisitCount((visitCount: number) => {
    res.send(200, visitCount);
    next();
  });
};

const addVisit: restify.RequestHandlerType = (req, res, next) => {
  const ip: string = req.connection.remoteAddress;
  const timestamp: number = parseInt(req.body.timestamp);

  metricsDatabase.addVisit(ip.substr("::ffff:".length), timestamp);
};

const cors = corsMiddleware({
  origins: ["*"],
  allowHeaders: ["Authorization"],
  exposeHeaders: ["Authorization"],
});

const server = restify.createServer({
  name: "Game2048 Server",
  version: "1.0.0",
});
server.use(restify.plugins.bodyParser());
server.pre(cors.preflight);
server.use(cors.actual);

server.get("/scores", getScores);
server.put("/score", addScore);
server.get("/visit_count", getVisitCount);
server.put("/visit", addVisit);

server.listen(4242, () => {
  console.log("%s listening at %s", server.name, server.url);
});
