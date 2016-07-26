Backbone = require 'backbone'
Marionette = require 'backbone.marionette'

Util = require 'agate/src/apputil'
BootStrapAppRouter = require 'agate/src/bootstrap_router'

Controller = require './controller'

#require './documents'

MainChannel = Backbone.Radio.channel 'global'
BumblrChannel = Backbone.Radio.channel 'bumblr'



class Router extends BootStrapAppRouter
  appRoutes:
    'bumblr': 'start'
    'bumblr/settings': 'settings_page'
    'bumblr/dashboard': 'show_dashboard'
    'bumblr/listblogs': 'list_blogs'
    'bumblr/viewblog/:id': 'view_blog'
    'bumblr/addblog' : 'add_new_blog'

    
MainChannel.reply 'applet:bumblr:route', () ->
  controller = new Controller MainChannel
  blog_collection = BumblrChannel.request 'get_local_blogs'
  #response = blog_collection.fetch()
  #response.done =>
  #  router = new Router
  #    controller: controller
  # FIXME use better lscollection
  blog_collection.fetch()
  router = new Router
    controller: controller
    
