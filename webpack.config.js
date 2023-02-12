const path = require("path")
const webpack = require("webpack")

module.exports = {
  target: "node",
  mode: "development", //production
  entry: {
    main: path.resolve(__dirname, "main.js"),
  },
  output: {
    path: path.resolve(__dirname, "dist"),
    filename: "[name].bundle.js",
    clean: true,
  },
  //loaders - handle other types of files (because it only knows js & json)
  //plugins
  plugins: [new webpack.IgnorePlugin({ resourceRegExp: /^pg-native$/ })],
}
