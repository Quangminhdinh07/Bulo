import pg from "pg";
import { config } from "./config.js";

export const pool = new pg.Pool({
  connectionString: config.DATABASE_URL,
  max: 10,
});

pool.on("error", (err) => {
  console.error("Idle database connection error:", err.message);
});
