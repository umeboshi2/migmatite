Backbone = require 'backbone'

{ BaseCollection } = require 'agate/src/collections'

HubChannel = Backbone.Radio.channel 'hubby'

class SimpleMeetingModel extends Backbone.Model

class MainMeetingModel extends Backbone.Model
  url: () ->
    '/rest/v0/main/meeting/' + @id
  parse: (response) ->
    response.data

    
class MeetingCollection extends BaseCollection
  model: SimpleMeetingModel
  url: '/rest/v0/main/meeting'

main_meeting_list = new MeetingCollection
HubChannel.reply 'meetinglist', ->
  main_meeting_list

module.exports =
  MeetingCollection: MeetingCollection
  MainMeetingModel: MainMeetingModel
  
