BootStrapAppRouter = require 'agate/src/bootstrap_router'

Controller = require './controller'


MainChannel = Backbone.Radio.channel 'global'

class Router extends BootStrapAppRouter
  appRoutes:
    'phaser': 'mainview'

MainChannel.reply 'applet:phaserdemo:route', () ->
  controller = new Controller MainChannel
  router = new Router
    controller: controller

