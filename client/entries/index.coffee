Marionette = require 'backbone.marionette'

require './base'

prepare_app = require 'agate/src/app-prepare'

appmodel = require './base-appmodel'

appmodel.set 'applets', []

brand = appmodel.get 'brand'
brand.url = '#'
appmodel.set brand: brand
  
MainChannel = Backbone.Radio.channel 'global'
MessageChannel = Backbone.Radio.channel 'messages'

applets = []

appmodel.set 'applets', applets

appmodel.set 'applet_menus', [
  {
    label: 'Hello'
    single_applet: 'frontdoor'
    url: '#frontdoor/hello'
  }
  ]

# use a signal to request appmodel
MainChannel.reply 'main:app:appmodel', ->
  appmodel

######################
# require applets
require '../applets/frontdoor/main'

app = prepare_app appmodel

if __DEV__
  window.App = app

# start the app
app.start()

module.exports = app


