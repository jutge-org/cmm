# C--
C-- is a C++ shell interpreter that can be embedded in the browser. 

The project is in early stages, so things may go wrong.

Compilation
-----------
   - In your home directory, run `curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -`
   - Run `sudo apt-get install -y nodejs`
   - Optionally, you can run `sudo apt-get install -y build-essential`
   - Now from the project directory, run `npm install`
   - Finally run `sudo npm install -g browserify coffee-script coffeeify jisonify`

Run
---
From the project directory, just run `./run` from the terminal, a new browser window should pop-up.

## [Try it!](http://c--lang.xyz/browser/)