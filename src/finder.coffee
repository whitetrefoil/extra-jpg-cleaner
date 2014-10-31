# This file provide the file searching function.

# `"use strict";` always first :)

'use strict'

# Dependencies
# ------------

# Require all the dependencies.

path = require 'path'
fs = require 'fs'
Glob = require('glob').Glob


# Core Functions
# --------------

# Get `BaseDir` from the destination passed in.

getBaseDir = (dest) ->
  dest = '' unless typeof dest is 'string'
  normalized = path.normalize(dest)
  cwd = process.cwd()
  if dest.search(/[/\\]/) is 0
    cwd = cwd.substr 0, cwd.search(/[/\\]/) + 1
  fullPath = path.resolve cwd, normalized
  unixSplash = fullPath.replace /\\/g, '/'
  unixSplash += '/' unless unixSplash[unixSplash.length - 1] is '/'
  unixSplash


# Separated the normal full path into root + Unix style abs path.
# This can bypass the drive letter issue of `node-glob`.

separateRoot = (fullPath) ->
  parsed = fullPath.match(/(.*?\/)(.*)/)
  [ parsed[1], parsed[2] ]


# Now here are the core functions - finding, renaming, deleting, etc.

find = (dest, extnames, cb, args...) ->
  [root, pattern] = separateRoot(getBaseDir(dest))
  pattern = '/' + pattern + '**/*.+(jpg|jpeg|jpe)'
  matching = new Glob pattern,
    nocase: true
    root: root

  found = 0

  matching.on 'match', (file) ->
    file = path.normalize file
    bareFileName = path.join(path.dirname(file), path.basename(file, path.extname(file)))
    if (extnames.some (extname) -> fs.existsSync(bareFileName + '.' + extname))
      found += 1
      cb?.apply null, [ file ].concat(args)

  matching.on 'end', ->
    console.log "#{found} files processed".green


# An async find will be good for performance,
# but when doing deleting we want a sync find then allow a confirmation before finally deleting.

findSync = (dest, extnames, cb, args...) ->
  [root, pattern] = separateRoot(getBaseDir(dest))
  pattern = '/' + pattern + '**/*.+(jpg|jpeg|jpe)'
  matching = new Glob pattern,
    nocase: true
    root: root

  matching.on 'end', (files) ->
    targetFiles = files.filter (file) ->
      file = path.normalize file
      bareFileName = path.join(path.dirname(file), path.basename(file, path.extname(file)))
      extnames.some (extname) -> fs.existsSync(bareFileName + '.' + extname)
    cb?.apply null, [ targetFiles ].concat(args)


# Exporting
# ---------

module.exports =
  find: find
  findSync: findSync
