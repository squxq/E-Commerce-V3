require("dotenv").config()

const express = require("express")
const app = express()

const helmet = require("helmet")
app.use(helmet())

app.use(express.json())

const { pool } = require("./db")

app.get("/test", async (req, res) => {
  try {
    const products = await pool.query("SELECT * FROM product")

    res.status(200).json({
      message: "Server is up and running... (Test route)",
      pg: `${products}: empty object meaning the db is up and running... (Test route)`,
    })
  } catch (err) {
    res.status(500).json({
      message: `Something went wrong \n Error: ${err}`,
    })
  }
})

app.use("*", (err, req, res, next) => {
  if (err) return res.status(500).json(err)
})

const PORT = process.env.SERVER_PORT

const start = async () => {
  try {
    app.listen(PORT, () => {
      console.log(
        `Server is connected to database and listening on port: ${PORT}...`
      )
    })
  } catch (err) {
    console.log(`Something went wrong. \n Error: ${err.message}`)
  }
}

start()
