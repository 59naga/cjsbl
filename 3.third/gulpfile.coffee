public_html= 'public_html'

gulp= require 'gulp'
gulp.task 'default',['coffee-script','jade','stylus','watch','livereload']

gulp.task 'coffee-script',->
  coffee= require 'gulp-coffee'
  gulp.src ".coffee/index.coffee"
    .pipe coffee()
    .pipe gulp.dest public_html

gulp.task 'jade',->
  jade= require 'gulp-jade'
  gulp.src ".jade/**/*.jade"
    .pipe jade()
    .pipe gulp.dest public_html

gulp.task 'stylus',->
  stylus= require 'gulp-stylus'
  gulp.src ".styl/index.styl"
    .pipe stylus()
    .pipe gulp.dest public_html


gulp.task 'watch',->
  watch= require 'gulp-watch'
  watch ".coffee/**/*.coffee",->
    gulp.start 'coffee-script'

  watch ".jade/**/*.jade",->
    gulp.start 'jade'

  watch ".styl/**/*.styl",->
    gulp.start 'stylus'

gulp.task 'livereload',->
  livereload= require 'gulp-connect'
  livereload.server
    livereload: true
    root: public_html

  watch= require 'gulp-watch'
  gulp.src "#{public_html}/**"
    .pipe watch "#{public_html}/**"
    .pipe livereload.reload()
