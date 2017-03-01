# webpack config module.loaders
module.exports =
  [
    {
      test: /\.coffee$/
      loader: 'coffee-loader'
    }
    {
      test: /\.css$/
      loader: 'style-loader!css-loader'
    }
    {
      test: /\.(gif|png|eot|ttf)?$/
      loader: 'url-loader'
    }
    {
      test: /\.(woff|woff2|eot|ttf|svg)(\?[\&0-9]+)?$/
      loader: 'url-loader'
    }
    {
      test: /\.(woff|woff2|eot|ttf|svg)(\?v=[0-9]\.[0-9]\.[0-9])?$/
      loader: 'url-loader'
    }
    {
      test: /jquery\/src\/selector\.js$/
      loader: 'amd-define-factory-patcher-loader'
    }
    {
      test: /jquery-ui\/ui\/selector\.js$/
      loader: 'amd-define-factory-patcher-loader'
    }
  ]
