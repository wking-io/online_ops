'use strict';

const path = require('path');
const fs = require('fs');

const resolveAsset = (relativePath) => path.resolve(__dirname, relativePath);
const resolveRoot = (relativePath) => path.resolve(__dirname, '../', relativePath);

const resolveEntry = (ext) => (p) =>
  fs.readdirSync(p).filter((file) => path.extname(file) === ext).reduce((acc, file) => {
    const entry = { [path.basename(file, ext)]: `${p}/${file}` };
    return Object.assign(acc, entry);
  }, {});

const resolveEntryJs = resolveEntry('.js');

module.exports = {
  build: resolveRoot('priv/static'),
  entry: resolveEntryJs(resolveAsset('js')),
  js: resolveAsset('js'),
  src: resolveAsset('.'),
  styles: resolveAsset('css'),
  images: resolveAsset('images'),
  eslint: resolveAsset('.eslintrc'),
  tailwind: resolveAsset('tailwind.config.js')
};
