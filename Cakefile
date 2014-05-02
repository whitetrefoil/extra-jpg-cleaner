#### Predefine
SOURCE_DIR = './src'
BUILD_DIR = './lib'
DOC_DIR = './doc'


#### npm libs
_ = require 'lodash'
fs = require 'fs'
util = require 'util'
path = require 'path'
coffee = require('coffee-script')._compileFile
docco = require 'docco'
wrench = require 'wrench'
glob = require 'glob'
exec = require('child_process').exec
require 'colors'

#### Helpers

# Wipe a whole dir
cleanDir = (path) ->
  try
    # the exception of wrench's rmdir is missing `errno` & `code`
    # try original rmdir first.
    fs.rmdirSync path
  catch e
    switch e.code
      when 'ENOTEMPTY'
        wrench.rmdirSyncRecursive path
      when 'ENOENT'
        # Do nothing if there's no such dir
      else
        throw e


# Try to write file.  If failed, `mkdir -p` then try again.
writeFile = (filePath, content, tryDir = true) ->
  try
    fs.writeFileSync filePath, content,
      encoding: 'utf8'
  catch e
    if tryDir and e.code is 'ENOENT'
      wrench.mkdirSyncRecursive path.dirname filePath
      writeFile filePath, content, false


# wipe the build dir before build
cleanBuildDir = -> cleanDir BUILD_DIR

# build all files
buildAll = (needMap = false) ->
  cleanBuildDir()
  exec "node node_modules/coffee-script/bin/coffee #{if needMap then '-m' else ''} -co #{BUILD_DIR} #{SOURCE_DIR}",
    stdio: 'inherit'

# wipe the document dir before generating documents
cleanDocDir = -> cleanDir DOC_DIR


# scan for all source files in js & coffee & litcoffee, then generate documents for them
generateDocuments = ->
  cleanDocDir()
  files = glob.sync '**/*.+(coffee|litcoffee|js)',
    cwd: SOURCE_DIR
    nocase: true
  .map (match) -> path.join SOURCE_DIR, match
  docco.document
    args: files
    output: DOC_DIR
    layout: 'linear'

#### Tasks

task 'build', 'build the source code (coffee) to js', ->
  buildAll().on 'close', (code) ->
    if code is 0
      console.log 'Done!'.green
    else
      console.error 'Failed!'.red

task 'build:map', 'build the source code (coffee) to js', ->
  buildAll(true).on 'close', (code) ->
    if code is 0
      console.log 'Done!'.green
    else
      console.error 'Failed!'.red

task 'doc', 'generate documents', ->
  generateDocuments()

task 'test', 'run the test', ->
  spawn = require('child_process').spawn
  mocha = spawn 'node', [
    './node_modules/mocha/bin/mocha'
    '-R'
    'nyan'
    '-c'
    '-s'
    '100'
    '-u'
    'bdd'
    '--recursive'
    '--compilers'
    'coffee:coffee-script/register'
    'test/specs/*_spec.coffee'
  ],
    stdio: 'inherit'
