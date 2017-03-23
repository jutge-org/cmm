assert = require 'assert'

module.exports = class Ast
    @TYPES: Object.freeze({
            VOID: 'VOID'
            INT: 'INT'
            DOUBLE: 'DOUBLE'
            STRING: 'STRING'
            CHAR: 'CHAR'
            BOOL: 'BOOL'
            FUNCTION: 'FUNCTION'
            CIN: 'CIN' # Doesn't appear in the grammar as a type cause
                       # we don't really want it to appear explicitly anywhere
                       # (as a type)
        })

    @OPERATORS: Object.freeze({
            PLUS: '+'
            MINUS: '-'
            UPLUS: 'u+'
            UMINUS: 'u-'
            MUL: '*'
            DIV: '/'
            DOUBLE_DIV: 'd/'
            INT_DIV: 'i/'
            MOD: '%'
            OR: '||'
            AND: '&&'
            NOT: '!'
            ASSIGN: '='
            POST_INC: 'a++'
            POST_DEC: 'a--'
            LT: '<'
            GT: '>'
            LTE: '<='
            GTE: '>='
            EQ: '=='
            NEQ: '!='
        })

    @LITERALS: Object.freeze({
            INT: 'INT_LIT'
            DOUBLE: 'DOUBLE_LIT'
            BOOL: 'BOOL_LIT'
            CHAR: 'CHAR_LIT'
            STRING: 'STRING_LIT'
        })

    @STATEMENTS: Object.freeze({
            IF_THEN: 'IF-THEN'
            IF_THEN_ELSE: 'IF-THEN-ELSE'
            WHILE: 'WHILE'
            FOR: 'FOR'
            RETURN: 'RETURN'
            CIN: 'CIN'
            COUT: 'COUT'
            NOP: 'NOP'
        })

    @NODES: Object.freeze({
            BLOCK_FUNCTIONS: 'BLOCK-FUNCTIONS'
            BLOCK_INSTRUCTIONS: 'BLOCK-INSTRUCTIONS'
            ARG_LIST: 'ARG-LIST'
            ARG: 'ARG'
            ID: 'ID'
            DECLARATION: 'DECLARATION'
            FUNCALL: 'FUNCALL'
            PARAM_LIST: 'PARAM-LIST'
            ENDL: 'ENDL'
            TYPE_DECL: 'TYPE-DECL'
        })

    @CASTS: Object.freeze({
            INT2DOUBLE: 'INT2DOUBLE'
            INT2CHAR: 'INT2CHAR'
            INT2BOOL: 'INT2BOOL'

            DOUBLE2INT: 'DOUBLE2INT'
            DOUBLE2CHAR: 'DOUBLE2CHAR'
            DOUBLE2BOOL: 'DOUBLE2BOOL'

            CHAR2INT: 'CHAR2INT'
            CHAR2BOOL: 'CHAR2BOOL'
            CHAR2DOUBLE: 'CHAR2DOUBLE'

            BOOL2INT: 'BOOL2INT'
            BOOL2DOUBLE: 'BOOL2DOUBLE'
            BOOL2CHAR: 'BOOL2CHAR'

            INT2COUT: 'INT2COUT'
            BOOL2COUT: 'BOOL2COUT'
            CHAR2COUT: 'CHAR2COUT'
            DOUBLE2COUT: 'DOUBLE2COUT'

            CIN2BOOL: 'CIN2BOOL'
        })

    constructor: (@type, @children) ->
        assert (typeof @type is "string")
        assert Array.isArray(@children)

    @copyOf: (ast) ->
        new Ast(ast.type,
            for child in ast.children
                if child instanceof Ast then Ast.copyOf(child) else child 
        )

    getType: -> @type

    setType: (@type) ->

    addParent: (type) ->
        currentType = @type
        @type = type
        @children = [new Ast(currentType, @children)]

    # These are to simplify and beautify some code
    child: -> @children[0]
    left: -> @children[0]
    right: -> @children[1]

    getChild: (i) -> @children[i]

    getChildren: -> @children

    addChild: (child) -> @children.push child

    setChild: (i, value) -> @children[i] = value

    getChildCount: -> @children.length
