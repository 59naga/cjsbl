public_html= 'public_html'

gulp= require 'gulp'
gulp.task 'default',['coffee','jade','stylus']

gulp.task 'coffee',->
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
  gulp.src ".stylus/index.stylus"
    .pipe stylus()
    .pipe gulp.dest public_html