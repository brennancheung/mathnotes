fs   = require 'fs'
yaml = require 'js-yaml'

configPath = "#{__dirname}/../config.yml"
data = fs.readFileSync configPath, 'utf8'
parsed = yaml.load data

env = process.env.NODE_ENV || 'development'

config = parsed[env]

module.exports = config
