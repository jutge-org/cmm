var parser = require('../../parser/grammar').parser;
var interp = require('../../interp/interp');

parser.yy = require('../../interp/ast-tree');

function parse(input) {
    return parser.parse(input);
}

window.execute = function (raw_program) {
    var ast = parse(raw_program);
    interp.load(ast);
    interp.run();
};
