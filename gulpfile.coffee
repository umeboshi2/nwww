# inspired by https://github.com/KyleAMathews/coffee-react-quickstart
# 
fs = require 'fs'

gulp = require 'gulp'
gutil = require 'gulp-util'
size = require 'gulp-size'
nodemon = require 'gulp-nodemon'
sourcemaps = require 'gulp-sourcemaps'

coffee = require 'gulp-coffee'

webpack = require 'webpack'
tc = require 'teacup'

gulp.task 'indexdev', (callback) ->
  { make_page_html } = require './src/pages'
  page = make_page_html 'index'
  fs.writeFileSync 'index-dev.html', page
  console.log "Created new index.html"

gulp.task 'serve', (callback) ->
  nodemon
    script: 'index.js'
    ext: 'js coffee'
    watch: [
      'src'
      'webpack-config'
      'webpack.config.coffee'
      ]
  
gulp.task 'serve:prod', (callback) ->
  nodemon
    script: 'index.js'
    ext: 'js coffee'
    watch: [
      'src/'
      'webpack-config/'
      'webpack.config.coffee'
      ]/
  
gulp.task 'webpack:build-prod', (callback) ->
  statopts = 
    colors: true
    chunks: true
    modules: false
    reasons: true
    maxModules: 300
  # run webpack
  process.env.PRODUCTION_BUILD = 'true'
  ProdConfig = require './webpack.config'
  prodCompiler = webpack ProdConfig
  prodCompiler.run (err, stats) ->
    throw new gutil.PluginError('webpack:build-prod', err) if err
    gutil.log "[webpack:build-prod]", stats.toString statopts
    callback()
    return
  return

gulp.task 'default', ->
  gulp.start 'serve'
  
gulp.task 'production', ->
  gulp.start 'webpack:build-prod'
