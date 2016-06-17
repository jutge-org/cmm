fs = require 'fs'

TIPUS = ["int", "double", "char", "bool", "string"]

isIntegral = (t) -> t in ["int", "char", "bool"]
isNumber = (t) -> t in ["int", "char", "bool", "double"]

OPS = ["+", "-", "/", "*", "or", "and", "<=", ">=", "==", "!=", ">", "<", "%", "+=", "-=", "*=", "/=", "%="]

isArithmetic = (op) -> op in ["+", "-", "/", "*", "%", "+=", "-=", "*=", "/=", "%="]
isLogic = (op) -> op in ["or", "and"]

PROHIBITED = {}
for operator in OPS
    PROHIBITED[operator] = {}
    for tipus in TIPUS
        PROHIBITED[operator][tipus] = {}

prohibited = (op, t1, t2) ->
    PROHIBITED[op][t1][t2] = yes

isProhibited = (op, t1, t2) ->
    PROHIBITED[op][t1][t2] or PROHIBITED[op][t2][t1]

for type in TIPUS
    for op in OPS
        PROHIBITED[op]["string"][type] = yes

delete PROHIBITED["=="].string.string
delete PROHIBITED["!="].string.string
delete PROHIBITED[">="].string.string
delete PROHIBITED["<="].string.string
delete PROHIBITED[">"].string.string
delete PROHIBITED["<"].string.string

for op in OPS when isArithmetic(op) or isLogic(op)
    for type in TIPUS
        PROHIBITED[op].string[type] = yes

for tipus in TIPUS
    PROHIBITED["%"].double[tipus] = PROHIBITED["%="].double[tipus] = true

PROGRAMA =
    """
        #include <iostream>
        using namespace std;

        int main() {
            string tipusa, tipusb, op;
            while (cin >> tipusa >> tipusb >> op) {
        <<tipus>>
            }
        }
    """

string = ""

indent = (x) ->
    (s) ->
        (" " for i in [0...x]).join("") + s

indentCode = (code, i) -> code.split("\n").map(indent(i)).join("\n")

for tipusa in TIPUS
    for tipusb in TIPUS
        string +=
            """
                if (tipusa == \"#{tipusa}\" and tipusb == \"#{tipusb}\") {
                    #{tipusa} a; #{tipusb} b;
                    cin >> a >> b;

                <<ops>>
                }

            """
        stringOps = ""
        for op in OPS
            operation = if isProhibited op, tipusa, tipusb then "\"operacio no permesa!\"" else "(a #{op} b)"
            stringOps +=
                """
                    if (op == \"#{op}\") {
                        cout << "#{tipusa}(" << a << ")" << " #{op} #{tipusb}(" << b << "): " << #{operation} << endl;
                    }
                """

        stringOps = indentCode stringOps, 4

        string = string.replace("<<ops>>", stringOps)

string = indentCode string, 8
PROGRAMA = PROGRAMA.replace("<<tipus>>", string)

fs.writeFileSync "./programa.cc", PROGRAMA, { encoding: "utf-8" }


SAMPLE = {}

SAMPLE.int = [2,10,0,1, -2, -1, -12]
SAMPLE.bool = [0,1]
SAMPLE.double = [2.5,0.005, 0.0, -1.9, 3.1415]
SAMPLE.char = ['a', '-', 'c', 'd', '0', 'A']
SAMPLE.string = ["albert", ">=", "lol", "!=", "+", "cl"]

INPUT = ""
for typea in TIPUS
    for typeb in TIPUS
        for op in OPS
            r = Math.random()
            r2 = Math.random()
            randomA = SAMPLE[typea][Math.floor SAMPLE[typea].length*r]
            randomB = SAMPLE[typeb][Math.floor SAMPLE[typeb].length*r2]
            if op in ["/", "/=", "%", "%="] and typeb in ["int", "bool"]
                while randomB is 0
                    randomB = SAMPLE[typeb][Math.floor SAMPLE[typeb].length*Math.random()]
            INPUT += "#{typea} #{typeb} #{op} #{randomA} #{randomB}\n"

fs.writeFileSync "input.in", INPUT
