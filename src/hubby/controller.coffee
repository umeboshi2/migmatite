{ MainController } = require 'agate/src/controllers'

MainChannel = Backbone.Radio.channel 'global'
MessageChannel = Backbone.Radio.channel 'messages'

class Controller extends MainController
  mainview: ->
    console.log "mainview"
    require.ensure [], () =>
      MeetingCalendarView  = require './calendarview'
      view = new MeetingCalendarView
      @_show_content view
    # name the chunk
    , 'hubby-mainview'

  show_meeting: (meeting_id) ->
    require.ensure [], () =>
      { MainMeetingModel } = require './collections'
      ShowMeetingView  = require './meetingview'
      meeting = new MainMeetingModel
        id: meeting_id
      response = meeting.fetch()
      response.done =>
        view = new ShowMeetingView
          model: meeting
        @_show_content view
      response.fail =>
        MessageChannel.request 'display-message', 'Failed to load meeting', 'danger'
    # name the chunk
    , 'hubby-meetingview'

    
module.exports = Controller

