path = require 'path'
webpack = require 'webpack'

module.exports =
  entry: './src/application.coffee'
  output:
    filename: 'build/bundle.js'
  module:
    loaders: [
      {
        test: /\.coffee$/
        loader: 'coffee'
      }
      {
        test: /\.css$/
        loader: 'style!css'
      }
      {
        test: /\.(woff|woff2|eot|ttf)(\?[\&0-9]+)?$/
        loader: 'url-loader'
      }
      {
        test: /\.(woff|woff2|eot|ttf)(\?v=[0-9]\.[0-9]\.[0-9])?$/
        loader: 'url-loader'
      }
      {
        test: /jquery\/src\/selector\.js$/
        #loader: "expose?$!expose?jQuery"
        loader: 'amd-define-factory-patcher-loader'
      }
      #{
      #  test: require.resolve 'jquery'
      #  loader: "expose?$!expose?jQuery"
      #}
      ]
  resolve:
    fallback: [
      path.join __dirname, 'src'
      ]
    alias:
      jquery: 'jquery/src/jquery'
    modulesDirectories: [
      'node_modules'
      'bower_components'
      ]
    extensions: [
      # MUST include empty string
      # https://webpack.github.io/docs/configuration.html#resolve-extensions
      ''
      '.webpack.js'
      '.web.js'
      '.js'
      # add coffescript files to the list
      '.coffee'
    ]
    plugins: [
      #new webpack.ProvidePlugin
      #  '$': 'jquery'
      #  'jQuery': 'jquery'
      #  'window.jQuery': 'jquery'
        
      new webpack.ResolverPlugin(
        new webpack.ResolverPlugin.DirectoryDescriptionFilePlugin("bower.json", ["main"])
    )
    ]

