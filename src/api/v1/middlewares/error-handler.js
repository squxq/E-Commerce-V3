const { CustomError } = require("../errors")

const errorHandler = (err, req, res, next) => {
  if (err instanceof CustomError) {
    return res.json({ assigned: true, error: err.setErrors() })
  }

  res
    .status(500)
    .json({ assigned: false, error: { message: "Unexpected server error..." } })
}

module.exports = errorHandler
