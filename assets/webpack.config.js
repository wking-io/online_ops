'use strict';

const autoprefixer = require('autoprefixer');
const webpack = require('webpack');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');
const purgecss = require('@fullhuman/postcss-purgecss');
const paths = require('./paths');

// Options for PostCSS as we reference these options twice
// Adds vendor prefixing based on your specified browser support in
// package.json
const postcssOptions = (isProduction) => {
  const defaultOptions = [
    require('postcss-easy-import'),
    require('tailwindcss')(paths.tailwind),
    require('postcss-flexbugs-fixes'),
    autoprefixer({
      flexbox: 'no-2009'
    }),
    require('postcss-hexrgba')
  ];

  const productionOptions = [
    require('cssnano'),
    purgecss({
      content: paths.content,
      defaultExtractor: (content) => {
        return content.match(/[\w-/:]+(?<!:)/g) || [];
      }
    })
  ];

  return {
    // Necessary for external CSS imports to work
    ident: 'postcss',
    plugins: [ ...defaultOptions, ...(isProduction ? productionOptions : []) ]
  };
};

const extractCSS = new MiniCssExtractPlugin({
  filename: 'css/[name].css'
});

module.exports = (_, { mode }) => {
  const isProduction = mode === 'production';
  return {
    stats: 'minimal',
    bail: isProduction,
    optimization: {
      minimizer: [ new OptimizeCSSAssetsPlugin({}) ]
    },
    entry: paths.entry,
    output: {
      path: paths.build,
      filename: 'js/[name].js'
    },
    devtool: isProduction ? false : 'inline-source-map',
    module: {
      strictExportPresence: true,
      rules: [
        // Disable require.ensure as it's not a standard language feature.
        {
          parser: {
            requireEnsure: false
          }
        },
        {
          test: /\.(js|jsx|mjs)$/,
          enforce: 'pre',
          use: [
            {
              options: {
                eslintPath: require.resolve('eslint'),
                configFile: paths.eslint,
                ignore: false,
                useEslintrc: false
              },
              loader: require.resolve('eslint-loader')
            }
          ],
          include: paths.src,
          exclude: [ /[/\\\\]node_modules[/\\\\]/ ]
        },
        {
          // "oneOf" will traverse all following loaders until one will
          // match the requirements. When no loader matches it will fall
          // back to the "file" loader at the end of the loader list.
          oneOf: [
            {
              test: /\.js$/,
              include: paths.js,
              exclude: /node_modules/,
              use: [
                {
                  loader: require.resolve('babel-loader'),
                  options: {
                    presets: [
                      [
                        '@babel/env',
                        {
                          modules: false,
                          targets: {
                            browsers: [ 'last 2 versions', 'safari >= 7' ]
                          }
                        }
                      ]
                    ]
                  }
                }
              ]
            },
            {
              test: /\.css$/,
              include: paths.styles,
              use: [
                MiniCssExtractPlugin.loader,
                {
                  loader: require.resolve('css-loader'),
                  options: {
                    importLoaders: 2,
                    url: false
                  }
                },
                {
                  loader: require.resolve('postcss-loader'),
                  options: postcssOptions(isProduction)
                }
              ]
            },
            {
              test: /\.(gif|png|jpe?g|svg)$/i,
              use: [
                {
                  loader: require.resolve('file-loader'),
                  options: { name: 'images/[name].[ext]' }
                },
                {
                  loader: require.resolve('image-webpack-loader'),
                  options: {
                    disable: isProduction === false
                  }
                }
              ]
            },
            {
              test: /\.(eot|svg|ttf|woff|woff2|otf)$/,
              use: [
                {
                  loader: require.resolve('file-loader'),
                  options: { name: 'fonts/[name].[ext]' }
                }
              ]
            }
          ]
        }
      ]
    },
    plugins: [
      new webpack.NamedModulesPlugin(),
      extractCSS,
      new CopyWebpackPlugin([ { from: 'static/', to: './' } ]),
      // Moment.js is an extremely popular library that bundles large locale files
      // by default due to how Webpack interprets its code. This is a practical
      // solution that requires the user to opt into importing specific locales.
      // https://github.com/jmblog/how-to-optimize-momentjs-with-webpack
      // You can remove this if you don't use Moment.js:
      new webpack.IgnorePlugin(/^\.\/locale$/, /moment$/)
    ]
  };
};
