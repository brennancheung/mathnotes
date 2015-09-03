config = require './config'

verbose = process.env.VERBOSE is 'true' || config.verbose

class Logger
    constructor: ->
        # nothing to do

    debug: (msg) ->
        return unless verbose
        console.log msg

    info: (msg) ->
        return unless verbose
        console.log msg

    log: (msg) ->
        console.log msg

    error: (msg) ->
        console.log "[ERROR]: #{msg}"

logger = new Logger

module.exports = logger
