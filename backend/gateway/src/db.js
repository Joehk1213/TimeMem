import pg from "pg";

const { Pool } = pg;

export const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  max: 10,
  idleTimeoutMillis: 30_000,
  connectionTimeoutMillis: 5_000
});

pool.on("error", (error) => {
  console.error(JSON.stringify({ event: "database_pool_error", message: error.message }));
});

export async function query(text, values = []) {
  return pool.query(text, values);
}

export async function pingDatabase() {
  const result = await query("SELECT 1 AS ok");
  return result.rows[0]?.ok === 1;
}
