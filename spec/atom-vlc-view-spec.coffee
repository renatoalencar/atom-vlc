AtomVlcView = require '../lib/atom-vlc-view'

describe "When AtomVlcView update", ->
  it "tests info", ->
    view = new AtomVlcView

    update =
      data:
        state: 'playing'
        information:
          category:
            meta:
              title: 'Dilema'
              artist: 'Vivendo do Ocio'
              album: 'Teorias de Amor Moderno'
              artwork_url: 'img/cover.jpg' # Just something random

    runs ->
      view.update update
      expect(view.find('.songname').text()).toBe 'Dilema'
      expect(view.find('.artist').text()).toBe 'Vivendo do Ocio'
      expect(view.find('.album').text()).toBe 'Teorias de Amor Moderno'
      expect(view.find('img').attr 'src').toBe 'img/cover.jpg'

  it 'tests buttons', ->
    view = new AtomVlcView

    update =
      data:
        state: 'stopped'

    runs ->
      view.update update

      expect(view.find('.songname').text()).toBe 'Unknown'
      expect(view.find('.artist').text()).toBe 'Unknown'
      expect(view.find('.album').text()).toBe 'Unknown'

      expect(view.find('.btn.pause').isDisabled()).toBe false
      expect(view.find('.btn.forward').isDisabled()).toBe true
      expect(view.find('.btn.stop').isDisabled()).toBe true
      expect(view.find('.btn.backward').isDisabled()).toBe true

      update.data.state = 'playing'
      view.update update

      expect(view.find('.btn.pause').isDisabled()).toBe false
      expect(view.find('.btn.forward').isDisabled()).toBe false
      expect(view.find('.btn.stop').isDisabled()).toBe false
      expect(view.find('.btn.backward').isDisabled()).toBe false
