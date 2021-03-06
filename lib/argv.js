(function() {
  'use strict';
  var yargs;

  require('colors');

  yargs = require('yargs').usage('This application will append extra extname to all filtered out JPG files.\nThen you can check the result by your OS\'s search function easily.\nIn case there is anything wrong, you can rollback.\n\nThe default destination is here.\n\nP.S. The priority among -l, -d & -r is -l > -d > -r\n\n' + 'Usage: clean-jpg [--options] [destination]'.cyan).options('x', {
    alias: 'extname',
    describe: "the extname(s) of your RAW files, case-" + 'IN'.yellow + "sensitive\na comma-seperated list is acceptable\n" + 'e.g. "-x nef,cr2,dng"'.cyan + "\n",
    "default": 'arw,rw2,nef'
  }).options('r', {
    alias: 'rename',
    "default": 'extra-jpg-cleaner-result',
    describe: 'the extname used when renaming\n'
  }).options('d', {
    alias: 'delete',
    boolean: true,
    describe: '!!!CAUTION!!!\n'.yellow.bold + "Delete DIRECTLY w/ a single confirmation\ninstead of confirming one by one.\nIt WON'T move your files to the recycle bin\nor trash can.\nGenerally this operation will be unrecoverable.\nTry this only if you think your luck is overwhelming.\nIncase something goes wrong,\ngo to buy an EasyRecovery or something similar.\nThen test your overwhelming luck again..."
  }).options('D', {
    alias: 'delete-directly',
    boolean: true,
    describe: '!!!CAUTION!!!\n'.red.bold + "Same as \"-d\" but with\nonly even simpler \"Y/N\" confirmation."
  }).options('l', {
    alias: 'list',
    describe: 'just print a list of result, will NOT delete anything',
    boolean: true
  }).options('v', {
    alias: 'verbose',
    describe: 'print when renaming / deleting',
    boolean: true
  }).options('h', {
    alias: 'help',
    describe: 'print this help message',
    boolean: true
  }).wrap(80);

  module.exports = yargs;

}).call(this);

//# sourceMappingURL=argv.js.map
