public_html= 'public_html'

gulp= require 'gulp'
watch= require 'gulp-watch'

gulp.task 'default',['coffee','jade','scss','livereload','bower']
gulp.task 'coffee',->
  coffee= require 'gulp-coffee'
  gulp.src ".coffee/index.coffee"
    .pipe coffee()
    .pipe gulp.dest public_html

gulp.task 'jade',->
  jade= require 'gulp-jade'
  gulp.src ".jade/index.jade"
    .pipe jade()
    .pipe gulp.dest public_html

gulp.task 'scss',->
  scss= require 'gulp-ruby-sass'
  gulp.src ".scss/index.scss"
    .pipe scss()
    .pipe gulp.dest public_html

gulp.task 'bower',->
  bower= require 'main-bower-files-build'
  bower
    paths:
      bowerDirectory:"#{__dirname}/bower_components/"
      bowerJson:'bower.json'
  .pipe gulp.dest public_html

gulp.task 'livereload',->
  livereload= require 'gulp-connect'
  livereload.server 
    root: public_html
    port: 59798
    livereload: true
    
  watch [".coffee/*.coffee",".coffee/**/*.coffee"],->
    gulp.start 'coffee'

  watch [".jade/*.jade",".jade/**/*.jade"],->
    gulp.start 'jade'

  watch [".scss/*.scss",".scss/**/*.scss"],->
    gulp.start 'scss'

  watch ["bower.json","#{__dirname}/bower_components/"],->
    gulp.start 'bower'

  watch "#{public_html}/*",->
    gulp.src "#{public_html}/*"
      .pipe livereload.reload()

  gulp.start 'default'
  
gulp.task 'open',['default'],->
  open= require 'gulp-open'
  gulp.src "#{public_html}/index.html"
    .pipe open '',{url:"http://localhost:59798"}
