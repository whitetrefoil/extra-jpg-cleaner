'use strict'

path = require 'path'
should = require('chai').should()
rewire = require 'rewire'
finder = rewire '../../src/finder'

describe 'Finder:', ->
  describe 'getBaseDir:', ->
    beforeEach ->
      @getBaseDir = finder.__get__ 'getBaseDir'

    describe 'when on Windows:', ->
      it 'should be able to handle inner directories', ->
        revert = finder.__set__ 'process',
          cwd: -> 'X:\\test\\path'
        @getBaseDir('inner').should.equal 'X:/test/path/inner/'
        revert()

      it 'should be able to handle current directories', ->
        revert = finder.__set__ 'process',
          cwd: -> 'X:\\test\\path'
        @getBaseDir('.').should.equal 'X:/test/path/'
        @getBaseDir('').should.equal 'X:/test/path/'
        @getBaseDir(null).should.equal 'X:/test/path/'
        @getBaseDir().should.equal 'X:/test/path/'
        revert()

      it 'should be able to handle upper directories', ->
        revert = finder.__set__ 'process',
          cwd: -> 'X:\\test\\path'
        @getBaseDir('..').should.equal 'X:/test/'
        @getBaseDir('../asdf').should.equal 'X:/test/asdf/'
        revert()

      it 'should be able to handle the root directory', ->
        revert = finder.__set__ 'process',
          cwd: -> 'X:\\test\\path'
        @getBaseDir('/').should.equal 'X:/'
        revert()

    describe 'when on Linux / Unix', ->
      it 'should be able to handle inner directories', ->
        revert = finder.__set__ 'process',
          cwd: -> '/test/path'
        @getBaseDir('inner').should.equal '/test/path/inner/'
        revert()

      it 'should be able to handle current directories', ->
        revert = finder.__set__ 'process',
          cwd: -> '/test/path'
        @getBaseDir('.').should.equal '/test/path/'
        @getBaseDir('').should.equal '/test/path/'
        @getBaseDir(null).should.equal '/test/path/'
        @getBaseDir().should.equal '/test/path/'
        revert()

      it 'should be able to handle upper directories', ->
        revert = finder.__set__ 'process',
          cwd: -> '/test/path'
        @getBaseDir('..').should.equal '/test/'
        @getBaseDir('../asdf').should.equal '/test/asdf/'
        revert()

      it 'should be able to handle the root directory', ->
        revert = finder.__set__ 'process',
          cwd: -> '/test/path'
        @getBaseDir('/').should.equal '/'
        revert()
