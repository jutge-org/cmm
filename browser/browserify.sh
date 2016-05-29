# The -t option is used to specify plugins. In this case coffeeify allows
# to require .coffee files and jisonify allows to require .jison files
browserify -t coffeeify -t jisonify --extension=".coffee" js/main.coffee -o js/main.js

uglifyjs < js/main.js > js/main.min.js
