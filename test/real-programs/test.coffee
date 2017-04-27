fs = require 'fs'
path = require 'path'
cmm = require '../../src'
chai = require 'chai'
assert = chai.assert

BASE = __dirname

CODE = "code.cc"
INPUT = "input.txt"
OUTPUT = "output.txt"

# Helpers
readFile = (filePath) -> fs.readFileSync(filePath, 'utf-8')
printSeparator = -> console.log "-------------------------------------"

runTest = (testSetName, testName, testPath) ->
    code = readFile path.join(testPath, CODE)
    input = readFile path.join(testPath, INPUT)
    expectedOutput = readFile path.join(testPath, OUTPUT)

    printTestFailureInfo = (output) ->
        printSeparator()
        console.log "Expected output:"
        process.stdout.write expectedOutput
        printSeparator()
        console.log "Output:"
        process.stdout.write output
        printSeparator()
        console.log "Input:"
        process.stdout.write input
        printSeparator()
        console.log "Program code:"
        process.stdout.write code
        printSeparator()
        console.log "Instructions:"
        program.writeInstructions()
        printSeparator()
        console.log "Ast:"
        console.log ast.toString()
        printSeparator()

    try
        { program, ast } = cmm.compile code
    catch error
        return # Probably not valid code for C--

    try
        { output } =  cmm.runSync program, input
    catch error
        console.log "Execution error for test set #{testSetName} on test #{testName} (problemid-submissionid-sampletestid):"
        console.log error
        printSeparator()
        printTestFailureInfo(output)
        assert(false, "Execution error")

    if output isnt expectedOutput
        console.log "Invalid output for test set #{testSetName} on #{testName} (problemid-submissionid-sampletestid):"
        printTestFailureInfo(output)
        assert(false, "Invalid output")

runTestSet = (testSetFolder) ->
    describe "Test set #{testSetFolder}", ->
        this.timeout(500)

        testsPath = path.join(BASE, testSetFolder)

        tests = (file for file in fs.readdirSync(testsPath) when file not in ['.DS_Store']).sort()

        for test in tests
            do (test)->
                testPath = path.join(testsPath, test)

                it "Runs program, input, output test #{test}", ->
                    runTest(testSetFolder, test, testPath)


TEST_SETS = (fileName for fileName in fs.readdirSync(BASE) when fs.lstatSync(path.join(BASE, fileName)).isDirectory())

TEST_SETS.forEach(runTestSet)