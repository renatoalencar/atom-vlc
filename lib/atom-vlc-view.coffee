{$, View} = require 'atom-space-pen-views'
{CompositeDisposable} = require 'atom'

class VlcInfoView extends View
  @content: ->
    compact = atom.config.get 'atom-vlc.compactMode'
    compactClasses = unless compact then 'block' else 'inline-block'

    @div class: compactClasses + ' changes-when-compact', =>
      @img class: 'inline-block ' + (if compact then 'hide')
      @div class: 'info inline-block', =>
        @div class: compactClasses + ' changes-when-compact', =>
          @i class: 'fa fa-music'
          @span class: "songname"
        @div class: compactClasses + ' changes-when-compact', =>
          @i class: 'fa fa-group'
          @span class: "artist"
        @div class: compactClasses + ' changes-when-compact', =>
          @i class: 'fa fa-folder'
          @span class: "album"

  setSongName: (name) ->
    @find('.info .songname').text name ? 'Unknown'

  setArtist: (name) ->
    @find('.info .artist').text name ? 'Unknown'

  setAlbum: (name) ->
    @find('.info .album').text name ? 'Unknown'

  setCoverUrl: (url) ->
    if url?
      @find('img').attr 'src', url
      @find('img').show()
    else
      @find('img').hide()

class VlcControlView extends View
  @content: ->
    @div class: 'inline-block', =>
      @button
        class: "btn backward non-stopped"
        click: "backward"
        =>
          @i class: "fa fa-backward"
      @button
        class: "btn pause"
        click: 'pause'
        =>
          @i class: "fa fa-pause"
      @button
        class: 'btn stop non-stopped'
        click: 'stop'
        =>
          @i class: 'fa fa-stop'
      @button
        class: "btn forward non-stopped"
        click: "forward"
        =>
          @i class: "fa fa-forward"
      @button
        class: 'btn toggle-compact'
        click: 'turncompact'
        =>
          @i class: "fa fa-chevron-down"

  turncompact: ->
    # FIXME: I think it's too much hardcoded
    # when it depends to much from `parentView`

    if @parentView.compact
      @parentView.find('.changes-when-compact').each ->
        $(@).removeClass 'inline-block'
        $(@).addClass 'block'
      @parentView.find('img').removeClass 'hide'
      @find('.btn.toggle-compact i').addClass 'fa-chevron-down'
      @find('.btn.toggle-compact i').removeClass 'fa-chevron-up'
    else
      @parentView.find('.changes-when-compact').each ->
        $(@).removeClass 'block'
        $(@).addClass 'inline-block'
      @parentView.find('img').addClass 'hide'

      @find('.btn.toggle-compact i').removeClass 'fa-chevron-down'
      @find('.btn.toggle-compact i').addClass 'fa-chevron-up'

    @parentView.compact = not @parentView.compact

  backward: ->
    @parentView.backward()

  forward: ->
    @parentView.forward()

  pause: ->
    @parentView.pause()

  stop: ->
    @parentView.stop()

  setState: (state) ->
    switch state
      when 'playing'
        @find('.btn.pause i').addClass('fa-pause')
        @find('.btn.pause i').removeClass('fa-play')

        @find('.non-stopped').enable()
      when 'stopped'
        @find('.btn.pause i').removeClass('fa-pause')
        @find('.btn.pause i').addClass('fa-play')

        @find('.non-stopped').disable()
      when 'paused'
        @find('.btn.pause i').removeClass('fa-pause')
        @find('.btn.pause i').addClass('fa-play')

module.exports =
class AtomVlcView extends View
  UPDATE_TIME: 5000
  compact = atom.config.get 'atom-vlc.compactMode'

  @content: ->
    @div class: 'panel atom-vlc', =>
      @div class: 'panel-body padded', =>
        if @compact then @subview 'vlcControlView', new VlcControlView
        @subview 'vlcInfoView', new VlcInfoView
        @span class: 'text-error error'
        unless @compact then @subview 'vlcControlView', new VlcControlView

  initialize: (state) ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-vlc:toggleplay', =>
      @pause()

  attached: ->
    setInterval =>
      @vlc.update (data) => @update data
    , @UPDATE_TIME
    @vlc.update (data) => @update data

  update: (data) ->
    meta = data?.data?.information?.category?.meta

    @find('.error').text data?.error ? ''

    @vlcControlView.setState data?.data?.state ? "stopped"

    @vlcInfoView.setSongName meta?.title ? meta?.filename
    @vlcInfoView.setArtist meta?.artist
    @vlcInfoView.setAlbum meta?.album
    @vlcInfoView.setCoverUrl meta?.artwork_url

  backward: ->
    @vlc.prev (data) => @update data

  forward: ->
    @vlc.next (data) => @update data

  pause: ->
    @vlc.pause undefined, (data) => @update data

  stop: ->
    @vlc.stop (data) => @update data

  setVlc: (@vlc) ->

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  getElement: ->
    @element
