BootStrapAppRouter = require 'agate/src/bootstrap_router'

require './dbchannel'

Controller = require './controller'


MainChannel = Backbone.Radio.channel 'global'
DbChannel = Backbone.Radio.channel 'db'

class Router extends BootStrapAppRouter
  appRoutes:
    '': 'default_view'
    'frontdoor': 'default_view'
    'frontdoor/view/:name': 'view_module'
    'frontdoor/view_readme/:name': 'view_readme'
    
MainChannel.reply 'applet:frontdoor:route', () ->
  controller = new Controller MainChannel
  router = new Router
    controller: controller

