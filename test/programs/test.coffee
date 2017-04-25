fs = require 'fs'
path = require 'path'
assert = require 'assert'

cmm = require '../../'

testio = (code, expectedCompilationError, expectedStatus, input = "", expectedOutput) ->
    try
        { program } = cmm.compile code
    catch compilationError
        unless compilationError.generated
            throw compilationError

    compilationErrorCode = compilationError?.code ? 0

    assert.equal(compilationErrorCode, expectedCompilationError, "Invalid compilation error code, got #{compilationError?.message ? "no error"}")

    if compilationErrorCode isnt 0
        return


    { output, status } = cmm.runSync(program, input)

    assert.equal(status, expectedStatus, "Invalid exit status code")

    if expectedOutput?
        assert.equal(output, expectedOutput, "Invalid program output")



testProgram = (name, { path: fPath, tests }) ->
    code = fs.readFileSync fPath, 'utf-8'

    header = /^\s*\/\*([\s\S]+)\*\//g.exec(code)

    unless header?
        throw "Test #{fPath} did not properly define a header"

    header = header[1].trim()

    description = /description\((.+)\)/.exec(header)

    unless description?
        throw "Test #{fPath} did not define a description in its header"

    description = description[1].trim()

    expectedCompilationError = parseInt(/compilation-error\((.+)\)/.exec(header)?[1] ? "0")

    expectedStatus = parseInt(/status\((.+)\)/.exec(header)?[1] ? "0")

    if Object.keys(tests).length > 0
        describe("#{name}: #{description}", ->
            for testName, test of tests
                do (testName, test) ->
                    if test.input?
                        test.input = fs.readFileSync test.input, 'utf-8'
                    if test.output?
                        test.output = fs.readFileSync test.output, 'utf-8'

                    it testName, -> testio code, expectedCompilationError, expectedStatus, test.input, test.output
        )
    else
        it "#{name}: #{description}", -> testio code, expectedCompilationError, expectedStatus




testFolder = (cPath) ->
    folderName = path.basename(cPath)
    describe(folderName, ->
        programs = {}
        inputs = []
        outputs = []

        for element in fs.readdirSync(cPath)
            fPath = path.join(cPath, element)

            basename = path.basename(fPath)

            stat = fs.lstatSync(fPath)

            if stat.isDirectory()
                testFolder fPath
            else if program = /^(.+)\.cc$/.exec(basename)
                program = program[1]

                if programs[program]?
                    throw "Duplicate program test #{fPath}"

                programs[program] = { tests: {}, path: fPath }
            else if input = /^(.+)(?:-(.+))?\.in$/g.exec(basename)
                [ _, program, name ] = input
                name ?= program
                inputs.push([ program, name, fPath ])
            else if output = /^([^-]+)(?:-(.+))?\.out$/g.exec(basename)
                [ _, program, name ] = output
                name ?= program
                outputs.push([ program, name, fPath ])


        for { io, ioName } in [{ io: inputs, ioName: 'input' }, { io: outputs, ioName: 'output' }]
            for [ program, name, testPath ] in io
                unless programs[program]?
                    unless programs.program?
                        throw "No matching program for #{ioName} test #{testPath}"
                    else
                        name = program
                        program = "program"

                if programs[program].tests[name]?[ioName]?
                    throw "Duplicate #{ioName} #{fPath}"

                programs[program].tests[name] ?= {}
                programs[program].tests[name][ioName] = testPath

        for programName, program of programs
            if programName is "program"
                if programs[folderName]?
                    throw "Both a program named as its parent folder and program.cc were defined. Rename either of them."

                programName = folderName

            testProgram(programName, program)

    )




testFolder(__dirname)