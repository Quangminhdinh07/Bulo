import express from "express";
import { Request, Response } from "express";
import { errorHandler } from "./middleware/errorHandler.js";
import { pool } from "./db.js";

export const app = express();

app.use(express.json());

app.get("/health", async (_req: Request, res: Response) => {
  try {
    await pool.query("SELECT 1");
    res.json({ status: "ok", db: "ok" });
  } catch {
    res.status(503).json({ status: "error", db: "down" });
  }
});

app.use(errorHandler);
