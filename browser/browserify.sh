# The -t option is used to specify plugins. In this case coffeeify allows
# to require .coffee files and jisonify allows to require .jison files
coffee -c js/main.coffee
browserify -t coffeeify -t jisonify --extension=".coffee" js/run.coffee -o js/run.js
sed -i -e 's/onmessage,//g' js/run.js
uglifyjs < js/run.js > js/run.min.js
