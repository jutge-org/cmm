assert = require 'assert'
asciitree = require 'ascii-tree'

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

    @DECLARATION_SPECIFIERS: Object.freeze({
            CONST: 'CONST'
            TYPE: 'TYPE'
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
            IDLHS: 'ID-LHS'
            DECLARATION: 'DECLARATION'
            FUNCALL: 'FUNCALL'
            PARAM_LIST: 'PARAM-LIST'
            ENDL: 'ENDL'
            TYPE_DECL: 'TYPE-DECL'
            CLOSE_SCOPE: 'CLOSE_SCOPE'
            FUNC_VALUE: 'FUNC_VALUE'
            CIN_VALUE: 'CIN_VALUE'
            END_FUNC_BLOCK: 'END_FUNC_BLOCK'
            DECLARATION_SPECIFIERS: 'DECLARATION_SPECIFIERS'
            DECLARATION_BODY: 'DECLARATION_BODY'
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

    constructor: (@type, @children, @leaf = no, flattenChildren = no) ->
        @instr = no
        @instrNumber = -1
        assert (typeof @type is "string")
        assert Array.isArray(@children)

        if flattenChildren
            newChildren = []
            for child in @children
                if Array.isArray(child)
                    newChildren.concat(child)
                else
                    newChildren.push(child)
            @children = newChildren

    @copyOf: (ast) ->
        new Ast(ast.type,
            for child in ast.children
                if child instanceof Ast then Ast.copyOf(child) else child
            ,
            ast.leaf
        )

    getType: -> @type

    isLeaf: -> @leaf

    setType: (@type) ->

    addParent: (type, leaf=no) ->
        currentType = @type
        @type = type
        isLeaf = @leaf
        @leaf = leaf
        @children = [new Ast(currentType, @children, isLeaf)]

    # These are to simplify and beautify some code
    child: -> @children[0]
    left: -> @children[0]
    right: -> @children[1]

    getChild: (i) -> @children[i]

    getChildren: -> @children

    setIsInstr: (@instr) ->

    setInstrNumber: (@instrNumber) ->

    setId: (@id) ->

    addChild: (child, instr=no, instrNumber=-1) ->
        if instr
            child.setIsInstr yes
            child.setInstrNumber instrNumber
        @children.push child

    setChild: (i, value) -> @children[i] = value

    clearChildren: () -> @children = []

    getChildCount: -> @children.length

    toObject:  ->
        parent = {}

        parent[@type] = []
        i = 0
        for child in @children
            if child instanceof Ast
                parent[@type][i] = child.toObject()
                ++i
            else if Array.isArray(child)
                for subChild in child
                    if subChild instanceof Ast
                        parent[@type][i] = subChild.toObject()
                    else
                        parent[@type][i] = subChild
                    ++i
            else
                parent[@type][i] = child
                ++i
        parent

    toString: ->
        _traverse = (list, node, level) ->
            ++level
            prefix = Array(level + 1).join("#")

            unless node?
                list.push prefix + node
            else if Array.isArray(node)
                for elem in node
                    _traverse(list, elem, level-1)
            else if typeof node is 'object'
                Object.keys(node).forEach (k) ->
                    list.push prefix + k
                    _traverse list, node[k], level
            else
                list.push prefix + node

        list = []
        _traverse list, @toObject(), 0
        asciitree.generate(list.join('\u000d\n'))
