AtomVlcView = require './atom-vlc-view'
{CompositeDisposable} = require 'atom'
Vlc = require './vlc'

module.exports = AtomVlc =
  config:
    password:
      type: "string"
      default: ''
      description: "VLC Web interface password"
    compactMode:
      type: "boolean"
      default: false
    host:
      type: 'string'
      default: 'localhost'
      description: 'The host running VLC (IP address, hostname, etc)'
  atomVlcView: null
  bottomPanel: null
  subscriptions: null
  vlc: null

  activate: (state) ->
    @vlc = new Vlc
      password: atom.config.get "atom-vlc.password"
      server: atom.config.get 'atom-vlc.host'
    @state = state

    @atomVlcView = new AtomVlcView(state.atomVlcViewState)
    @atomVlcView.setVlc @vlc

    @bottomPanel = atom.workspace.addBottomPanel(item: @atomVlcView.getElement(), visible: false)

    @subscriptions = new CompositeDisposable

    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-vlc:toggle': => @toggle()
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-vlc:toggle-compact': => @compact()

  deactivate: ->
    @bottomPanel.destroy()
    @subscriptions.dispose()
    @atomVlcView.destroy()

  serialize: ->
    atomVlcViewState: @atomVlcView.serialize()

  toggle: ->
    if @bottomPanel.isVisible()
      @bottomPanel.hide()
    else
      @bottomPanel.show()
