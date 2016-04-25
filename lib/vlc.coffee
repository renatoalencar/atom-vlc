
http = require 'http'

module.exports =
class Vlc
  defaults:
    server: 'localhost'
    port: 8080
    user: ''

  constructor: (params) ->
    {@server, @port, @user, @password} = params

    @server = @defaults.server unless @server?
    @port = @defaults.port unless @port?
    @user = @defaults.user unless @user?

  build_options: (command, param) ->
    host: @server
    port: @port
    path: if command? then "/requests/status.json?command=#{command}&#{param}" else "/requests/status.json"
    auth: "#{@user}:#{@password}"

  request: (command, param, handler) ->
    options = @build_options command, param
    req = http.get options, (res) ->
      output = ''
      res.setEncoding 'utf8'

      res.on 'data', (chunk) ->
        output += chunk

      res.on 'end', ->
        data = JSON.parse output
        handler(data: data) if handler?

    req.on 'error', (err) ->
      handler(error: err) if handler?

    req.end()

  update: (handler) ->
    @request undefined, undefined, handler

  add_and_start: (uri, handler) ->
    @request 'in_play', "input=#{encodeURI(uri)}", handler

  add_to_playlist: (uri, handler) ->
    @request 'in_enqueue', "input=#{encodeURI(uri)}", handler

  play: (id, handler) ->
    @request 'pl_play', (if id? then "id=#{id}" else ""), handler

  pause: (id, handler) ->
    @request 'pl_pause', (if id? then "id=#{id}" else ""), handler

  force_resume: (handler) ->
    @request 'pl_forceresume', '', handler

  force_pause: (handler) ->
    @request 'pl_forcepause', '', handler

  stop: (handler) ->
    @request 'pl_stop', '', handler

  next: (handler) ->
    @request 'pl_next', '', handler

  prev: (handler) ->
    @request 'pl_previous', '', handler

  delete: (id, handler) ->
    @request "pl_delete", "id=#{id}", handler

  empty: (handler) ->
    @request 'pl_empty', '', handler

  rate: (rate, handler) ->
    @request 'rate', "val=#{rate}", handler

  aspect_ratio: (ar, handler) ->
    @request 'aspectratio', "val=#{ar}", handler

  sort: (id, val, handler) ->
    @request 'pl_sort', "id=#{id}&val=#{val}", handler

  random: (handler) ->
    @request 'pl_random', '', handler

  loop: (handler) ->
    @request 'pl_loop', '', handler

  repeat: (handler) ->
    @request 'pl_repeat', '', handler

  fullscreen: (handler) ->
    @request 'fullscreen', '', handler

  set_volume: (val, handler) ->
    @request 'volume', "val=#{val}", handler
