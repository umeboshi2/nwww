Backbone = require 'backbone'
Marionette = require 'backbone.marionette'
tc = require 'teacup'

{ MainController } = require 'agate/src/controllers'
{ SlideDownRegion } = require 'agate/src/regions'
Views = require './views'

MainChannel = Backbone.Radio.channel 'global'
MessageChannel = Backbone.Radio.channel 'messages'
DbChannel = Backbone.Radio.channel 'db'

frontdoor_template = tc.renderable () ->
  tc.div '#main-content.col-sm-10.col-sm-offset-1'

class FrontdoorLayout extends Backbone.Marionette.View
  template: frontdoor_template
  regions: ->
    content: new SlideDownRegion
      el: '#main-content'
      speed: 'slow'
  

class Controller extends MainController
  layoutClass: FrontdoorLayout
  collection: DbChannel.request 'get-collection'
  
  _view_module: (model) ->
    @setup_layout_if_needed()
    view = new Views.ModulePageView
      model: model
    @layout.showChildView 'content', view
    
  view_module: (id) ->
    model = @collection.get id
    @_view_module model

  _view_readme: (model) ->
    @setup_layout_if_needed()
    view = new Views.ReadMeView
      model: model
    @layout.showChildView 'content', view
      
  view_readme: (id) ->
    model = DbChannel.request 'new-readme', id
    response = model.fetch()
    response.done =>
      @_view_readme model
    response.fail =>
      MessageChannel.request 'danger', "Failed to get readme #{id}"

  default_view: ->
    @setup_layout_if_needed()
    response = @collection.fetch()
    response.done =>
      view = new Views.ModuleCollectionView
        collection: @collection
      @layout.showChildView 'content', view
    response.fail =>
      MessageChannel.request 'danger', 'Failed to get node modules'

module.exports = Controller

