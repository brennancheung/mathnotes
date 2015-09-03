gulp = require 'gulp'
jade = require 'gulp-jade'
gutil = require 'gulp-util'
watch = require 'gulp-watch'
using = require 'gulp-using'
rimraf = require 'rimraf'
inject = require 'gulp-inject'
coffee = require 'gulp-coffee'
uglify = require 'gulp-uglify'
concat = require 'gulp-concat'
stylus = require 'gulp-stylus'
plumber = require 'gulp-plumber'
minifyCSS = require 'gulp-minify-css'
gulpFilter = require 'gulp-filter'
livereload = require 'gulp-livereload'
runSequence = require 'run-sequence'

env = process.env.NODE_ENV || 'development'
skipMinify = process.env.SKIP_MINIFY is 'true'
development = env is 'development'
production = env is 'production'

paths =
    build:   "build"
    jade:    "src/**/*.jade"
    css: [
        "!src/materialize/**/*"
        "src/**/*.css"
        "src/**/*.styl"
    ]
    js: [
        "!src/materialize/**/*"
        "!src/MathJax/**/*"
        "src/**/*.js"
        "src/**/*.coffee"
    ]
    font: "src/font/**/*"
    materialize: "src/materialize/**/*"
    mathjax: "src/mathjax/**/*"
    static: [
        "src/**/*.jpg"
        "src/**/*.jpeg"
        "src/**/*.png"
        "src/**/*.gif"
        "src/**/*.html"
        "src/**/*.json"
    ]

outputPath = paths.build

absolutePathFor = (suffix) ->
    pathComponents = process.cwd().split('/')
    pathComponents[pathComponents.length - 1] = suffix if suffix
    return pathComponents.join '/'

relativePath = (fullPath, suffix) ->
    # strips the an absolute + prefix off of a fullPath
    # E.g., "/Users/username/git/pf9-ui/#{prefix}/scripts/main.js" -> "scripts/main.js"
    absolutePath = absolutePathFor(suffix)
    return fullPath.slice(absolutePath.length+1)

jadeOptions =
    pretty: development
    data:
        env: env


# The default tasks that will be run if no task(s) are passed to gulp.
gulp.task 'default', ->
    runSequence 'clearscreen', 'build', 'server', 'watch'


gulp.task 'sw', ->
    runSequence 'server', 'watch'

gulp.task 'clearscreen', ->
    console.log '\u001B[2J\u001B[0;0f'


# Make the various assets from 'src' and store them in 'build'
gulp.task 'build', (cb) ->
    runSequence 'clean', 'static-assets', 'jade', 'css', 'js', cb


# Wipes the build and dist folders.
gulp.task 'clean', (cb) ->
    rimraf.sync paths.build
    cb()


# Simple copy of static assets from source to the build folder.
gulp.task 'static-assets', ->
    gulp.src paths.static
        .pipe gulp.dest outputPath, base: "src"
    gulp.src paths.font
        .pipe gulp.dest "#{outputPath}/font"
    gulp.src paths.materialize
        .pipe gulp.dest "#{outputPath}/materialize"
    gulp.src paths.mathjax
        .pipe gulp.dest "#{outputPath}/MathJax"


# Compile jade templates into html and store them in the build folder.
gulp.task 'jade', ->
    gulp.src paths.jade
        .pipe jade jadeOptions
        .pipe gulp.dest outputPath


# Compile stylus templates into CSS and store them in the build folder.
# Copy CSS files as is.
gulp.task 'css', ->
    stylusFilter = gulpFilter "**/*.styl", restore: true
    sources = gulp.src paths.css
        .pipe stylusFilter
        .pipe stylus()
        .pipe stylusFilter.restore()
        .pipe gulp.dest outputPath

gulp.task 'js', ->
    coffeeFilter = gulpFilter "**/*.coffee"
    if development
        sources = gulp.src paths.js
            .pipe coffeeFilter # compile CoffeeScript into JS and store them in the build folder
            .pipe coffee()
            .pipe coffeeFilter.restore() # copy JS files as is
            .pipe gulp.dest outputPath

# Watch for local file changes.
# Re-compile the changed file and copy it to the build directiory.
gulp.task 'watch', ->
    watch paths.jade
        .pipe plumber()
        .pipe jade jadeOptions
        .pipe gulp.dest outputPath

    stylusFilter = gulpFilter "**/*.styl"
    watch paths.css
        .pipe plumber()
        .pipe stylusFilter
        .pipe stylus()
        .pipe stylusFilter.restore()
        .pipe gulp.dest outputPath

    coffeeFilter = gulpFilter "**/*.coffee"
    watch paths.js
        .pipe plumber()
        .pipe coffeeFilter
        .pipe coffee()
        .pipe coffeeFilter.restore()
        .pipe gulp.dest outputPath

    livereload.listen()
    watch("#{outputPath}/**/*")
        .pipe livereload()


# Launch the server for local development.
gulp.task 'server', ->
    Server = require './server/server'
    server = new Server()
    server.start()

