$ = require 'jquery'
_ = require 'underscore'
Backbone = require 'backbone'
Marionette = require 'backbone.marionette'

{ BaseLocalStorageCollection } = require 'lscollection'
{ BaseCollection } = require 'collections'

MainChannel = Backbone.Radio.channel 'global'
MessageChannel = Backbone.Radio.channel 'messages'
DocChannel = Backbone.Radio.channel 'static-documents'

class StaticDocumentJson extends Backbone.Model
  url: ->
    "/assets/documents/#{@id}.json"

class StaticDocument extends Backbone.Model
  url: ->
    "/assets/documents/#{@id}.md"
  
  fetch: (options) ->
    options = _.extend options || {},
      dataType: 'text'
    console.log "new fetch options", options
    super options

  parse: (response) ->
    return content: response
    
class StaticDocumentCollection extends BaseCollection
  model: StaticDocument
  
  
DocChannel.reply 'get-document', (name) ->
  model = new StaticDocument
    id: name


  
module.exports =
  StaticDocument: StaticDocument
  

