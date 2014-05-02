'use strict'

should = require('chai').should()
sinon = require 'sinon'
sinonChai = require 'sinon-chai'
path = require 'path'

cleaner = require path.join process.cwd(), './src/cleaner'

describe 'Help message:', ->
  before ->
    sinon.stub console, 'log', (msg) => @stdout += msg
    sinon.stub console, 'error', (msg) => @stderr += msg

  after ->
    console.log.restore()
    console.error.restore()

  beforeEach ->
    @stdout = ''
    @stderr = ''

  describe 'when call app with --help', ->
    it 'should print a help message', ->
      cleaner [ '--help' ]
      @stdout.length.should.greaterThan 100
      console.log.should.have.been.called
      @expectedStdout = @stdout
      @expectedStderr = @stderr

  describe 'when call app with -h', ->
    it 'should print the same as --help', ->
      cleaner [ '-h' ]
      @stdout.should.equal(@expectedStdout)
      @stderr.should.equal(@expectedStderr)

  describe 'when call app with --help and other arguments', ->
    it 'should print the same as --help', ->
      cleaner [ '--help', '-D', 'test/sandbox' ]
      @stdout.should.equal(@expectedStdout)
      @stderr.should.equal(@expectedStderr)

  describe 'when call app with -h and other arguments', ->
    it 'should print the same as --help', ->
      cleaner [ '-h', '-D', 'test/sandbox' ]
      @stdout.should.equal(@expectedStdout)
      @stderr.should.equal(@expectedStderr)

  describe 'when call app with an invalid argument', ->
    it 'should print the --help message after some error message', ->
      cleaner [ '--asdf', 'test/sandbox' ]
      @stdout.should.equal(@expectedStdout)
      @stderr.length.should.be.greaterThan @expectedStderr.length

