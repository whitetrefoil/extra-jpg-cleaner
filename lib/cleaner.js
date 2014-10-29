(function() {
  'use strict';
  var Glob, checkIfValid, colors, confirmWithUser, finder, fs, getConfigs, list, main, path, printHelp, readline, removeDirectly, removeWithConfirmation, rename, yargs, _;

  yargs = require('./argv');

  _ = require('lodash');

  colors = require('colors');

  fs = require('fs');

  path = require('path');

  readline = require('readline');

  Glob = require('glob').Glob;

  finder = require('./finder');

  main = function(argv) {
    var configs, isConfigsValid, messages, _ref;
    configs = getConfigs(argv);
    _ref = checkIfValid(configs), isConfigsValid = _ref[0], messages = _ref[1];
    if (isConfigsValid) {
      messages.forEach(function(msg) {
        return console.war(msg);
      });
      if (configs.help) {
        return printHelp();
      } else if (configs.list) {
        return finder.find(configs.destination, configs.extnames, list);
      } else if (configs.remove) {
        return finder.findSync(configs.destination, configs.extnames, removeWithConfirmation, configs.verbose);
      } else if (configs.removeDirectly) {
        return finder.findSync(configs.destination, configs.extnames, removeDirectly, configs.verbose);
      } else {
        return finder.find(configs.destination, configs.extnames, rename, configs.renameTo, configs.verbose);
      }
    } else {
      messages.forEach(function(msg) {
        return console.error('Error: '.red.bold + msg);
      });
      console.log('');
      return printHelp();
    }
  };

  list = function(file) {
    return console.log('Found: '.green + file);
  };

  rename = function(file, renameTo, verbose) {
    var newName;
    newName = path.join(path.dirname(file), path.basename(file, path.extname(file))) + '.' + renameTo;
    fs.rename(file, newName);
    if (verbose) {
      return console.log('File: ' + file.yellow + '\n  To: ' + newName.cyan);
    }
  };

  removeWithConfirmation = function(files, verbose) {
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

  removeDirectly = function(files, verbose) {
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

  printHelp = function() {
    return yargs.showHelp(console.log);
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

  getConfigs = function(argv) {
    var args, configs;
    args = argv != null ? yargs.parse(argv) : yargs.argv;
    configs = {};
    configs.extnames = args.x.split(',').map(function(ext) {
      return ext.trim().replace(/^\./, '');
    });
    delete args.x;
    delete args.extname;
    configs.renameTo = args.r.trim().replace(/^\./, '');
    delete args.r;
    delete args.rename;
    configs.remove = args.d;
    delete args.d;
    delete args["delete"];
    configs.removeDirectly = args.D;
    delete args.D;
    delete args.deleteDirectly;
    delete args['delete-directly'];
    configs.list = args.l;
    delete args.l;
    delete args.list;
    configs.verbose = args.v;
    delete args.v;
    delete args.verbose;
    configs.help = args.h;
    delete args.h;
    delete args.help;
    configs.destinations = (args._ != null) && args._.length > 0 ? args._ : [''];
    delete args._;
    configs.destination = configs.destinations[0].toString();
    configs.$0 = args.$0;
    delete args.$0;
    configs.unknown = args;
    return configs;
  };

  checkIfValid = function(configs) {
    var e, messages, passed;
    messages = [];
    passed = true;
    _.forEach(configs.unknown, function(value, key) {
      messages.push("Unknown argument " + key + ": " + value + " is not allowed");
      return passed = false;
    });
    if (configs.destinations.length > 1) {
      messages.push('At most 1 destination is allowed');
      passed = false;
    }
    try {
      if (!fs.statSync(path.resolve(configs.destination)).isDirectory()) {
        messages.push('Destination is not a directory');
        passed = false;
      }
    } catch (_error) {
      e = _error;
      if (e.code === 'ENOENT') {
        messages.push('Destination is not existing');
        passed = false;
      } else {
        throw e;
      }
    }
    return [passed, messages];
  };

  if (require.main === module) {
    main();
  } else {
    module.exports = main;
  }

}).call(this);

//# sourceMappingURL=cleaner.js.map
