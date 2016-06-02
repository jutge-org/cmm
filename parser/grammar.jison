/* description: Parses and executes mathematical expressions. */

/* lexical grammar */
%lex
%%

"//".*                /* ignore comment */
"/*"(.|\n|\r)*?"*/"   /* ignore multiline comment */
\s+                   /* skip whitespace */
"++"                                        return '++'
"--"                                        return '--'
"+="                                        return '+='
"-="                                        return '-='
"*="                                        return '*='
"/="                                        return '/='
"%="                                        return '%='

"*"                                         return '*'
"/"                                         return '/'
"-"                                         return '-'
"%"                                         return '%'
"+"                                         return '+'

"!="                                        return '!='

"or"|"||"                                   return '||'
"and"|"&&"                                  return '&&'
"not"|"!"                                   return '!'

"<<"                                        return '<<'
">>"                                        return '>>'

">="                                        return '>='
"<="                                        return '<='
">"                                         return '>'
"<"                                         return '<'
"=="                                        return '=='

"="                                         return '='

";"                                         return ';'
"{"                                         return '{'
"}"                                         return '}'
"("                                         return '('
")"                                         return ')'
","                                         return ','
"#"                                         return '#'

"return"                                    return 'RETURN'

"cin"                                       return 'CIN'
"cout"                                      return 'COUT'

"endl"                                      return 'ENDL'

"int"                                       return 'INT'
"double"                                    return 'DOUBLE'
"char"                                      return 'CHAR'
"bool"                                      return 'BOOL'
"string"                                    return 'STRING'
"void"                                      return 'VOID'

"include"                                   return 'INCLUDE'
'using'                                     return 'USING'
'namespace'                                 return 'NAMESPACE'
'std'                                       return 'STD'

"if"                                        return 'IF'
"else"                                      return 'ELSE'
"while"                                     return 'WHILE'
"for"                                       return 'FOR'

"true"|"false"                              return 'BOOL_LIT'
[0-9]+("."[0-9]+)\b                         return 'DOUBLE_LIT'
([1-9][0-9]*|0)                             return 'INT_LIT'
\'([^\\\']|\\.)\'                           return 'CHAR_LIT'
\"([^\\\"]|\\.)*\"                          return 'STRING_LIT'

([a-z]|[A-Z]|_)([a-z]|[A-Z]|_|[0-9])*       return 'ID'

<<EOF>>                                     return 'EOF'

.                                           return 'INVALID'

/lex

/* operator associations and precedence */
%right '+=' '-=' '*=' '/=' '%=' '='
%left '||'
%left '&&'
%left '==' '!='
%left '<' '>' '<=' '>='
%left '>>' '<<'
%left '+' '-'
%left '*' '/' '%'
%right '!' 'u+' 'u-'
%right '++a' '--a'
%left 'a++' 'a--'
%right THEN ELSE

%start prog

%% /* language grammar */

prog
    : block_includes block_functions EOF
        { return new yy.Ast('PROGRAM', [$1, $2]); }
    ;

block_includes
    : block_includes include
        {$$.addChild($2);}
    |
        {$$ = new yy.Ast('BLOCK-INCLUDES', []);}
    ;

include
    : '#' INCLUDE '<' id '>'
        {$$ = new yy.Ast('INCLUDE', [$4]);}
    | USING NAMESPACE STD ';'
        {$$ = new yy.Ast('NAMESPACE', [$4]);}
    ;

block_functions
    : block_functions function
        {$$.addChild($2);}
    |
        {$$ = new yy.Ast('BLOCK-FUNCTIONS', []);}
    ;

function
    : type id '(' arg_list ')' '{' block_instr '}'
        {$$ = new yy.Ast('FUNCTION',[$1,$2,$4,$7]);}
    ;

arg_list
    : arg_list ',' arg
        {$$.addChild($3);}
    | arg
        {$$ = new yy.Ast('ARG-LIST', [$1]);}
    |
        {$$ = new yy.Ast('ARG-LIST', []);}
    ;

arg
    : type id
        {$$ = new yy.Ast('ARG', [$1, $2]);}
    ;

block_instr
    : block_instr instruction
        {$$.addChild($2);}
    |
        {$$ = new yy.Ast('BLOCK-INSTRUCTIONS', []);}
    ;

instruction
    : basic_stmt ';'
    | if
    | while
    | for
    | return_stmt ';'
    | ';'
        {$$ = new yy.Ast('NOP', []);}
    ;

basic_stmt
    : block_assign
    | declaration
    | cout
    | expr
    ;

return_stmt
    : RETURN expr
        {$$ = new yy.Ast('RETURN', [$2]);}
    | RETURN
        {$$ = new yy.Ast('RETURN', [])}
    ;

funcall
    : id '(' param_list ')'
        {$$ = new yy.Ast('FUNCALL', [$1,$3]);}
    ;

param_list
    : param_list ',' param
        {$$.addChild($3);}
    | param
        {$$ = new yy.Ast('PARAM-LIST', [$1]);}
    |
        {$$ = new yy.Ast('PARAM-LIST', []);}
    ;

param
    : expr
        {$$ = $1;}
    ;

if
    : IF '(' expr ')' instruction_body %prec THEN
        {$$ = new yy.Ast('IF-THEN', [$3, $5]);}
    | IF '(' expr ')' instruction_body else
        {$$ = new yy.Ast('IF-THEN-ELSE', [$3, $5, $6]);}
    ;

while
    : WHILE '(' expr ')' instruction_body
        {$$ = new yy.Ast('WHILE', [$3, $5]);}
    ;

for
    : FOR '(' basic_stmt ';' expr ';' basic_stmt ')' instruction_body
        {$$ = new yy.Ast('FOR', [$3, $5, $7, $9])}
    ;

else
    : ELSE instruction_body
        {$$ = $2;}
    ;

// TODO: Treat cin and cout as simple predefined objects like true and false of type STREAM
// TODO: Then make << and >> operators
cin
    : CIN block_cin
        {$$ = $2;}
    ;

block_cin
    : block_cin '>>' id
        {$$.addChild($3);}
    | '>>' id
        {$$ = new yy.Ast('CIN', [$2]);}
    ;

cout
    : COUT block_cout
        {$$ = $2;}
    ;

block_cout
    : block_cout '<<' expr
        {$$.addChild($3);}
    | block_cout '<<' ENDL
        {$$.addChild(new yy.Ast('ENDL', []));}
    | '<<' expr
        {$$ = new yy.Ast('COUT', [$2]);}
    | '<<' ENDL
        {$$ = new yy.Ast('COUT', [new yy.Ast('ENDL', [])]);}
    ;

instruction_body
    : instruction
        {$$ = new yy.Ast('BLOCK-INSTRUCTIONS', [$1]);}
    | '{' block_instr '}'
        {$$ = $2;}
    ;

direct_assign
    : id '=' expr
        {$$ = new yy.Ast('=', [$1, $3]);}
    ;

declaration
    : type declaration_body
        {$$ = new yy.Ast('DECLARATION', [$1, $2]);}
    ;

declaration_body
    : declaration_body ',' direct_assign
        {$$.push($3);}
    | declaration_body ',' id
        {$$.push($3);}
    | direct_assign
        {$$ = [$1];}
    | id
        {$$ = [$1];}
    ;


type
    : INT
        { $$ = 'INT' }
    | DOUBLE
        { $$ = 'DOUBLE' }
    | CHAR
        { $$ = 'CHAR' }
    | BOOL
        { $$ = 'BOOL' }
    | STRING
        { $$ = 'STRING' }
    | VOID
        { $$ = 'VOID' }
    ;

expr
    : expr '+' expr
        {$$ = new yy.Ast('+', [$1,$3]);}
    | expr '-' expr
        {$$ = new yy.Ast('-', [$1,$3]);}
    | expr '*' expr
        {$$ = new yy.Ast('*', [$1,$3]);}
    | expr '/' expr
        {$$ = new yy.Ast('/', [$1,$3]);}
    | expr '%' expr
        {$$ = new yy.Ast('%', [$1,$3]);}
    | expr '&&' expr
        {$$ = new yy.Ast('&&', [$1,$3]);}
    | expr '||' expr
        {$$ = new yy.Ast('||', [$1,$3]);}
    | '-' expr %prec 'u-'
        {$$ = new yy.Ast('u-', [$2]);}
    | '+' expr %prec 'u+'
        {$$ = new yy.Ast('u+', [$2]);}
    | '!' expr
        {$$ = new yy.Ast('!', [$2]);}
    | expr '<' expr
        {$$ = new yy.Ast('<', [$1,$3]);}
    | expr '>' expr
        {$$ = new yy.Ast('>', [$1,$3]);}
    | expr '<=' expr
        {$$ = new yy.Ast('<=', [$1,$3]);}
    | expr '>=' expr
        {$$ = new yy.Ast('>=', [$1,$3]);}
    | expr '==' expr
        {$$ = new yy.Ast('==', [$1,$3]);}
    | expr '!=' expr
        {$$ = new yy.Ast('!=', [$1,$3]);}
    | DOUBLE_LIT
        {$$ = new yy.Ast('DOUBLE_LIT', [$1]);}
    | INT_LIT
        {$$ = new yy.Ast('INT_LIT', [$1]);}
    | CHAR_LIT
        {$$ = new yy.Ast('CHAR_LIT', [$1])}
    | BOOL_LIT
        {$$ = new yy.Ast('BOOL_LIT', [$1]);}
    | STRING_LIT
        {$$ = new yy.Ast('STRING_LIT', [$1]);}
    | direct_assign
    | '++' id %prec '++a'
        {$$ = new yy.Ast('=', [$2, new yy.Ast('+', [yy.Ast.copyOf($2), new yy.Ast('INT_LIT', ['1'])])]);} // TODO: Maybe this should be better done in the semantics/interpreter
    | '--' id %prec '--a'
        {$$ = new yy.Ast('=', [$2, new yy.Ast('-', [yy.Ast.copyOf($2), new yy.Ast('INT_LIT', ['1'])])]);}
    | id '++' %prec 'a++'
        {$$ = new yy.Ast('a++', [$1]);}
    | id '--' %prec 'a--'
        {$$ = new yy.Ast('a--', [$1]);}
    | id '+=' expr
        {$$ = new yy.Ast('=', [$1, new yy.Ast('+', [yy.Ast.copyOf($1),$3])]);}
    | id '-=' expr
        {$$ = new yy.Ast('=', [$1, new yy.Ast('-', [yy.Ast.copyOf($1),$3])]);}
    | id '*=' expr
        {$$ = new yy.Ast('=', [$1, new yy.Ast('*', [yy.Ast.copyOf($1),$3])]);}
    | id '/=' expr
        {$$ = new yy.Ast('=', [$1, new yy.Ast('/', [yy.Ast.copyOf($1),$3])]);}
    | id '%=' expr
        {$$ = new yy.Ast('=', [$1, new yy.Ast('%', [yy.Ast.copyOf($1),$3])]);}
    | id
    | cin
    | funcall
    | '(' expr ')'
        {$$ = $2}
    ;

id
    : ID
        {$$ = new yy.Ast('ID', [$1]);}
    ;
