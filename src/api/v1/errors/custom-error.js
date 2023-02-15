/**
 *
 * @class CustomError
 */

class CustomError extends Error {
  constructor(message) {
    super(message)

    if (this.contructor === CustomError) {
      throw new Error("Abstract classes can't be instantiated...")
    }

    Object.setPrototypeOf(this, CustomError.prototype)
  }

  serializeErrors(type, code) {
    return {
      errorType: type,
      errorCode: code,
      message: this.message,
    }
  }
}

module.exports = CustomError
