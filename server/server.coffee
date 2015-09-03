config     = require './config'
logger     = require './logger'

http       = require 'http'
express    = require 'express'

class Server
    constructor: ->
        #

    start: (_config=config) ->
        app = express()

        app.use (req, res, next) ->
            logger.info "#{req.method} #{req.url}"
            next()

        app.use '/', express.static "#{__dirname}/../build"

        app.all '*', (req, res) ->
            res.status(404).send 'not found'

        app.use (err, req, res, next) ->
            logger.log '--------------------------------------------------------------------------------'
            logger.log err.stack
            res.status(500).send "<pre>#{err.stack}</pre>"

        @port = _config.server.port
        logger.info "Starting server on port #{@port}."

        @instance = http.createServer(app)
        @instance.listen @port

        return @instance

    stop: ->
        if @instance
            logger.info "Stopping server."
            @instance.close()
        else
            logger.info "Server is not currently running."

module.exports = Server

