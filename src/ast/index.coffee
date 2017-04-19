
{ readdirSync } = require 'fs'

module.exports = @

for astModule in readdirSync("#{__dirname}").map((file) -> /^([^\.]+)\..*$/.exec(file)[1])
    @[key] = value for key, value of require "./#{astModule}"
