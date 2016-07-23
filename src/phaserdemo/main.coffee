Backbone = require 'backbone'
Marionette = require 'backbone.marionette'

Util = require 'apputil'
BootStrapAppRouter = require 'bootstrap_router'

Controller = require './controller'


MainChannel = Backbone.Radio.channel 'global'

class Router extends BootStrapAppRouter
  appRoutes:
    'phaser': 'frontdoor'
    'phaser/view': 'frontdoor'
    'phaser/view/:name': 'view_page'

MainChannel.reply 'applet:phaserdemo:route', () ->
  controller = new Controller MainChannel
  router = new Router
    controller: controller

