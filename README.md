# C--
C-- is a C++ shell that can be embeded in the browser. 

The project is in early stages, so things may go wrong.

Run
---
 - **Terminal**: just type `node index.js` to run the interpreter in your terminal. You can attach a relative path to run a program directly. We also cover a debug option (-d).
 - **Browser**: run the `browserify.sh` script in the *browser* directory. Brofserify and uglifyjs must be globally installed via npm. Then run the webpage via a local server like `http-server`. *Note*: for this method to work, grammar.js must be generated in the *parser* directory via `jison grammar.jison`.
