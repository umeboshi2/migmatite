$ = require 'jquery'
jQuery = require 'jquery'
_ = require 'underscore'
Backbone = require 'backbone'


class BaseAppModel extends Backbone.Model
  defaults:
    brand:
      name: 'Brand'
      url: '/'
    # FIXME frontdoor_app has to be statically required in
    # application.coffee
    frontdoor_app: 'frontdoor'
    hasUser: false
    frontdoor_sidebar:
      [
        {
          name: 'Home'
          url: '/'
        }
      ]
    applets: []
    regions: {}
    routes: []




appregions = 
  mainview: 'body'
  navbar: '#navbar-view-container'
  editbar: '#editor-bar-container'
  sidebar: '#sidebar'
  content: '#main-content'
  messages: '#messages'
  footer: '#footer'
  modal: '#modal'
  # this region is on navbar-view
  # depends on #navbar-view-container
  usermenu: '#user-menu'
  search: '#form-search-container'

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
    ]
  regions: appregions

module.exports = appmodel
