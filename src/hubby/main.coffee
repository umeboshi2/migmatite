BootStrapAppRouter = require 'agate/src/bootstrap_router'

Controller = require './controller'


MainChannel = Backbone.Radio.channel 'global'
HubChannel = Backbone.Radio.channel 'hubby'

class Router extends BootStrapAppRouter
  appRoutes:
    'hubby': 'mainview'
    'hubby/viewmeeting/:id': 'show_meeting'
    
current_calendar_date = undefined
HubChannel.reply 'maincalendar:set-date', () ->
  cal = $ '#maincalendar'
  current_calendar_date = cal.fullCalendar 'getDate'

HubChannel.reply 'maincalendar:get-date', () ->
  current_calendar_date
  
MainChannel.reply 'applet:hubby:route', () ->
  controller = new Controller MainChannel
  router = new Router
    controller: controller

