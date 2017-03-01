$ = require 'jquery'
jQuery = require 'jquery'
_ = require 'underscore'
Backbone = require 'backbone'
tc = require 'teacup'

BaseAppModel = require 'agate/src/appmodel'
{ BootstrapModalRegion } = require 'agate/src/regions'

NavbarView = require './navbar'


layout_template = tc.renderable () ->
  tc.div '#navbar-view-container'
  tc.div ".container-fluid", ->
    tc.div '.row', ->
      tc.div '.col-sm-10.col-sm-offset-1', ->
        tc.div '#messages'
    tc.div '#applet-content.row'
  tc.div '#footer'
  tc.div '#modal'

class MainPageLayout extends Backbone.Marionette.View
  template: layout_template
  regions:
    messages: '#messages'
    navbar: '#navbar-view-container'
    modal: new BootstrapModalRegion
    applet: '#applet-content'
    footer: '#footer'
    

appmodel = new BaseAppModel
  hasUser: false
  needUser: false
  brand:
    name: 'NWWW'
    url: '/'
  #frontdoor_app: 'xmlst'
  appView: MainPageLayout
  navbarView: NavbarView

module.exports = appmodel
