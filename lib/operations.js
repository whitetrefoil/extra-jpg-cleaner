(function() {
  'use strict';
  var colors, confirmWithUser, fs, list, path, readline, remove, removeSilently, rename, _;

  _ = require('lodash');

  colors = require('colors');

  fs = require('fs');

  path = require('path');

  readline = require('readline');

  list = function(file) {
    return console.log('Found: '.green + file);
  };

  rename = function(file, renameTo, verbose) {
    var newName;
    newName = path.join(path.dirname(file), path.basename(file, path.extname(file))) + '.' + renameTo;
    return fs.rename(file, newName, function() {
      if (verbose) {
        return console.log('File: ' + file.yellow + '\n  To: ' + newName.cyan);
      }
    });
  };

  remove = function(files, verbose) {
    var expected;
    if (files.length === 0) {
      return console.log('No file to delete, cheers!'.cyan);
    } else {
      files.forEach(function(file) {
        return console.log(file);
      });
      console.log('The above files ('.yellow + files.length.toString().red.bold + ' at all) will be removed PERMANENTLY!'.yellow);
      console.log('Please double check and make sure you will never want to see them again!'.yellow);
      console.log('Input the full path of the first file listed above to continue:'.yellow.bold);
      expected = path.resolve(files[0]);
      return confirmWithUser(expected, function() {
        files.forEach(function(file) {
          if (verbose) {
            console.log('Deleting: '.red + file);
          }
          return fs.unlinkSync(file);
        });
        return console.log('Deleted! Hopefully you will never repent'.green.bold);
      });
    }
  };

  removeSilently = function(files, verbose) {
    if (files.length === 0) {
      return console.log('No file to delete, cheers!'.cyan);
    } else {
      files.forEach(function(file) {
        return console.log(file);
      });
      console.log('The above files ('.yellow + files.length.toString().red.bold + ' at all) will be removed PERMANENTLY!'.yellow);
      console.log('Are you really sure? (Y/N)');
      return confirmWithUser('Y', function() {
        files.forEach(function(file) {
          if (verbose) {
            console.log('Deleting: '.red + file);
          }
          return fs.unlinkSync(file);
        });
        return console.log('Deleted! Hopefully you will never repent'.green.bold);
      });
    }
  };

  confirmWithUser = function(expected, cb) {
    var rl;
    rl = readline.createInterface({
      input: process.stdin,
      output: process.stdout
    });
    rl.setPrompt('I say: ', 7);
    rl.prompt();
    return rl.on('line', function(input) {
      var e, isCorrect;
      try {
        isCorrect = input.trim() === expected;
      } catch (_error) {
        e = _error;
        isCorrect = false;
      }
      if (isCorrect) {
        rl.close();
        return typeof cb === "function" ? cb() : void 0;
      } else {
        console.log('Wrong! Try again? Or press Ctrl-C to abort'.yellow);
        return rl.prompt();
      }
    });
  };

  module.exports = {
    list: list,
    rename: rename,
    remove: remove,
    removeSilently: removeSilently
  };

}).call(this);

//# sourceMappingURL=operations.js.map
