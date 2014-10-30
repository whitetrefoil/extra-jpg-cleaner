# This file provide the file operating functions.

# `"use strict";` always first :)

'use strict'


# Dependencies
# ------------

_ = require 'lodash'
colors = require 'colors'
fs = require 'fs'
path = require 'path'
readline = require 'readline'


# Core Functions
# -----

# List a single file.
# Used for `-l`.
# Since this function will be called by a async find,
# it only need to handle a single file.

list = (file) ->
  console.log 'Found: '.green + file


# Just like `#list()`, it only need to rename a single file.

rename = (file, renameTo, verbose) ->
  newName = path.join(path.dirname(file), path.basename(file, path.extname(file))) + '.' + renameTo
  fs.rename file, newName
  if verbose
    console.log 'File: ' + file.yellow + '\n  To: ' + newName.cyan


# But this one is different.
# Since deleting is too dangerous, we want double confirm with the user.
# So it will be a sync flow.

remove = (files, verbose) ->
  if files.length is 0
    console.log 'No file to delete, cheers!'.cyan
  else
    files.forEach (file) ->
      console.log file
    console.log 'The above files ('.yellow + files.length.toString().red.bold + ' at all) will be removed PERMANENTLY!'.yellow
    console.log 'Please double check and make sure you will never want to see them again!'.yellow
    console.log 'Input the full path of the first file listed above to continue:'.yellow.bold
    expected = path.resolve files[0]

    confirmWithUser expected, ->
      files.forEach (file) ->
        console.log 'Deleting: '.red + file if verbose
        fs.unlinkSync file
      console.log 'Deleted! Hopefully you will never repent'.green.bold


# Or maybe the user don't want to do such a complex confirmation...

removeSilently = (files, verbose) ->
  if files.length is 0
    console.log 'No file to delete, cheers!'.cyan
  else
    files.forEach (file) ->
      console.log file
    console.log 'The above files ('.yellow + files.length.toString().red.bold + ' at all) will be removed PERMANENTLY!'.yellow
    console.log 'Are you really sure? (Y/N)'
    confirmWithUser 'Y', ->
      files.forEach (file) ->
        console.log 'Deleting: '.red + file if verbose
        fs.unlinkSync file
      console.log 'Deleted! Hopefully you will never repent'.green.bold


# Ask user for a confirmation.
# Used before deleting files.

confirmWithUser = (expected, cb) ->
  rl = readline.createInterface
    input: process.stdin
    output: process.stdout

  rl.setPrompt 'I say: ', 7
  rl.prompt()

  rl.on 'line', (input) ->
    try
      isCorrect = input.trim() is expected
    catch e
      isCorrect = false

    if isCorrect
      rl.close()
      cb?()
    else
      console.log 'Wrong! Try again? Or press Ctrl-C to abort'.yellow
      rl.prompt()



# Export
# -----

module.exports =
  list: list
  rename: rename
  remove: remove
  removeSilently: removeSilently
