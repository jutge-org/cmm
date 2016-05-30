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

console.log Ast

grammar = readFileSync GRAMMAR_PATH, "utf-8"
parser = new Parser grammar
parser.yy = { Ast } # new yy.Ast(...)

compile = (code) ->
    ast = parser.parse code
    checkSemantics ast


execute = (ast) ->
    interpreter.load ast
    interpreter.run()

execute = (code) ->
    try
        prog = parser.parse code
        if debug then console.log util.inspect(prog, { showHidden: false, depth: null })
        interpreter.load(prog)
        res = interpreter.run()
        # res {value: returned value, output: output printed to cout}
        if res?.output?
            for line in res.output then console.log line
    catch error
        console.error error.stack ? error

if file? # Non-interactive, parse file
    execute file
else # Shell interactive execution
    process.argv[2..] = [] # So that shell doesn't parse the options as commands

    app = new shell({ chdir: __dirname })

    app.configure(->
        app.use(shell.history({ shell: app }))
    )

    app.on('command', ([command]) -> execute command)
