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
            ARG_LIST: 'ARG-LIST'
            ARG: 'ARG'
            ID: 'ID'
            DECLARATION: 'DECLARATION'
            FUNCALL: 'FUNCALL'
            DECL_ASSIGN: 'DECL-ASSIGN'
            ASSIGN: 'ASSIGN'
            PARAM_LIST: 'PARAM-LIST'
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

            BOOL2INT: 'BOOLTOINT'
            BOOL2DOUBLE: 'BOOLTODOUBLE'
            BOOL2CHAR: 'BOOLTOCHAR'
        })

    constructor: (@type, @children) ->
        assert (typeof @type is "string")
        assert Array.isArray(@children)

    getType: -> @type

    setType: (@type) ->

    cast: (casting) ->
        currentType = @type
        currentChildren = @children

        @type = casting
        @children = [new Ast(currentType, currentChildren)]


    getChild: (i) -> @children[i]

    getChildren: -> @children

    addChild: (child) -> @children.push child

    setChild: (i, value) -> @children[i] = value

    getChildCount: -> @children.length
