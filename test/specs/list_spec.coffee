'use strict'

should = require('chai').should()
sinon = require 'sinon'
sinonChai = require 'sinon-chai'
path = require 'path'
fs = require 'fs'
wrench = require 'wrench'

cleaner = require path.join process.cwd(), './src/cleaner'

describe 'List:', ->
  before ->
    sinon.stub console, 'log', (msg) => @stdout += msg
    sinon.stub console, 'error', (msg) => @stderr += msg

  after ->
    console.log.restore()
    console.error.restore()

  beforeEach ->
    @stdout = ''
    @stderr = ''
    try
      wrench.rmdirSyncRecursive 'test/sandbox'
      wrench.copyDirSyncRecursive 'test/sandbox_src', 'test/sandbox'
    catch e

  describe 'when with -l', ->
    it 'should list 8 lines to stdout', ->
      cleaner [ '-l', 'test/sandbox' ]
      @stdout.match(/\n/g).length.should.equal '9'
