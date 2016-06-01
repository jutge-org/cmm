#!/usr/bin/env coffee

{ readFileSync } = require 'fs'
{ Parser } = require 'jison'
util = require 'util'
shell = require 'shell'
program = require 'commander'

Ast = require './parser/ast'
{ version } = require './package'
{ checkSemantics } = require './semantics'
interpreter = require './interpreter'

GRAMMAR_PATH = "./parser/grammar.jison"
debug = no

file = null

program
    .version(version)
    .arguments('[file]')
    .action((_file) ->
        file = readFileSync _file, 'utf-8'
    )
    .option('-d, --debug', 'output debug information', -> debug = yes)
    .parse(process.argv)

grammar = readFileSync GRAMMAR_PATH, "utf-8"
parser = new Parser grammar
parser.yy = { Ast } # new yy.Ast(...)

execute = (code, exit = yes) ->
    try
        ast = parser.parse code
        if debug then console.log util.inspect(ast, { showHidden: false, depth: null })
        ast = checkSemantics ast
    catch error
        console.error "Compilation error:"
        console.error error.stack ? error
        return

    try
        interpreter.load ast
        { status, stdout, stderr, output } = interpreter.run()
        # res {value: returned value, output: output printed to cout}
        console.log output
        if exit
            process.exit status
    catch error
        console.error error.stack ? error

if file? # Non-interactive, parse file
    execute readFileSync(file, 'utf-8')
else # Shell interactive execution
    process.argv[2..] = [] # So that shell doesn't parse the options as commands

    app = new shell({ chdir: __dirname })

    app.configure(->
        app.use(shell.history({ shell: app }))
    )

    app.on('command', ([command]) ->
        execute command, no
    )
