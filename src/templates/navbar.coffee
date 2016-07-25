$ = require 'jquery'
_ = require 'underscore'
tc = require 'teacup'


{ navbar_collapse_button
  dropdown_toggle } = require 'bootstrap-teacup-templates/coffee/buttons'
  
  
# { frontdoor_url } = require './common'


# Main Templates must use teacup.
# The template must be a teacup.renderable, 
# and accept a layout model as an argument.

########################################
# Templates
########################################
# FIXME -- no search form with action 
nav_pt_search = tc.renderable (appmodel) ->
  tc.form '#form-search.navbar-form.navbar-right', role:'search',
  method:'post', action:"#{appmodel.navbarSearchAction}", ->
    tc.div '.form-group', ->
      # FIXME search input placeholder needs to come from server
      tc.input '.form-control', name:'search-term', type:'search',
      placeholder:'Search...'
    tc.button '.btn.btn-default', type:'submit', name:'search-submit',
    value:'search', style:'display: none;', ->
      tc.raw '&#8594'
      
nav_pt_content = tc.renderable (appmodel) ->
  tc.div '.container-fluid', ->
    tc.div '.navbar-header', ->
      navbar_collapse_button 'navbar-view-collapse'
      tc.a '.navbar-brand', href:'#', appmodel.brand.name
    tc.div '#navbar-view-collapse.collapse.navbar-collapse', ->
      tc.ul '.nav.navbar-nav', ->
        # FIXME
        #console.log '_navitems', _navitems
        #console.log 'applets', doc.applets, doc
        for iname, item of appmodel.applets
          #item = _navitems[iname]
          #console.log "navitem", item, item.path
          isactive = ""
          if item.inside
            isactive = ".active"
          tc.li isactive, ->
            tc.a href:item.url,
            title:item.name, item.name
      tc.ul '#user-menu.nav.navbar-nav.navbar-right'
      tc.div '#form-search-container'

nav_pt = tc.renderable (appmodel) ->
  #tc.nav '#navbar-view.navbar.navbar-static-top.navbar-inverse',
  tc.nav '#navbar-view.navbar.navbar-static-top',
  xmlns:'http://www.w3.org/1999/xhtml', 'xml:lang':'en',
  role:'navigation', ->
    nav_pt_content appmodel
    
########################################
module.exports =
  nav_pt_search: nav_pt_search
  nav_pt: nav_pt
