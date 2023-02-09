const express = require("express")
const app = express()

app.use(express.json())

app.get("test", (req, res) => {
  res.status(200).json({
    message: "Server is up and running...",
    req,
    res,
  })
})

app.listen(port, () => {
  console.log(`Server is listening on port: ${port}...`)
})
