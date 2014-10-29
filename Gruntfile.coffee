module.exports = (grunt) ->
  require('load-grunt-tasks')(grunt)
  require('time-grunt')(grunt)

  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')
    clean:
      lib: ['lib']
      doc: ['doc']
      test: ['test_results']
    coffee:
      options:
        sourceMap: true
      build:
        files: [
          expand: true
          cwd: 'src'
          src: ['**/*.+(coffee|litcoffee)']
          dest: 'lib'
          ext: '.js'
          extDot: 'last'
        ]
    docco:
      options:
        output: 'doc'
        layout: 'linear'
      build:
        src: ['src/**/*.+(coffee|litcoffee)']
    mochacov:
      options:
        ui: 'bdd'
        slow: 100
        require: ['coffee-script/register']
      test:
        options:
          reporter: 'nyan'
          colors: true
        src: ['test/specs/**/*.spec.+(coffee|litcoffee|js)']
      coverage:
        options:
          reporter: 'html-cov'
          colors: false
          quiet: true
          output: 'test_results/mocha.html'
        src: ['test/specs/**/*.spec.+(coffee|litcoffee|js)']

    watch:
      options:
        forever: true
      coffee:
        files: 'src/**/*.+(coffee|litcoffee)'
        tasks: ['coffee', 'docco']


    grunt.registerTask 'doc', 'Generate the docco documents',
      ['clean:doc', 'docco']

    grunt.registerTask 'compile', 'Compile the code',
      ['clean:lib', 'coffee']

    grunt.registerTask 'build', 'Build the project',
      ['compile', 'doc']

    grunt.registerTask 'test:client', 'Run UT locally',
      ['clean:test', 'mochacov:test', 'mochacov:coverage']

    grunt.registerTask 'test:server', 'Run UT at server side',
      ['clean:test', 'mochacov:coverage']

    grunt.registerTask 'dev', 'Start developing',
      ['build', 'watch']

    grunt.registerTask 'default', 'UT (when has) & build',
      ['build', 'test:client']

    grunt.registerTask 'ci', 'UT (when has) & build',
      ['build', 'test:server']
