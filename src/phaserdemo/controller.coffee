{ MainController } = require 'agate/src/controllers'

MainChannel = Backbone.Radio.channel 'global'
MessageChannel = Backbone.Radio.channel 'messages'

class Controller extends MainController
  _view_resource: ->
    @_make_editbar()
    require.ensure [], () =>
      { PhaserView } = require './views'
      view = new PhaserView()
      @_show_content view
    # name the chunk
    , 'phaser-view-resource'
    
  mainview: ->
    @_view_resource()

module.exports = Controller

