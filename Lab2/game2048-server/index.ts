import * as restify from "restify";
import * as corsMiddleware from "restify-cors-middleware";
import { IScoreDatabase } from "./IScoreDatabase";
import { LocalScoreDatabase } from "./LocalScoreDatabase";
import { IScore } from "./IScore";
import { RemoteScoreDatabase } from "./RemoteScoreDatabase";

// const scoreDatabase: IScoreDatabase = LocalScoreDatabase.instance;
const scoreDatabase: IScoreDatabase = RemoteScoreDatabase.instance;

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

server.listen(4242, () => {
  console.log("%s listening at %s", server.name, server.url);
});
