os = require 'os'
path = require 'path'
http = require 'http'
fs = require 'fs'
childProcess = require 'child_process'

express = require 'express'
serveIndex = require 'serve-index'
marked = require 'marked'
Prism = require 'prismjs'
tc = require 'teacup'

# Set the default environment to be `development`
process.env.NODE_ENV = process.env.NODE_ENV or 'development'

UseMiddleware = false or process.env.__DEV_MIDDLEWARE__ is 'true'
PORT = process.env.NODE_PORT or 8081
HOST = process.env.NODE_IP or 'localhost'


dependency_section = tc.renderable (root, name, dep) ->
  tc.li ->
    href = path.join root, name
    tc.a href:href, name
    if dep?.dependencies
      #console.log root, 'node_modules', name
      #nroot = path.join root, 'node_modules', name
      nroot = path.join href, 'node_modules'
      #console.log "NROOT", nroot
      tc.ul ->
        for ndep of dep.dependencies
          dirname = path.join nroot, ndep
          if fs.existsSync dirname
            s = fs.statSync dirname
            if s.isDirectory()
              dependency_section nroot, ndep, dep.dependencies[ndep]
          else
            dependency_section '/', ndep, dep.dependencies[ndep]
            
main_template = tc.renderable (npmls) ->
  tc.doctype()
  tc.html ->
    tc.head
    tc.body ->
      tc.ul ->
        for dep of npmls.dependencies
          dependency_section "/", dep, npmls.dependencies[dep]


# create express app 
app = express()

# get dependency tree
childProcess.execFile 'npm', ['ls', '--json'], (err, stdout, stdin) ->
  if (err)
    throw err
  lsdir = JSON.parse stdout.toString()
  app.get '/', (req, res) ->
    res.send main_template lsdir

  # FIXME I don't want to use serve-index
  app.use '/', serveIndex './node_modules'
    
  app.get '/*', (req, res, next) ->
    #console.log "req.params", req.params
    filename = req.params[0]
    #console.log "FILENAME", filename
    filename = path.join 'node_modules', filename
    data = fs.readFileSync(filename).toString()
    converted = data
    if filename.endsWith '.md'
      converted =  marked data
    else if filename.endsWith '.js'
      # FIXME include css in response
      converted = Prism.highlight data, Prism.languages.javascript
    res.send converted


  server = http.createServer app
  server.listen PORT, HOST, ->
    console.log "NWWW server running on #{HOST}:#{PORT}."
  
module.exports =
  app: app
  
