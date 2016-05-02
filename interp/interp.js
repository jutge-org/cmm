module.exports = {
    load: function(root) {
        this.root = root;
    },
    run: function() {
        run_statements(this.root);
    }
};

function run_statements(ast) {
    console.log(ast);
    if (ast.getType() !== 'no-op') {
        run_statements(ast.getChild(0));
        execute_instr(ast.getChild(1));
    }
}

function execute_instr(ast) {
    if (ast.getType() === ':=') {
        assign(ast);
    }
    else {
        execute_instr(ast.getChild(0));
        assign(ast.getChild(1));
    }
}

function assign(ast) {
    var ID = ast.getChild(0);
    var VAL = eval_expr(ast.getChild(1));
    // TODO
    console.log(ID);
    console.log(VAL);
}

function eval_expr(ast) {
    switch (ast.getType()) {
        case 'NUMBER':
            return Number(ast.getChild(0));
    }
}
