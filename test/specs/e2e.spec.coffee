'use strict'

path = require 'path'
fs = require 'fs-extra'
should = require('chai').should()
rewire = require 'rewire'
operations = rewire '../../src/operations'
main = rewire '../../src/cleaner'

describe 'E2E:', ->
  stdout = ''
  before ->
    @consoleRecover = operations.__set__ 'console',
      log: (args...) -> args.forEach (arg) -> stdout += arg
    fs.removeSync 'test/sandbox'
  beforeEach ->
    stdout = ''
    fs.copySync 'test/sandbox_src', 'test/sandbox'
  afterEach ->
    fs.removeSync 'test/sandbox'
  after ->
    @consoleRecover()

  describe 'Help:', ->
    it 'should show help when -h is given', ->
      main(['-h'])
  describe 'List:', ->
