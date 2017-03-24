{ Parser } = require 'jison'

# Since we're going to be wrapped in a function by Jison in any case, if our
# action immediately returns a value, we can optimize by removing the function
# wrapper and just returning the value directly.
unwrap = /^function\s*\(\)\s*\{\s*return\s*([\s\S]*);\s*\}/

o = (patternString, action, options) ->
    # Remove extra spaces
    patternString = patternString.replace /\s{2,}/g, ' '

    return [patternString, '$$ = $1;', options] unless action

    action = if match = unwrap.exec action then match[1] else "(#{action}())"

    # All runtime functions we need are defined on "yy"
    action = action.replace /\bnew /g, '$&yy.'
    action = action.replace /\b(?:Ast.copyOf)\b/g, 'yy.$&'

    [patternString, (if action.indexOf('$$') >= 0 then action else "$$ = #{action};"), options]


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
    r /\{/,                                      '{'
    r /\}/,                                      '}'
    r /\(/,                                      '('
    r /\)/,                                      ')'
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

    r /true\b/,                                  'BOOL_LIT'
    r /false\b/,                                 'BOOL_LIT'
    r /[0-9]+(\.[0-9]+)\b/,                      'DOUBLE_LIT'
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
            o 'block_includes block_functions EOF',                               -> new Ast 'PROGRAM', [$1, $2]
        ]

        block_includes: [
            o 'block_includes include',                                           -> $$.addChild($2)
            o '',                                                                 -> new Ast 'BLOCK-INCLUDES', []
        ]

        include: [
            o '# INCLUDE < id >',                                                 -> new Ast 'INCLUDE', [$4]
            o 'USING NAMESPACE STD ;',                                            -> new Ast 'NAMESPACE', [$4]
        ]

        block_functions: [
            o 'block_functions function',                                         -> $$.addChild($2)
            o '',                                                                 -> new Ast 'BLOCK-FUNCTIONS', []
        ]

        function: [
            o 'type id ( arg_list ) { block_instr }',                             -> new Ast 'FUNCTION',[$1,$2,$4,$7]
        ]

        arg_list: [
            o 'arg_list , arg',                                                   -> $$.addChild($3)
            o 'arg',                                                              -> new Ast 'ARG-LIST', [$1]
            o '',                                                                 -> new Ast 'ARG-LIST', []
        ]

        arg: [
            o 'type id',                                                          -> new Ast 'ARG', [$1, $2]
        ]

        block_instr: [
            o 'block_instr instruction',                                          -> $$.addChild($2)
            o '',                                                                 -> new Ast 'BLOCK-INSTRUCTIONS', []
        ]

        instruction: [
            o 'basic_stmt ;'
            o 'if'
            o 'while'
            o 'for'
            o 'return_stmt ;'
            o ';',                                                                -> new Ast 'NOP', []
        ]

        basic_stmt: [
            o 'block_assign'
            o 'declaration'
            o 'cout'
            o 'expr'
        ]

        return_stmt: [
            o 'RETURN expr',                                                      -> new Ast 'RETURN', [$2]
            o 'RETURN',                                                           -> new Ast 'RETURN', []
        ]

        funcall: [
            o 'id ( param_list )',                                                -> new Ast 'FUNCALL', [$1,$3]
        ]

        param_list: [
            o 'param_list , param',                                               -> $$.addChild($3)
            o 'param',                                                            -> new Ast 'PARAM-LIST', [$1]
            o '',                                                                 -> new Ast 'PARAM-LIST', []
        ]

        param: [
            o 'expr',                                                             -> $1
        ]

        if: [
            o 'IF ( expr ) instruction_body',                                     (-> new Ast 'IF-THEN', [$3, $5]), prec: "THEN"
            o 'IF ( expr ) instruction_body else',                                -> new Ast 'IF-THEN-ELSE', [$3, $5, $6]
        ]

        while: [
            o 'WHILE ( expr ) instruction_body',                                  -> new Ast 'WHILE', [$3, $5]
        ]

        for: [
            o 'FOR ( basic_stmt ; expr ; basic_stmt ) instruction_body',          -> new Ast 'FOR', [$3, $5, $7, $9]
        ]

        else: [
            o 'ELSE instruction_body',                                            -> $2
        ]

        cin: [
            o 'CIN block_cin',                                                    -> $2
        ]

        block_cin: [
            o 'block_cin >> id',                                                  -> $$.addChild($3)
            o '>> id',                                                            -> new Ast 'CIN', [$2]
        ]

        cout: [
            o 'COUT block_cout',                                                  -> $2
        ]

        block_cout: [
            o 'block_cout << expr',                                               -> $$.addChild($3)
            o 'block_cout << ENDL',                                               -> $$.addChild(new Ast 'ENDL', [])
            o '<< expr',                                                          -> new Ast 'COUT', [$2]
            o '<< ENDL',                                                          -> new Ast 'COUT', [new Ast('ENDL', [])]
        ]

        instruction_body: [
            o 'instruction',                                                      -> new Ast 'BLOCK-INSTRUCTIONS', [$1]
            o '{ block_instr }',                                                  -> $2
        ]

        direct_assign: [
            o 'id = expr',                                                        -> new Ast '=', [$1, $3]
        ]

        declaration: [
            o 'type declaration_body',                                            -> new Ast 'DECLARATION', [$1, $2]
        ]

        declaration_body: [
            o 'declaration_body , direct_assign',                                 -> $$.push($3)
            o 'declaration_body , id',                                            -> $$.push($3)
            o 'direct_assign',                                                    -> [$1]
            o 'id',                                                               -> [$1]
        ]

        type: [
            o 'INT',                                                              ->  'INT'
            o 'DOUBLE',                                                           ->  'DOUBLE'
            o 'CHAR',                                                             ->  'CHAR'
            o 'BOOL',                                                             ->  'BOOL'
            o 'STRING',                                                           ->  'STRING'
            o 'VOID',                                                             ->  'VOID'
        ]

        expr: [
            o 'expr + expr',                                                      -> new Ast '+', [$1,$3]
            o 'expr - expr',                                                      -> new Ast '-', [$1,$3]
            o 'expr * expr',                                                      -> new Ast '*', [$1,$3]
            o 'expr / expr',                                                      -> new Ast '/', [$1,$3]
            o 'expr % expr',                                                      -> new Ast '%', [$1,$3]
            o 'expr && expr',                                                     -> new Ast '&&', [$1,$3]
            o 'expr || expr',                                                     -> new Ast '||', [$1,$3]
            o '- expr',                                                          (-> new Ast 'u-', [$2]), prec: "u-"
            o '+ expr',                                                          (-> new Ast 'u+', [$2]), prec: "u+"
            o '! expr',                                                           -> new Ast '!', [$2]
            o 'expr < expr',                                                      -> new Ast '<', [$1,$3]
            o 'expr > expr',                                                      -> new Ast '>', [$1,$3]
            o 'expr <= expr',                                                     -> new Ast '<=', [$1,$3]
            o 'expr >= expr',                                                     -> new Ast '>=', [$1,$3]
            o 'expr == expr',                                                     -> new Ast '==', [$1,$3]
            o 'expr != expr',                                                     -> new Ast '!=', [$1,$3]
            o 'DOUBLE_LIT',                                                       -> new Ast 'DOUBLE_LIT', [$1]
            o 'INT_LIT',                                                          -> new Ast 'INT_LIT', [$1]
            o 'CHAR_LIT',                                                         -> new Ast 'CHAR_LIT', [$1]
            o 'BOOL_LIT',                                                         -> new Ast 'BOOL_LIT', [$1]
            o 'STRING_LIT',                                                       -> new Ast 'STRING_LIT', [$1]
            o 'direct_assign'
            o '++ id',                                                           (-> new Ast '=', [$2, new Ast('+', [Ast.copyOf($2), new Ast('INT_LIT', ['1'])])]), prec: "++a"
            o '-- id',                                                           (-> new Ast '=', [$2, new Ast('-', [Ast.copyOf($2), new Ast('INT_LIT', ['1'])])]), prec: "--a"
            o 'id ++',                                                           (-> new Ast 'a++', [$1]), prec: "a++"
            o 'id --',                                                           (-> new Ast 'a--', [$1]), prec: "a--"
            o 'id += expr',                                                       -> new Ast '=', [$1, new Ast('+', [Ast.copyOf($1),$3])]
            o 'id -= expr',                                                       -> new Ast '=', [$1, new Ast('-', [Ast.copyOf($1),$3])]
            o 'id *= expr',                                                       -> new Ast '=', [$1, new Ast('*', [Ast.copyOf($1),$3])]
            o 'id /= expr',                                                       -> new Ast '=', [$1, new Ast('/', [Ast.copyOf($1),$3])]
            o 'id %= expr',                                                       -> new Ast '=', [$1, new Ast('%', [Ast.copyOf($1),$3])]
            o 'id'
            o 'cin'
            o 'funcall'
            o '( expr )',                                                         -> $2
        ]

        id: [
            o 'ID',                                                               -> new Ast 'ID', [$1]
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