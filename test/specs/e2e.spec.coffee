'use strict'

path = require 'path'
fs = require 'fs-extra'
glob = require 'glob'
should = require('chai').should()
rewire = require 'rewire'
operations = rewire '../../src/operations'
main = rewire '../../src/cleaner'

describe 'E2E:', ->
  before -> fs.removeSync 'test/.sandbox'
  beforeEach -> fs.copySync 'test/sandbox_src', 'test/.sandbox'
  afterEach -> fs.removeSync 'test/.sandbox'

  it.only 'should rename', (done) ->
    main ['test/.sandbox', '-r', 'test-ext']
    setTimeout ->
      glob.sync('test/.sandbox/**/*.test-ext', { nocase: true }).length.should.equal(6)
      glob.sync('test/.sandbox/**/*.jpg', { nocase: true }).length.should.equal(6)
      done()
    , 500
  return
