#!/usr/bin/env bash

browserify lib/browser.js | uglifyjs > lib/bundle.js