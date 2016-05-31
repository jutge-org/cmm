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
        })

    @OPERATORS: Object.freeze({
            PLUS: 'PLUS'
            MINUS: 'MINUS'
            UPLUS: 'UPLUS'
            UMINUS: 'UMINUS'
            MUL: 'MUL'
            DIV: 'DIV'
            DOUBLE_DIV: 'DOUBLE_DIV'
            INT_DIV: 'INT_DIV'
            MOD: 'MOD'
            OR: 'OR'
            AND: 'AND'
            NOT: 'NOT'
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
        })

    @NODES: Object.freeze({
            BLOCK_FUNCTIONS: 'BLOCK-FUNCTIONS'
            BLOCK_INSTRUCTIONS: 'BLOCK-INSTRUCTIONS'
            BLOCK_ASSIGN: 'BLOCK-ASSIGN'
            ARG_LIST: 'ARG-LIST'
            ARG: 'ARG'
            ID: 'ID'
            DECLARATION: 'DECLARATION'
            FUNCALL: 'FUNCALL'
            DECL_ASSIGN: 'DECL-ASSIGN'
            ASSIGN: 'ASSIGN'
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
        })

    constructor: (@type, @children) ->
        assert (typeof @type is "string")
        assert Array.isArray(@children)

    getType: -> @type

    setType: (@type) ->

    # TODO: This shouldn't be here
    cast: (casting) ->
        currentType = @type
        currentChildren = @children

        @type = casting
        @children = [new Ast(currentType, currentChildren)]

    # These are to simplify and beautify some code
    child: -> @children[0]
    left: -> @children[0]
    right: -> @children[1]

    getChild: (i) -> @children[i]

    getChildren: -> @children

    addChild: (child) -> @children.push child

    setChild: (i, value) -> @children[i] = value

    getChildCount: -> @children.length
