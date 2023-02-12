const { Pool } = require("pg")

const pool = new Pool({
  host: process.env.POSTGRESQL_HOST,
  port: process.env.POSTGRESQL_PORT,
  user: process.env.POSTGRESQL_USER,
  password: process.env.POSTGRESQL_PW,
  database: process.env.POSTGRESQL_DATABASE,
  max: 15,
  idleTimeoutMillis: 10000,
  connectionTimeoutMillis: 2000,
})

module.exports = pool
