Backbone = require 'backbone'
Marionette = require 'backbone.marionette'
require 'radio-shim'
  
require 'bootstrap'

#Models = require './models'

Views = require './views'
AppModel = require './appmodel'

require './clipboard'
require './messages'
require './static-documents'
require './github-readmes'

#require 'bootstrap-fileinput-css'
#require 'bootstrap-fileinput-js'

#require 'vie'

{ BootstrapModalRegion } = require './regions'

prepare_app = require 'app-prepare'


MainChannel = Backbone.Radio.channel 'global'
MessageChannel = Backbone.Radio.channel 'messages'
DocChannel = Backbone.Radio.channel 'static-documents'

#FIXME
window.dchnnl = DocChannel

if __DEV__
  console.warn "__DEV__", __DEV__, "DEBUG", DEBUG
  Backbone.Radio.DEBUG = true

initialize_page = (app, root_doc) ->
  regions = MainChannel.request 'main:app:regions'
  appmodel = MainChannel.request 'main:app:appmodel'
  # create layout view
  layout = new Views.MainPageLayout
  # set the main layout view to create and show
  # the navbar when it is shown.  This assures us
  # that the $el is present in the DOM. 
  layout.on 'show', =>
    navbar = new Views.BootstrapNavBarView
      model: appmodel
    navbar_region = regions.get 'navbar'
    navbar_region.show navbar
    messages = new Views.MessagesView
      collection: MessageChannel.request 'messages'
    messages_region = regions.get 'messages'
    messages_region.show messages
    
  # Show the main layout
  mainview = regions.get 'mainview'
  mainview.show layout

######################
# start app setup

# use a signal to request appmodel
MainChannel.reply 'main:app:appmodel', ->
  AppModel


MainChannel.reply 'mainpage:init', (appmodel, root_doc) =>
  # get the app object
  app = MainChannel.request 'main:app:object'
  # initialize the main view
  initialize_page app, root_doc
  # emit the main view is ready
  MainChannel.trigger 'mainpage:displayed'


MainChannel.on 'appregion:navbar:displayed', ->
  # this handler is useful if there are views that need to be
  # added to the navbar.  The navbar should have regions to attach
  # the views
  # --- example ---
  # view = new view
  # aregion = MainChannel.request 'main:app:get-region', aregion
  # aregion.show view
  if __DEV__
    console.warn "__DEV__ navbar displayed"

# require applets
# Applets need to be loaded to provide
# urls for the app routers
# 
# FIXME - how to get this to work?
#for applet in AppModel.get 'applets'
#  window.appletfoo = applet
#  console.log "require #{applet.appname}/main"
#  require "#{applet.appname}/main"
#for applet in AppModel.get 'applets'
#  console.log "require #{applet.appname}/main"
#  require.context "#{applet.appname}", false, /^main.coffee$/
#  require "#{applet.appname}/main"
require 'frontdoor/main'
require 'dbdocs/main'
require 'phaserdemo/main'
require 'hubby/main'
 


app = new Marionette.Application()

prepare_app app, AppModel

if __DEV__
  # DEBUG attach app to window
  window.App = app
  #console.warn "App is available #{app}"
  

# Start the Application
app.start()

module.exports = app


