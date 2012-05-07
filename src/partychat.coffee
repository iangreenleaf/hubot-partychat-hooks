Robot = require("hubot").robot()
Adapter = require("hubot").adapter()

HTTP = require "http"
URL = require "url"
QS = require "querystring"

class PartychatAdapter extends Adapter
  constructor: (robot) ->
    @post_hook   = process.env.HUBOT_POST_ENDPOINT
    super robot

    robot.router.post '/hubot/partychat', (request, response) =>
      content = ""
      request.addListener "data", (data) ->
        content += data.toString()
      request.addListener "end", =>
        [ text, user, line ] =  /^\[([^\]]+)\] (.*)/.exec QS.parse(content).body
        @receive new Robot.TextMessage @userForName(user), line
        response.writeHead 200, 'Content-Type': 'text/plain'
        response.end()

  run: ->

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

exports.use = (robot) ->
  new PartychatAdapter robot
