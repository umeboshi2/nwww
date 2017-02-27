os = require 'os'
path = require 'path'
http = require 'http'
fs = require 'fs'

express = require 'express'
serveIndex = require 'serve-index'
marked = require 'marked'
Prism = require 'prismjs'

# Set the default environment to be `development`
process.env.NODE_ENV = process.env.NODE_ENV or 'development'

UseMiddleware = false or process.env.__DEV_MIDDLEWARE__ is 'true'
PORT = process.env.NODE_PORT or 8081
HOST = process.env.NODE_IP or 'localhost'

# create express app 
app = express()


app.use '/', serveIndex './'
app.get '/*', (req, res, next) ->
  #console.log "req.params", req.params
  filename = req.params[0]
  #console.log "FILENAME", filename
  data = fs.readFileSync(filename).toString()
  converted = data
  if filename.endsWith '.md'
    converted =  marked data
  else if filename.endsWith '.js'
    # FIXME include css in response
    converted = Prism.highlight data, Prism.languages.javascript
    console.log converted
  res.send converted


server = http.createServer app
server.listen PORT, HOST, ->
  console.log "NWWW server running on #{HOST}:#{PORT}."
  
module.exports =
  app: app
  
