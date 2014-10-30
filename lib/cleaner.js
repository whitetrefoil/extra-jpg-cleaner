(function() {
  'use strict';
  var checkIfValid, colors, finder, fs, getConfigs, main, ops, path, printHelp, readline, yargs, _;

  yargs = require('./argv');

  _ = require('lodash');

  colors = require('colors');

  fs = require('fs');

  path = require('path');

  readline = require('readline');

  finder = require('./finder');

  ops = require('./operations');

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
        return finder.find(configs.destination, configs.extnames, ops.list);
      } else if (configs.remove) {
        return finder.findSync(configs.destination, configs.extnames, ops.remove, configs.verbose);
      } else if (configs.removeDirectly) {
        return finder.findSync(configs.destination, configs.extnames, ops.removeSilently, configs.verbose);
      } else {
        return finder.find(configs.destination, configs.extnames, ops.rename, configs.renameTo, configs.verbose);
      }
    } else {
      messages.forEach(function(msg) {
        return console.error('Error: '.red.bold + msg);
      });
      console.log('');
      return printHelp();
    }
  };

  printHelp = function() {
    return yargs.showHelp(console.log);
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
