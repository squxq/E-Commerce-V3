require("dotenv").config()

const express = require("express")
const app = express()
const User = require("./src/api/v1/models/User")

app.use(express.json())

app.get("/test", (req, res) => {
  res.status(200).json({
    message: "Server is up and running... (Test route)",
  })
})

app.get("/users", async (req, res) => {
  const users = await User.find()
  res.json(users)
})
app.get("/user-create", async (req, res) => {
  const user = new User({ username: "userTest" })
  await user.save().then(() => console.log(`User created`))
  res.send("User created \n")
})

app.use("*", (err, req, res, next) => {
  if (err) return res.status(500).json(err)
})

const connectDB = require("./db/connect")
const PORT = process.env.PORT || 5000

const start = async () => {
  try {
    // await connectDB(
    //   "mongodb://127.0.0.1:27017/docdb-2023-02-11-17-45-58.cluster-cxcmcghvbbkd.eu-central-1.docdb.amazonaws.com"
    // )
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
