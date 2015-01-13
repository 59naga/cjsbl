cjsbl=
  host: 'localhost'
  port: 59798
  public_html: 'public_html'

gulp= require 'gulp'
gulp.task 'default',['coffee-script','jade','stylus','bower'],->
  gulp.start 'livereload'
  gulp.start '> public_html'

gulp.task 'coffee-script',->
  browserify= require 'browserify'
  source= require 'vinyl-source-stream'
  browserify
      entries:"./.coffee/index.coffee"
      extensions:'.coffee'
    .transform 'coffeeify'
    .bundle()
    .pipe source 'index.js'
    .pipe gulp.dest cjsbl.public_html

gulp.task 'jade',->
  jade= require 'gulp-jade'
  gulp.src [".jade/**/*.jade","!.jade/_**/*.jade"]
    .pipe jade
      basedir:"#{process.cwd()}/.jade"
      pretty:true
    .pipe gulp.dest cjsbl.public_html

gulp.task 'stylus',->
  stylus= require 'gulp-stylus'
  pleeease= require 'gulp-pleeease'
  gulp.src ".styl/index.styl"
    .pipe stylus()
    .pipe pleeease {
      minifier:false
      autoprefixer:
        browsers:
          ['last 3 version','android 2.3']
    }
    .pipe gulp.dest cjsbl.public_html

gulp.task 'bower',->
  main= require 'main-bower-files'
  jsfy= require 'gulp-jsfy'
  concat= require 'gulp-concat'
  gulp.src main
    paths:
      bowerDirectory:'bower_components'
      bowerJson:'bower.json'
  .pipe jsfy()
  .pipe concat 'bower_components.js'
  .pipe gulp.dest cjsbl.public_html

gulp.task 'livereload',->
  livereload= require 'gulp-connect'
  livereload.server 
    livereload: true
    host: cjsbl.host
    port: cjsbl.port
    root: cjsbl.public_html
  
  watch= require 'gulp-watch'
  watch ".coffee/**/*.coffee",->
    gulp.start 'coffee-script'

  watch ".jade/**/*.jade",->
    gulp.start 'jade'

  watch ".styl/**/*.styl",->
    gulp.start 'stylus'

  watch "bower.json",->
    gulp.start 'bower'

  gulp.src "#{cjsbl.public_html}/**"
    .pipe watch "#{cjsbl.public_html}/**"
    .pipe livereload.reload()
  
gulp.task '> public_html',->
  open= require 'gulp-open'
  gulp.src "#{cjsbl.public_html}/index.html"
    .pipe open '',url:"http://#{cjsbl.host}:#{cjsbl.port}"