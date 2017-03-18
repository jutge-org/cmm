var gulp = require('gulp'),
    browserify = require('browserify'),
    coffeeify = require('coffeeify'),
    jisonify = require('jisonify'),
    source = require('vinyl-source-stream'),
    uglify = require('gulp-uglify'),
    buffer = require('vinyl-buffer');


gulp.task('build', function() {
    return browserify('./src/browser.coffee', {extensions:['.coffee']})
        .transform(coffeeify)
        .transform(jisonify)
        .bundle()
        .pipe(source('index.min.js')) // gives streaming vinyl file object
        .pipe(buffer()) // convert from streaming to buffered vinyl file object
        .pipe(uglify()) // now gulp-uglify works
        .pipe(gulp.dest('./build'))
});

gulp.task('dev', function() {
    return browserify('./src/browser.coffee', {extensions:['.coffee']})
        .transform(coffeeify)
        .transform(jisonify)
        .bundle()
        .pipe(source('index.min.js'))
        .pipe(gulp.dest('./build'))
});

gulp.task('default', ['build'], function() {
});
