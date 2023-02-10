const express = require("express")
const app = express()

app.use(express.json())

app.get("/test", (req, res) => {
  res.status(200).json({
    message: "Server is up and running... (Test route)",
  })
})

app.use("*", (err, req, res, next) => {
  if (err) return res.status(500).json(err)
})

const port = 5000

app.listen(port, () => {
  console.log(`Server is listening on port: ${port}...`)
})
