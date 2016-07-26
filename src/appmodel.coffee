$ = require 'jquery'
jQuery = require 'jquery'
_ = require 'underscore'
Backbone = require 'backbone'

{ BaseAppModel
  appregions } = require 'agate/src/appmodel'

appmodel = new BaseAppModel
  hasUser: true
  brand:
    name: 'Migmatite'
    url: '/'
  #FIXME
  # applets listed here still need to be required in
  # application.coffee
  applets:
    [
      {
        appname: 'phaserdemo'
        name: 'Phaser'
        url: '#phaser'
      }
      {
        appname: 'hubby'
        name: 'Hubby'
        url: '#hubby'
      }
      {
        appname: 'dbdocs'
        name: 'DB Docs'
        url: '#dbdocs'
      }
      {
        appname: 'bumblr'
        name: 'Bumblr'
        url: '#bumblr'
      }
    ]
  regions: appregions

module.exports = appmodel
