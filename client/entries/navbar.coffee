tc = require 'teacup'

{ navbar_collapse_button
  dropdown_toggle } = require 'agate/src/templates/buttons'

MainChannel = Backbone.Radio.channel 'global'

nav_pt_content = tc.renderable (appmodel) ->
  user_here = false
  #console.log "User is", current_user
  tc.div ".#{appmodel.container or 'container'}", ->
    tc.div '.navbar-header', ->
      navbar_collapse_button 'navbar-view-collapse'
      tc.a '.navbar-brand', href:appmodel.brand.url, appmodel.brand.name
    tc.div '#navbar-view-collapse.collapse.navbar-collapse', ->
      tc.ul '.nav.navbar-nav.nav-pills', ->
        applets = {}
        for applet in appmodel.applets
          applets[applet.appname] = applet
        #console.log "applets", applets
        for entry in appmodel.applet_menus
          #console.log 'menu entry', entry
          if entry?.applets
            # check if empty before making dropdown
            empty = true
            for appname in entry.applets
              # FIXME better logic needed
              if applets[appname].needUser and not user_here
                ''
              else
                empty = false
            if empty
              continue
            tc.li '.dropdown', ->
              tc.a '.dropdown-toggle', 'data-toggle':'dropdown', ->
                tc.text entry.label
                tc.b '.caret'
              tc.ul '.dropdown-menu', ->
                for appname in entry.applets
                  if applets[appname].needUser and not user_here
                    continue
                  tc.li appname:applets[appname].appname, ->
                    tc.a href:applets[appname].url, applets[appname].name
          else
            tc.li ->
              tc.a href:entry.url, entry.label
      tc.ul '#user-menu.nav.navbar-nav.navbar-right'
      tc.div '#form-search-container'

navbar_template = tc.renderable (appmodel) ->
  tc.nav '#navbar-view.navbar.navbar-static-top.navbar-default',
  xmlns:'http://www.w3.org/1999/xhtml', 'xml:lang':'en',
  role:'navigation', ->
    nav_pt_content appmodel

class NavbarView extends Backbone.Marionette.View
  template: navbar_template
  regions:
    appletmenus: '#applet-menus'
    mainmenu: '#main-menu'
    
########################################
module.exports = NavbarView
