Backbone = require 'backbone'
Marionette = require 'backbone.marionette'

DbChannel = Backbone.Radio.channel 'db'

class MainModulesModel extends Backbone.Model
  url: '/api/0/modules'

class NpmModuleModel extends Backbone.Model
  url: '/api/0/modules/*'

class NpmModuleCollection extends Backbone.Collection
  model: NpmModuleModel
  url: '/api/0/modules'
  parse: (response) ->
    @full_response = response
    deps = []
    for dep of response.dependencies
      response.dependencies[dep].id = dep
      deps.push response.dependencies[dep]
    return deps

class ReadMeModel extends Backbone.Model
  urlRoot: '/api/0/module/readme'
  

module_collection = new NpmModuleCollection
DbChannel.reply 'get-collection', ->
  module_collection

DbChannel.reply 'new-readme', (name) ->
  new ReadMeModel {id: name}
  
  
  
#module.exports = null

