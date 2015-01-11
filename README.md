# CJSBL
is **c**offee-script, **j**ade, **s**tylus, **b**[ower_components](https://www.npmjs.com/package/gulp-jsfy), **l**ivereload > public_html

# ハローワールド
![](http://i.gyazo.com/5612fd5db2051401c5486890302b1355.gif)

```bash
$ git clone https://github.com/59naga/cjsbl.git
$ cd cjsbl/last
$ npm start
```

# やりたいこと
[coffee-script](http://coffeescript.org/), [jade](http://qiita.com/sasaplus1/items/189560f80cf337d40fdf), [stylus](http://kyosuke.tumblr.com/post/14003234226/stylus) をコンパイルする。

```
./
  .coffee
      index.coffee
  .jade
      index.jade
  .stylus
      index.stylus

  public_html
```

コンパイル後

```
./
  public_html
      index.js
      index.html
      index.css
```

# [1.コンパイラの起動](https://github.com/59naga/cjsbl/tree/master/1.first)

![スクリーンショット 2015-01-11 2.11.38 PM.png](http://i.gyazo.com/cb74e3af00d40bc4b0257619c458ae10.gif)

```
$ npm start
$ open public_html/index.html
```

`npm start`するには、以下の2設定ファイルが必要。

1. `./gulpfile.coffee`
  ```coffeescript
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
  ```
2. `./package.json`
  ```json
  {
    "dependencies": {
      "coffee-script": "^1.8.0",
      "gulp": "^3.8.10",

      "gulp-coffee": "^2.2.0",
      "gulp-jade": "^0.10.0",
      "gulp-stylus": "^1.3.6"
    },
    "scripts": {
      "start": "npm install && gulp"
    }
  }
  ```

指定のフォルダに、コンパイルしたファイルが出来る。単体で実行するときは`$ gulp coffee`と打つ。

# [2.ファイルの監視](https://github.com/59naga/cjsbl/tree/master/2.second)
このままでは、変更のたびにコンパイラを再実行しなければならない。ファイルが変更されたり、作成した時に、自動で実行するように設定する。

1. `./gulpfile.coffee`に下記を追記する。
  ```coffeescript
  gulp.task 'watch',->
    watch= require 'gulp-watch'
    watch ".coffee/**/*.coffee",->
      gulp.start 'coffee'

    watch ".jade/**/*.jade",->
      gulp.start 'jade'

    watch ".stylus/**/*.stylus",->
      gulp.start 'stylus'
  ```

2. `./package.json`の`"dependencies"`に[`"gulp-watch": "^3.0.0"`](https://www.npmjs.com/package/gulp-watch)を追記する。
  * e.g. `$ npm install gulp-watch --save`

```bash
$ npm start
```
![](http://i.gyazo.com/63c9b787998699285a1c3c1eb018b19b.gif)

gulp-watchは `watch(files,function)` のように書く。`files`は文字列か配列で`path/to/file.ext`、ワイルドカード`*`,`**`が使用できる。

`$ npm start`を実行するとファイルの監視状態になる。この状態で`files`を作成・変更・削除すると、`function`を実行する。

# [3.ブラウザのリロード](https://github.com/59naga/cjsbl/tree/master/3.third)
欲を言えば、ブラウザのリロードも自動で行いたい。エディタの横にブラウザを置けば、たぶんキーボードの寿命は伸びるだろう。

1. `./gulpfile.coffee`に下記を追記する。
  ```coffeescript
  gulp.task 'livereload',->
    livereload= require 'gulp-connect'
    livereload.server
      livereload: true
      root: public_html

    watch= require 'gulp-watch'
    gulp.src "#{public_html}/**"
      .pipe watch "#{public_html}/**"
      .pipe livereload.reload()
  ```

2. `./package.json`の`"dependencies"`に[`"gulp-connect": "^2.2.0"`](https://www.npmjs.com/package/gulp-connect)を追記する。
  * e.g. `$ npm install gulp-connect --save`

```bash
$ npm start
```
![](http://i.gyazo.com/62f0d229feb0180820dd8ecc26529cb2.gif)

livereload.serverは、引数のrootを監視する。`Server started http://localhost:8080`とメッセージを返すので、URLをブラウザで開く。

*───これであなたも Getting started.*


# [4.コンパイラの細かい設定](https://github.com/59naga/cjsbl/tree/master/0.last)
<!-- ところがトムは実際にコーディングを始めてみて、さらに快適な環境を望むようになった。
* coffee
  * ファイルを分割して、[require](https://github.com/59naga/app.jip)で読み込み、１ファイルにまとめる。
* jade
  * ヘッダー、フッターなどの共通部を使い回す。ただし、公開するhtmlのファイル構造をイメージしやすいように、.jadeの構造を使いまわす。
* stylus
  * ページごとの局所的なデザインを、jadeと同じファイル構造に書く。初期設定やmixinをコンパイルせず、importして使う。
* bower
  * `$ bower install jquery moment animate.css`して、すぐに使いたい。
 -->
![](https://qiita-image-store.s3.amazonaws.com/0/28576/02085a0f-c57f-c933-661c-f0b7d496ddc2.png)

# [5.ライブラリの管理と圧縮](https://github.com/59naga/cjsbl/tree/master/0.last)
![](https://qiita-image-store.s3.amazonaws.com/0/28576/02085a0f-c57f-c933-661c-f0b7d496ddc2.png)

# License
  MIT