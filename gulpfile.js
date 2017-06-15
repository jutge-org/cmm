var gulp = require('gulp'),
    browserify = require('browserify'),
    coffeeify = require('coffeeify'),
    source = require('vinyl-source-stream'),
    minify = require('gulp-minify'),
    buffer = require('vinyl-buffer'),
    gutil = require('gulp-util')
    coffee = require('gulp-coffee');

function string_src(filename, string) {
  var src = require('stream').Readable({ objectMode: true })
  src._read = function () {
    this.push(new gutil.File({
      cwd: "",
      base: "",
      path: filename,
      contents: new Buffer(string)
    }))
    this.push(null)
  }
  return src
}

gulp.task('generate-grammar-js', function() {
    return gulp.src('./src/compiler/parser/grammar.coffee')
        .pipe(coffee({ bare: true }))
        .pipe(gulp.dest('./build/'));
});

gulp.task('generate-parser', ['generate-grammar-js'], function() {
    var parserCode = require('./build/grammar.js').parser.generate();

    return string_src("parser.js", parserCode)
            .pipe(gulp.dest('./src/compiler/parser/'))
})

gulp.task('build', ['generate-parser'], function() {
    return browserify('./index.coffee', {extensions:['.coffee']})
        .transform(coffeeify)
        .bundle()
        .pipe(source('index.js')) // gives streaming vinyl file object
        .pipe(buffer()) // convert from streaming to buffered vinyl file object
        .pipe(minify({ ext: { src: ".js", min: ".min.js" } })) // now gulp-uglify works
        .on('error', function (err) { gutil.log(gutil.colors.red('[Error]'), err.toString()); })
        .pipe(gulp.dest('./build'))
});

gulp.task('dev', ['generate-parser'], function() {
    return browserify('./index.coffee', {extensions:['.coffee']})
        .transform(coffeeify)
        .bundle()
        .pipe(source('index.js'))
        .pipe(gulp.dest('./build'))
});

gulp.task('default', ['build'], function() {
});
