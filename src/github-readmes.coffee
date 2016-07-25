$ = require 'jquery'
_ = require 'underscore'
Backbone = require 'backbone'
Marionette = require 'backbone.marionette'

{ BaseLocalStorageCollection } = require 'agate/src/lscollection'
{ BaseCollection } = require 'agate/src/collections'

MainChannel = Backbone.Radio.channel 'global'
MessageChannel = Backbone.Radio.channel 'messages'
GHReadMeChannel = Backbone.Radio.channel 'ghub-readme'

class GHubReadMe extends Backbone.Model
  url: ->
    "//github.com/#{id}/README.md"
    
  fetch: (options) ->
    options = _.extend options || {},
      dataType: 'text'
    super options

  parse: (response) ->
    return content: response

class GHubReadMeCollection extends BaseCollection
  model: GHubReadMe

  
GHReadMeChannel.reply 'get', (name) ->
  model = new StaticDocument
    id: name


  
module.exports =
  GHubReadMe: GHubReadMe
  
