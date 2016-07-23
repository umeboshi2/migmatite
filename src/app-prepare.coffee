Backbone = require 'backbone'
Marionette = require 'backbone.marionette'

#Models = require './models'

Views = require './views'


{ BootstrapModalRegion
  SlideDownRegion } = require './regions'



MainChannel = Backbone.Radio.channel 'global'


prepare_app = (app, appmodel) ->
  regions = appmodel.get 'regions'
  if 'modal' of regions
    regions.modal = BootstrapModalRegion
  if 'navbar' of regions
    regions.navbar = new SlideDownRegion
      el: regions.navbar
      speed: 'slow'
  if 'content' of regions
    regions.content = new SlideDownRegion
      el: regions.content
      
  # set up region manager
  region_manager = new Backbone.Marionette.RegionManager
  region_manager.addRegions regions

  # set triggers on regions
  navbar = region_manager.get 'navbar'
  navbar.on 'show', =>
      #console.log "we have users for this app....."
      # trigger the display message to create
      # the user menu on the navbar
      MainChannel.trigger 'appregion:navbar:displayed'

  # set more main:app handlers
  MainChannel.reply 'main:app:object', ->
    app
  MainChannel.reply 'main:app:regions', ->
    region_manager
  MainChannel.reply 'main:app:get-region', (region) ->
    region_manager.get region

  # Prepare what happens to the app when .start() is called.
  app.on 'start', ->
    # build routes first
    frontdoor = appmodel.get 'frontdoor_app'
    MainChannel.request "applet:#{frontdoor}:route"
    for applet in appmodel.get 'applets'
      signal = "applet:#{applet.appname}:route"
      #console.log "create signal #{signal}"
      MainChannel.request signal
    # build main page layout
    MainChannel.request 'mainpage:init', appmodel
    # start the approutes
    # the 'frontdoor_app' should handle the '' <blank>
    # route for the initial page.
    Backbone.history.start() unless Backbone.history.started



module.exports = prepare_app


