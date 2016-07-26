$ = require 'jquery'
Backbone = require 'backbone'

Views = require './views'

Models = require './models'
  
Collections = require './collections'
Util = require 'agate/src/apputil'

{ MainController } = require 'agate/src/controllers'

BumblrChannel = Backbone.Radio.channel 'bumblr'

side_bar_data = new Backbone.Model
  entries: [
    {
      name: 'List Blogs'
      url: '#bumblr/listblogs'
    }
    {
      name: 'Settings'
      url: '#bumblr/settings'
    }
    ]

class Controller extends MainController
  sidebarclass: Views.BaseSideBarView
  sidebar_model: side_bar_data
  
  _make_sidebar: ->
    @init_page()
    sidebar = @_get_region 'sidebar'
    sidebar.empty()
    #console.log '@sidebarclass', @sidebarclass, Views
    view = new @sidebarclass
      model: @sidebar_model
    window.SBview = view
    sidebar.show view
    

  init_page: ->
    console.log 'init_page', @App
    view = new Views.BlogModal
    #@App.modal.show view
    
  set_header: (title) ->
    header = $ '#header'
    header.text title
    
  start: ->
    content = @_get_region 'content'
    sidebar = @_get_region 'sidebar'
    if content.hasView()
      console.log 'empty content....'
      content.empty()
    if sidebar.hasView()
      console.log 'empty sidebar....'
      sidebar.empty()
    @set_header 'Bumblr'
    @list_blogs()
    
  show_mainview: () ->
    @make_sidebar()
    view = new Views.MainBumblrView
    @_show_content view
    Util.scroll_top_fast()
    
  show_dashboard: () ->
    @make_sidebar()
    view = new Views.BumblrDashboardView
    @_show_content view
    Util.scroll_top_fast()
      
  list_blogs: () ->
    #console.log 'list_blogs called;'
    @_make_sidebar()
    console.log "sidebar created"
    blogs = BumblrChannel.request 'get_local_blogs'
    console.log 'blogs', blogs
    view = new Views.SimpleBlogListView
      collection: blogs
    @_show_content view
    
    
  view_blog: (blog_id) ->
    #console.log 'view blog called for ' + blog_id
    @_make_sidebar()
    host = blog_id + '.tumblr.com'
    collection = BumblrChannel.request 'make_blog_post_collection', host
    response = collection.fetch()
    response.done =>
      view = new Views.BlogPostListView
        collection: collection
      @_show_content view
      Util.scroll_top_fast()
      
  add_new_blog: () ->
    #console.log 'add_new_blog called'
    @_make_sidebar()
    view = new Views.NewBlogFormView
    @_show_content view
    Util.scroll_top_fast()
          
  settings_page: () ->
    #console.log 'Settings page.....'
    settings = BumblrChannel.request 'get_app_settings'
    view = new Views.ConsumerKeyFormView model:settings
    @_show_content view
    Util.scroll_top_fast()
    
module.exports = Controller

