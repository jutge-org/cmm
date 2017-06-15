var gulp = require('gulp'),
    browserify = require('browserify'),
    coffeeify = require('coffeeify'),
    source = require('vinyl-source-stream'),
    minify = require('gulp-minify'),
    buffer = require('vinyl-buffer'),
    gutil = require('gulp-util');


gulp.task('build', function() {
    return browserify('./index.coffee', {extensions:['.coffee']})
        .transform(coffeeify)
        .bundle()
        .pipe(source('index.js')) // gives streaming vinyl file object
        .pipe(buffer()) // convert from streaming to buffered vinyl file object
        .pipe(minify({ ext: { src: ".js", min: ".min.js" } })) // now gulp-uglify works
        .on('error', function (err) { gutil.log(gutil.colors.red('[Error]'), err.toString()); })
        .pipe(gulp.dest('./build'))
});

gulp.task('dev', function() {
    return browserify('./index.coffee', {extensions:['.coffee']})
        .transform(coffeeify)
        .bundle()
        .pipe(source('index.js'))
        .pipe(gulp.dest('./build'))
});

gulp.task('default', ['build'], function() {
});
