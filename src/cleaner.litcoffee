This file is the main file of the cleaner.

`"use strict";` always first :)

    'use strict'


Dependencies
-----

Require all the dependencies.

Firstly get the arguments from [argv.litcoffee](argv.html)

    yargs = require './argv'

Then there are some external dependencies...

    _ = require 'lodash'
    colors = require 'colors'
    fs = require 'fs'
    path = require 'path'
    readline = require 'readline'

File searching function.

    finder = require './finder'

File operation functions.

    ops = require './operations'


Entry Point
-----

The `main()` function of the whole application.

Firstly it will get all the configurations from `yargs`.

If given a `--help` or `-h`, we will print a help message no matter what else is given.  Besides, if no valid argument is given, we will also print he help message.

I'd like to leave the `argv` open.
It will give convenience if who want to require this module in his / her code instead of call it in CLI.
It will also give myself convenience when writing the UT.

The priority of each arguments is:
--help > --list > --delete > --rename

And if nothing is given or any invalid arguments exists,
it will also print the help message.

    main = (argv) ->
      configs = getConfigs(argv)
      [ isConfigsValid, messages ] = checkIfValid(configs)

      if isConfigsValid
        messages.forEach (msg) -> console.war msg
        if configs.help
            printHelp()
        else if configs.list
          finder.find configs.destination, configs.extnames, ops.list
        else if configs.remove
          finder.findSync configs.destination, configs.extnames, ops.remove, configs.verbose
        else if configs.removeDirectly
          finder.findSync configs.destination, configs.extnames, ops.removeSilently, configs.verbose
        else
          finder.find configs.destination, configs.extnames, ops.rename, configs.renameTo, configs.verbose
      else
        messages.forEach (msg) ->
          console.error 'Error: '.red.bold + msg
        console.log ''
        printHelp()


Helpers
-----

A function to print the help message to the users.

By default `Yargs` will print the help message to `stderr`. I don't like it, so I redirected it to `stdout`.

    printHelp = ->
      yargs.showHelp(console.log)


Initialize & Configuration
-----

Get the configurations from `yargs`.

    getConfigs = (argv) ->
      args = if argv?
        yargs.parse argv
      else
        yargs.argv
      configs = {}

      configs.extnames = args.x.split(',').map (ext) -> ext.trim().replace(/^\./, '')
      delete args.x
      delete args.extname

      configs.renameTo = args.r.trim().replace(/^\./, '')
      delete args.r
      delete args.rename

      configs.remove = args.d
      delete args.d
      delete args.delete

      configs.removeDirectly = args.D
      delete args.D
      delete args.deleteDirectly
      delete args['delete-directly']

      configs.list = args.l
      delete args.l
      delete args.list

      configs.verbose = args.v
      delete args.v
      delete args.verbose

      configs.help = args.h
      delete args.h
      delete args.help

      configs.destinations = if args._? and args._.length > 0 then args._ else [ '' ]
      delete args._

      configs.destination = configs.destinations[0].toString()

      configs.$0 = args.$0
      delete args.$0

      configs.unknown = args

      configs

Check to see if the arguments given are valid.

    checkIfValid = (configs) ->
      messages = []
      passed = true

      _.forEach configs.unknown, (value, key) ->
        messages.push "Unknown argument #{key}: #{value} is not allowed"
        passed = false

      if configs.destinations.length > 1
        messages.push 'At most 1 destination is allowed'
        passed = false

      try
        unless fs.statSync(path.resolve(configs.destination)).isDirectory()
          messages.push 'Destination is not a directory'
          passed = false
      catch e
        if e.code is 'ENOENT'
          messages.push 'Destination is not existing'
          passed = false
        else
          throw e

      [ passed, messages ]

Public API
-----

Now we can publish the main entry point.
Or run it directly.

    if require.main is module
      main()
    else
      module.exports = main
