require("dotenv").config()
require("express-async-errors")

// Express
const express = require("express")
const app = express()

// Other Dependencies
const helmet = require("helmet"),
  cors = require("cors"),
  xss = require("xss-clean"),
  compression = require("compression"),
  rateLimiter = require("express-rate-limit"),
  mongoSanitize = require("express-mongo-sanitize"),
  cookieParser = require("cookie-parser"),
  fileUpload = require("express-fileupload")

// Middleware
const errorHandler = require("./src/api/v1/middlewares/error-handler")

app.set("trusty proxy", 1)
app.use(
  rateLimiter({
    windowMs: 15 * 60 * 1000,
    max: 60,
  })
)

app.use(helmet())
app.use(cors({ origin: "*" }))
app.use(xss())
app.use(mongoSanitize())

// Gzip Compression
app.use(compression())

// Setup other middleware
app.use(express.json())
app.use(express.urlencoded({ extended: false }))
app.use(cookieParser())
app.use(fileUpload())

// /test Route
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

app.use("*", errorHandler)

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
