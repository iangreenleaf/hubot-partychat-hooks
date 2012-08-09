Robot = require("hubot").Robot
Adapter = require("hubot").Adapter
TextMessage = require("hubot").TextMessage
HTTP = require "http"
URL = require "url"
QS = require "querystring"

class PartychatAdapter extends Adapter
  constructor: (robot) ->
    @post_hook   = process.env.HUBOT_POST_ENDPOINT
    super robot

    robot.router.post '/partychat', (request, response) =>
      ifMatch = (regexp, callback) ->
        args = regexp.exec request.body.body
        callback(args[1..]...) if args?
      ifMatch /^\[([^\]]+)\] (.*)/, (user, line) =>
        msg = new TextMessage @userForId(user), line
        @receive msg
      ifMatch /^'([^']+)' is now known as '([^']+)'/, (oldName, newName) =>
        user = @userForId(oldName)
        user.name = newName
        @robot.brain.data.users[newName] = user
        delete @robot.brain.data.users[oldName]
      response.writeHead 200, 'Content-Type': 'text/plain'
      response.end()

  run: ->
    @emit "connected"

  send: (user, strings...) ->
    for str in strings
      url = URL.parse @post_hook
      data = QS.stringify body: str
      opts = {
        host: url.hostname
        path: url.pathname
        port: 80
        method: "POST"
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Content-Length': data.length
        }
      }

      request_failed = (message) ->
        console.log "Sending message failed!"
        console.log message

      request = HTTP.request opts, (response) ->
        unless response.statusCode == 200
          request_failed "Received status code #{response.statusCode}"
      request.on "error", (e) -> request_failed e.message
      request.end data

  reply: (user, strings...) ->
    for str in strings
      @send user, "#{user.name}: #{str}"
      
  command: (command, strings...) ->
      @send command, strings

exports.use = (robot) ->
  new PartychatAdapter robot
