'use strict'

path = require 'path'
should = require('chai').should()
rewire = require 'rewire'
finder = rewire '../../src/finder'

describe 'Finder:', ->
  describe 'getBaseDir:', ->
    mockCwd = ''
    before ->
      mockCwd = process.cwd().match(/.*?(?=[/\\])/)[0] + '/test/path'
    beforeEach ->
      @getBaseDir = finder.__get__ 'getBaseDir'

    it 'should be able to handle inner directories', ->
      revert = finder.__set__ 'process',
        cwd: -> mockCwd
      @getBaseDir('inner').should.match /^([A-Za-z]:\/|\/)test\/path\/inner\/$/
      revert()

    it 'should be able to handle current directories', ->
      revert = finder.__set__ 'process',
        cwd: -> mockCwd
      @getBaseDir('.').should.match /^([A-Za-z]:\/|\/)test\/path\/$/
      @getBaseDir('').should.match /^([A-Za-z]:\/|\/)test\/path\/$/
      @getBaseDir(null).should.match /^([A-Za-z]:\/|\/)test\/path\/$/
      @getBaseDir().should.match /^([A-Za-z]:\/|\/)test\/path\/$/
      revert()

    it 'should be able to handle upper directories', ->
      revert = finder.__set__ 'process',
        cwd: -> mockCwd
      @getBaseDir('..').should.match /^([A-Za-z]:\/|\/)test\/$/
      @getBaseDir('../asdf').should.match /^([A-Za-z]:\/|\/)test\/asdf\/$/
      revert()

    it 'should be able to handle the root directory', ->
      revert = finder.__set__ 'process',
        cwd: -> mockCwd
      @getBaseDir('/').should.match /^([A-Za-z]:\/|\/)$/
      revert()
