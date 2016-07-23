Backbone = require 'backbone'
Marionette = require 'backbone.marionette'
require 'radio-shim'
  
require 'bootstrap'

#Models = require './models'

Views = require './views'
AppModel = require './appmodel'

require './clipboard'
require './messages'
require './documents'

#require 'bootstrap-fileinput-css'
#require 'bootstrap-fileinput-js'

#require 'vie'

{ BootstrapModalRegion } = require './regions'

prepare_app = require 'app-prepare'


MainChannel = Backbone.Radio.channel 'global'
MessageChannel = Backbone.Radio.channel 'messages'
ResourceChannel = Backbone.Radio.channel 'resources'

#FIXME
window.rchnnl = ResourceChannel

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
require 'editcontents/main'
require 'phaserdemo/main'
require 'hubby/main'
 


app = new Marionette.Application()

if __DEV__
  # DEBUG attach app to window
  window.App = app
  #console.warn "App is available #{app}"
  

# Start the Application
#app.start()

docs = ResourceChannel.request 'app-documents'
#docs.fetch ->
response = docs.fetch()
response.done -> 
  #root_doc = ResourceChannel.request 'get-document', 'startdoc'
  console.log "docs fetched", docs
  root_doc = docs.get 'startdoc'
  # DEBUG
  if __DEV__
    window.root_doc = root_doc
    window.tc = require 'teacup'
  if root_doc is undefined
    console.warn "root_doc is undefined!!"
  if root_doc is undefined
    console.error 'bad, bad, bad'
  else
    prepare_app app, AppModel, root_doc
    app.start()
    $('title').text root_doc.get 'title'
  
response.fail -> 
  #MessageChannel.request 'display-message', 'Error loading Site Documents', 'danger'
  $('h1').text "Failure"
  $('.col-sm-6').prepend('<a href="/">reload</a>')


module.exports = app


