{ Parser } = require 'jison'

# Since we're going to be wrapped in a function by Jison in any case, if our
# action immediately returns a value, we can optimize by removing the function
# wrapper and just returning the value directly.
unwrap = /^function\s*\(\)\s*\{\s*return\s*([\s\S]*);\s*\}/

addLocationData = (first, last) ->
    (obj) ->
        if obj isnt null and typeof obj is "object"
            obj.locations =
                lines:
                    first: first.first_line
                    last: last.last_line
                columns:
                    first: first.first_column
                    last: last.last_column

        obj


o = (patternString, action, options) ->
    # Remove extra spaces
    patternString = patternString.replace /\s{2,}/g, ' '

    return [patternString, '$$ = $1;', options] unless action

    patternCount = patternString.split(' ').length

    action = if match = unwrap.exec action then match[1] else "(#{action}())"

    # All runtime functions we need are defined on "yy"
    action = action.replace /\bnew /g, '$&yy.'
    action = action.replace /\b(?:Ast.copyOf)\b/g, 'yy.$&'
    # Also objects
    action = action.replace /\b(?:TYPES)/g, 'yy.$&'

    [patternString, (if action.indexOf('$$') >= 0 then action else "$$ = #{addLocationData}(@1, @#{patternCount})(#{action});"), options]


r = (pattern, value) -> [pattern.toString()[1...-1], if value.match(/\/\*.+\*\//)? then value else "return '#{value}'"]


# Lexical rules
# -------------

# The format for each lexical token rule definition is "r <regEx> <tokenName>"
# where <regEx> is a Javascript regEx describing the set of strings
# that should match the token, and <tokenName> is the name of the token,
# which can be later referenced in the grammar.
#
# Note that in case <tokenName> is a comment (/* ... */) the strings
# that match the token will be discarded. This is useful to ignore comments
# or skip whitespace.
lexRules = [
    r /\/\/.*/,                                  "/* ignore comment */"
    r /\/\*(.|\n|\r)*?\*\//,                     "/* ignore multiline comment */"
    r /\s+/,                                     "/* skip whitespace */"

    r /\+\+/,                                    '++'
    r /--/,                                      '--'
    r /\+=/,                                     '+='
    r /-=/,                                      '-='
    r /\*=/,                                     '*='
    r /\/=/,                                     '/='
    r /%=/,                                      '%='

    r /\*/,                                      '*'
    r /\//,                                      '/'
    r /-/,                                       '-'
    r /%/,                                       '%'
    r /\+/,                                      '+'

    r /!=/,                                      '!=' # NOTE: Order matters, != is before ! to avoid matching !

    r /or\b/,                                    '||'
    r /and\b/,                                   '&&'
    r /not\b/,                                   '!'
    r /not_eq\b/,                                '!='

    r /<%/,                                      '{'
    r /%>/,                                      '}'
    r /<:/,                                      '['
    r /:>/,                                      ']'
    r /%:/,                                      '#'

    r /\|\|/,                                    '||'
    r /&&/,                                      '&&'
    r /!/,                                       '!'

    r /<</,                                      '<<'
    r />>/,                                      '>>'

    r />=/,                                      '>='
    r /<=/,                                      '<='
    r />/,                                       '>'
    r /</,                                       '<'
    r /==/,                                      '=='

    r /=/,                                       '='


    r /;/,                                       ';'
    r /{/,                                       '{'
    r /}/,                                       '}'
    r /\(/,                                      '('
    r /\)/,                                      ')'
    r /\[/,                                      '['
    r /]/,                                       ']'
    r /,/,                                       ','

    r /#/,                                       '#'

    r /return\b/,                                'RETURN'

    r /cin\b/,                                   'CIN'
    r /cout\b/,                                  'COUT'

    r /endl\b/,                                  'ENDL'

    r /int\b/,                                   'INT'
    r /double\b/,                                'DOUBLE'
    r /char\b/,                                  'CHAR'
    r /bool\b/,                                  'BOOL'
    r /string\b/,                                'STRING'
    r /void\b/,                                  'VOID'

    r /include\b/,                               'INCLUDE'
    r /using\b/,                                 'USING'
    r /namespace\b/,                             'NAMESPACE'
    r /std\b/,                                   'STD'

    r /if\b/,                                    'IF'
    r /else\b/,                                  'ELSE'
    r /while\b/,                                 'WHILE'
    r /for\b/,                                   'FOR'

    r /const\b/,                                 'CONST'

    r /true\b/,                                  'BOOL_LIT'
    r /false\b/,                                 'BOOL_LIT'
    r /[0-9]*(\.[0-9]+)\b/,                      'DOUBLE_LIT'
    r /([1-9][0-9]*|0)/,                         'INT_LIT'
    r /'([^\\\']|\\.)'/,                         'CHAR_LIT'
    r /"([^\\\"]|\\.)*"/,                        'STRING_LIT'

    r /([a-z]|[A-Z]|_)([a-z]|[A-Z]|_|[0-9])*/,   'ID'

    r /$/,                                       'EOF'

    r /./,                                       'INVALID'
]

# Precedence
# ----------

# Operators at the top of this list have higher precedence than the ones lower
operators = [
    [ 'right',   'THEN', 'ELSE' ],
    [ 'left',    'a++', 'a--' ],
    [ 'right',   '++a', '--a' ],
    [ 'right',   '!', 'u+', 'u-' ],
    [ 'left',    '*', '/', '%' ],
    [ 'left',    '+', '-' ],
    [ 'left',    '>>', '<<' ],
    [ 'left',    '<', '>', '<=', '>=' ],
    [ 'left',    '==', '!=' ],
    [ 'left',    '&&' ],
    [ 'left',    '||' ],
    [ 'right',   '+=', '-=', '*=', '/=', '%=', '=' ]
]

# Grammatical Rules
# -----------------

# In all of the rules that follow, you'll see the name of the nonterminal as
# the key to a list of alternative matches. With each match's action, the
# dollar-sign variables are provided by Jison as references to the value of
# their numeric position, so in this rule:
#
#     "Expression OR Expression"
#
# `$1` would be the value of the first `Expression`, `$2` would be the token
# for the `OR` terminal, and `$3` would be the value of the second
# `Expression`.
bnf =
    {
        prog: [
            o 'top_level_decl_seq EOF',                                           -> new ProgramAst $1
        ]

        top_level_decl_seq: [
            o 'top_level_decl_seq top_level_decl',                                -> $$.addChild $2
            o '',                                                                 -> new List
        ]

        top_level_decl: [
            o 'include',                                                          -> null # TODO: Implement properly
            o 'function'
            o 'declaration ;'
        ]

        include: [ # TODO: An include can be anywhere in the top scope, and it should be different from a using statement
            o '# INCLUDE < id >',                                                 ->
            o 'USING NAMESPACE STD ;',                                            ->
        ]

        function: [
            o 'declaration_specifier_seq id ( arg_list ) { block_instr }',        -> new Function $1,$2,$4,$7
        ]

        arg_list: [
            o 'arg_list , arg',                                                   -> $$.addChild $3
            o 'arg',                                                              -> new List $1
            o '',                                                                 -> new List
        ]

        arg: [
            o 'declaration_specifier_seq decl_var_reference',                     -> new FuncArg $1, $2
        ]

        block_instr: [
            o 'block_instr instruction',                                          -> $$.addChild $2
            o '',                                                                 -> new List
        ]

        instruction: [
            o 'basic_stmt ;'
            o 'if'
            o 'while'
            o 'for'
            o 'return_stmt ;'
            o ';',                                                                -> null
        ]

        basic_stmt: [
            o 'block_assign'
            o 'declaration'
            o 'cout'
            o 'expr'
        ]

        return_stmt: [
            o 'RETURN expr',                                                      -> new Return $2
            o 'RETURN',                                                           -> new Return
        ]

        funcall: [
            o 'id ( param_list )',                                                -> new Funcall $1,$3
            o 'id ( VOID )',                                                      -> new Funcall $1, new List
        ]

        param_list: [
            o 'param_list , param',                                               -> $$.push $3
            o 'param',                                                            -> [$1]
            o '',                                                                 -> []
        ]

        param: [
            o 'expr',                                                             -> $1
        ]

        if: [
            o 'IF ( expr ) instruction_body',                                     (-> new IfThen $3, $5), prec: "THEN"
            o 'IF ( expr ) instruction_body else',                                -> new IfThenElse $3, $5, $6
        ]

        while: [
            o 'WHILE ( expr ) instruction_body',                                  -> new While $3, $5
        ]

        optional_expr: [
            o 'expr'
            o '',                                                                 -> no
        ]

        optional_basic_stmt: [
            o 'basic_stmt'
            o '',                                                                 -> no
        ]

        for: [
            o 'FOR ( optional_basic_stmt ; optional_expr ; optional_expr ) instruction_body',          -> new For $3, $5, $7, $9
        ]

        else: [
            o 'ELSE instruction_body',                                            -> $2
        ]

        cin: [
            o 'CIN block_cin',                                                    -> $2
        ]

        block_cin: [
            o 'block_cin >> id',                                                  -> $$.addChild $3
            o '>> id',                                                            -> new Cin $2
        ]

        cout: [
            o 'COUT block_cout',                                                  -> $2
        ]

        block_cout: [
            o 'block_cout << expr',                                               -> $$.addChild $3
            o 'block_cout << ENDL',                                               -> $$.addChild(new StringLit '"\\n"')
            o '<< expr',                                                          -> new Cout $2
            o '<< ENDL',                                                          -> new Cout(new StringLit '"\\n"')
        ]

        instruction_body: [
            o 'instruction',                                                      -> new List $1
            o '{ block_instr }',                                                  -> $2
        ]

        decl_assign: [
            o 'decl_var_reference = decl_value',                                  -> new Assign $1, $3 # Note the first child should always be the id. See hack note on direct assign
        ]

        decl_value: [
            o 'expr'
            o 'initializer'
        ]

        initializer: [
            o 'array_initializer'
        ]

        declaration: [
            o 'declaration_specifier_seq declaration_body',                       -> new Declaration $1, $2
        ]
        
        declaration_specifier_seq: [
            o 'declaration_specifier_seq declaration_specifier',                  -> $$.push $2
            o 'declaration_specifier',                                            -> [$1]
        ]
        
        declaration_specifier: [
            o 'CONST'
            o 'type'
        ]

        declaration_body: [
            o 'declaration_body , decl_assign',                                   -> $$.push $3.child(), $3 # HACK: Assumes direct_assign's first child is the id
            o 'declaration_body , decl_var_reference',                            -> $$.push $3
            o 'decl_assign',                                                      -> [$1.child(), $1] # Basically avoids having to treat the assign case specially. A new declaration is made before the assign
            o 'decl_var_reference',                                               -> [$1]
        ]

        decl_var_reference: [
            o 'id'
            o 'id decl_accessor_list' # TODO
        ]

        var_reference: [
            o 'id'
            o 'id accessor_list' # TODO
        ]

        decl_accessor_list: [
            o 'decl_accessor decl_accessor_list' # TODO
            o 'decl_accessor'
        ]

        decl_accessor: [
            o '[ INT_LIT ]' # TODO
            o '[ ]' # TODO
        ]

        accessor_list: [
            o '[ expr ] accessor_list' # TODO
            o '[ expr ]'
        ]

        array_initializer: [
            o '{ value_list }',                                                   -> $2
        ]

        value_list: [
            o 'literal , value_list' # TODO
            o 'literal'
        ]


        type: [ # Maybe create this dinamically?
            o 'INT',                                                              -> TYPES[$1.toUpperCase()]
            o 'DOUBLE',                                                           -> TYPES[$1.toUpperCase()]
            o 'CHAR',                                                             -> TYPES[$1.toUpperCase()]
            o 'BOOL',                                                             -> TYPES[$1.toUpperCase()]
            o 'STRING',                                                           -> TYPES[$1.toUpperCase()]
            o 'VOID',                                                             -> TYPES[$1.toUpperCase()]
        ]

        literal: [
            o 'DOUBLE_LIT',                                                       -> new DoubleLit $1
            o 'INT_LIT',                                                          -> new IntLit $1
            o 'CHAR_LIT',                                                         -> new CharLit $1
            o 'BOOL_LIT',                                                         -> new BoolLit $1
            o 'STRING_LIT',                                                       -> new StringLit $1
        ]

        expr: [
            o 'expr + expr',                                                      -> new Add $1, $3
            o 'expr - expr',                                                      -> new Sub $1, $3
            o 'expr * expr',                                                      -> new Mul $1, $3
            o 'expr / expr',                                                      -> new Div $1, $3
            o 'expr % expr',                                                      -> new Mod $1, $3
            o 'expr && expr',                                                     -> new And $1, $3
            o 'expr || expr',                                                     -> new Or $1, $3
            o 'expr < expr',                                                      -> new Lt $1, $3
            o 'expr > expr',                                                      -> new Gt $1, $3
            o 'expr <= expr',                                                     -> new Lte $1, $3
            o 'expr >= expr',                                                     -> new Gte $1, $3
            o 'expr == expr',                                                     -> new Eq $1, $3
            o 'expr != expr',                                                     -> new Neq $1, $3
            o 'var_reference += expr',                                           -> new Assign $1, new Add(Ast.copyOf($1), $3) # HACK: Note this should be changed when implementing operator overload
            o 'var_reference -= expr',                                           -> new Assign $1, new Sub(Ast.copyOf($1), $3)
            o 'var_reference *= expr',                                           -> new Assign $1, new Mul(Ast.copyOf($1), $3)
            o 'var_reference /= expr',                                           -> new Assign $1, new Div(Ast.copyOf($1), $3)
            o 'var_reference %= expr',                                           -> new Assign $1, new Mod(Ast.copyOf($1), $3)
            o 'var_reference =  expr',                                           -> new Assign $1, $3
            o '- expr',                                                          (-> new Usub $2), prec: "u-"
            o '+ expr',                                                          (-> new Uadd $2), prec: "u+"
            o '! expr',                                                           -> new Not $2
            o '++ id',                                                           (-> new PreInc $2), prec: "++a"
            o '-- id',                                                           (-> new PreDec $2), prec: "--a"
            o 'id ++',                                                           (-> new PostInc $1), prec: "a++"
            o 'id --',                                                           (-> new PostDec $1), prec: "a--"
            o 'literal'
            o 'var_reference'
            o 'cin'
            o 'funcall'
            o '( expr )',                                                         -> $2
        ]

        id: [
            o 'ID',                                                               -> new Id $1
        ]
    }

start = "prog"

bnf[start][0][1] = "return #{bnf[start][0][1]}"

exports.parser = new Parser {
    lex: {rules: lexRules}
    operators: operators.reverse()
    start
    bnf
}