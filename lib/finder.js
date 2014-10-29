(function() {
  'use strict';
  var Glob, find, findSync, fs, getBaseDir, path,
    __slice = [].slice;

  path = require('path');

  fs = require('fs');

  Glob = require('glob').Glob;

  getBaseDir = function(dest) {
    var cwd, fullPath, normalized, removeWindowsDriverLetter, unixSplash;
    if (typeof dest !== 'string') {
      dest = '';
    }
    normalized = path.normalize(dest);
    cwd = process.cwd();
    fullPath = path.resolve(cwd, normalized);
    removeWindowsDriverLetter = fullPath.replace(/^[A-Za-z]:/, '');
    unixSplash = removeWindowsDriverLetter.replace(/\\/g, '/');
    if (unixSplash[unixSplash.length - 1] !== '/') {
      unixSplash += '/';
    }
    return unixSplash;
  };

  find = function() {
    var args, cb, dest, extnames, found, matching, pattern;
    dest = arguments[0], extnames = arguments[1], cb = arguments[2], args = 4 <= arguments.length ? __slice.call(arguments, 3) : [];
    pattern = getBaseDir(dest) + '**/*.+(jpg|jpeg|jpe)';
    matching = new Glob(pattern, {
      nocase: true
    });
    found = 0;
    matching.on('match', function(file) {
      var bareFileName;
      file = path.normalize(file);
      bareFileName = path.join(path.dirname(file), path.basename(file, path.extname(file)));
      if (extnames.some(function(extname) {
        return fs.existsSync(bareFileName + '.' + extname);
      })) {
        found += 1;
        return cb != null ? cb.apply(null, [file].concat(args)) : void 0;
      }
    });
    return matching.on('end', function() {
      return console.log(("" + found + " files processed").green);
    });
  };

  findSync = function() {
    var args, cb, dest, extnames, matching, pattern;
    dest = arguments[0], extnames = arguments[1], cb = arguments[2], args = 4 <= arguments.length ? __slice.call(arguments, 3) : [];
    pattern = getBaseDir(dest) + '**/*.+(jpg|jpeg|jpe)';
    matching = new Glob(pattern, {
      nocase: true
    });
    return matching.on('end', function(files) {
      var targetFiles;
      targetFiles = files.filter(function(file) {
        var bareFileName;
        file = path.normalize(file);
        bareFileName = path.join(path.dirname(file), path.basename(file, path.extname(file)));
        return extnames.some(function(extname) {
          return fs.existsSync(bareFileName + '.' + extname);
        });
      });
      return cb != null ? cb.apply(null, [targetFiles].concat(args)) : void 0;
    });
  };

  module.exports = {
    find: find,
    findSync: findSync
  };

}).call(this);

//# sourceMappingURL=finder.js.map
