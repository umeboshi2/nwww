$ = require 'jquery'
Backbone = require 'backbone'
Marionette = require 'backbone.marionette'
tc = require 'teacup'

Util = require 'agate/src/apputil'
initialize_page = require 'agate/src/app-initpage'

require 'bootstrap'

MainChannel = Backbone.Radio.channel 'global'
  
class MainPageLayout extends Backbone.Marionette.View
  template: tc.renderable ->
    tc.div '.container-fluid', ->
      tc.div '#applet-content.row'
  regions:
    applet: '#applet-content'
    
if __DEV__
  console.warn "__DEV__", __DEV__, "DEBUG", DEBUG
  Backbone.Radio.DEBUG = true
  #FIXME
  window.chnnl = MainChannel
  
######################
# start app setup

MainChannel.reply 'mainpage:init', (appmodel) ->
  # get the app object
  app = MainChannel.request 'main:app:object'
  # initialize the main view
  #app.showView new MainPageLayout
  initialize_page app
  # emit the main view is ready
  MainChannel.trigger 'mainpage:displayed'


MainChannel.on 'mainpage:displayed', ->
  # this handler is useful if there are views that need to be
  # added to the navbar.  The navbar should have regions to attach
  # the views
  # --- example ---
  # view = new view
  # aregion = MainChannel.request 'main:app:get-region', aregion
  # aregion.show view

  app = MainChannel.request 'main:app:object'
  appmodel = MainChannel.request 'main:app:appmodel'

module.exports = {}
