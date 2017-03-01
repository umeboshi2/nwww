path = require 'path'
os = require 'os'


webpack = require 'webpack'

ManifestPlugin = require 'webpack-manifest-plugin'
StatsPlugin = require 'stats-webpack-plugin'

loaders = require './webpack-config/loaders'
resolve = require './webpack-config/resolve'

local_build_dir = "build"

BuildEnvironment = 'dev'
if process.env.PRODUCTION_BUILD
  BuildEnvironment = 'production'
  Clean = require 'clean-webpack-plugin'
  ChunkManifestPlugin = require 'chunk-manifest-webpack-plugin'
  console.log "==============PRODUCTION BUILD=============="
  
WebPackOutputFilename =
  dev: '[name].js'
  production: '[name]-[chunkhash].js'
  
WebPackOutput =
  filename: WebPackOutputFilename[BuildEnvironment]
  path: path.join __dirname, local_build_dir
  publicPath: 'build/'

DefinePluginOpts =
  dev:
    __DEV__: 'true'
    DEBUG: JSON.stringify(JSON.parse(process.env.DEBUG || 'false'))
  production:
    __DEV__: 'false'
    DEBUG: 'false'
    'process.env':
      'NODE_ENV': JSON.stringify 'production'
    
StatsPluginFilename =
  dev: 'stats-dev.json'
  production: 'stats.json'

common_plugins = [
  new webpack.DefinePlugin DefinePluginOpts[BuildEnvironment]
  new webpack.optimize.AggressiveMergingPlugin()
  new StatsPlugin StatsPluginFilename[BuildEnvironment], chunkModules: true
  new ManifestPlugin()
  ]
  
if BuildEnvironment is 'dev'
  dev_only_plugins = []
  AllPlugins = common_plugins.concat dev_only_plugins
else if BuildEnvironment is 'production'
  prod_only_plugins = [
    # production only plugins below
    new webpack.HashedModuleIdsPlugin()
    new webpack.optimize.DedupePlugin()
    new webpack.optimize.UglifyJsPlugin
      compress:
        warnings: true
    new Clean local_build_dir
    ]
  AllPlugins = common_plugins.concat prod_only_plugins
else
  console.error "Bad BuildEnvironment", BuildEnvironment
  


WebPackConfig =
  entry:
    index: './client/entries/index.coffee'
  output: WebPackOutput
  plugins: AllPlugins
  module:
    loaders: loaders
  resolve: resolve

if BuildEnvironment is 'dev'
  WebPackConfig.devServer =
    host: 'localhost'
    proxy:
      '/api/*': 'http://localhost:8081'
    historyApiFallback:
      index: 'index-dev.html'
  WebPackConfig.devtool = 'source-map'

module.exports = WebPackConfig
