Backbone = require 'backbone'
Marionette = require 'backbone.marionette'
tc = require 'teacup'
marked = require 'marked'

MainChannel = Backbone.Radio.channel 'global'

class SimpleModView extends Backbone.Marionette.View
  template: tc.renderable (model) ->
    tc.div '.model-type.list-group-item', ->
      tc.p ->
        href = "#frontdoor/view/#{model.id}"
        tc.strong ->
          tc.a href:href, model.id
      tc.div ->
        href = "#frontdoor/view_readme/#{model.id}"
        tc.a '.pull-right', href:href, "README"
      tc.p ->
        tc.text model.description
      tc.text "Depends on:"
      tc.ul ->
        for dep of model.dependencies
          tc.li ->
            tc.strong "#{dep}"
            tc.text " - #{model.dependencies[dep].description}"
          

class ModuleCollectionView extends Backbone.Marionette.CollectionView
  childView: SimpleModView
  

class ModulePageView extends Backbone.Marionette.View
  template: tc.renderable (model) ->
    tc.div '.module-view', ->
      tc.p ->
        href = "#frontdoor/view/#{model.id}"
        tc.strong ->
          tc.a href:href, model.id
      tc.div ->
        href = "#frontdoor/view_readme/#{model.id}"
        tc.a '.pull-right', href:href, "README"
      tc.p ->
        tc.text model.description
      tc.text "Depends on:"
      tc.ul ->
        for dep of model.dependencies
          tc.li ->
            tc.strong "#{dep}"
            tc.text " - #{model.dependencies[dep].description}"
          
  

class ReadMeView extends Backbone.Marionette.View
  template: tc.renderable (model) ->
    data = marked model.content
    tc.article '.document-view.content', ->
      tc.div '.body', ->
        tc.raw data
    
module.exports =
  ModuleCollectionView: ModuleCollectionView
  ModulePageView: ModulePageView
  ReadMeView: ReadMeView
  
