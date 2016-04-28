/* description: Parses and executes mathematical expressions. */

/* lexical grammar */
%lex
%%

\s+                   /* skip whitespace */
"*"                                         return 'MUL'
"/"                                         return 'DIV'
"-"                                         return 'MINUS'
"%"                                         return 'MOD'
"+"                                         return 'PLUS'
">"                                         return '>'
"<"                                         return '<'
">="                                        return '>='
"<="                                        return '<='
"!="                                        return '!='
"=="                                        return '=='
"="                                         return 'EQUAL'
";"                                         return ';'
"{"                                         return '{'
"}"                                         return '}'
"("                                         return '('
")"                                         return ')'
","                                         return ','
"int"                                       return 'INT'
"double"                                    return 'DOUBLE'
"char"                                      return 'CHAR'
"string"                                    return 'STR'
"cout"                                      return 'COUT'
"true"                                      return 'TRUE'
"false"                                     return 'FALSE'
"if"                                        return 'IF'
"else"                                      return 'ELSE'
"while"                                     return 'WHILE'
[0-9]+("."[0-9]+)?\b                        return 'NUMBER'
([a-z]|[A-Z]|_)([a-z]|[A-Z]|_|[0-9])*       return 'ID'
\"(\\.|[^"])*\"                             return 'STRING'
<<EOF>>                                     return 'EOF'
.                                           return 'INVALID'

/lex

/* operator associations and precedence */

%left 'PLUS' 'MINUS'
%left 'MUL' 'DIV'
%left UNARY

%start prog

%% /* language grammar */

prog
    : block_functions EOF
        // { return $1; } /* to print the tree: typeof console !== 'undefined' ? console.log($1) : print($1); */
    ;

block_functions
    : block_functions function
    | 
    ;

function
    : type ID '(' ')' '{' block_instr '}'
    ;

block_instr
    : block_instr instruction ';'
    | 
    ;

instruction
    : block_assign
    | declaration
    | block_if
    | block_while
    ;

block_assign
    : block_assign ',' assign
    | assign
    ;

assign
    : ID 'EQUAL' expr
    ;

declaration
    : type declaration_body
    ;

 declaration_body 
    : declaration_body ',' assign
    | declaration_body ',' ID
    | assign
    | ID
    ;
type
    : INT
    | DOUBLE
    | CHAR
    | STR
    ;

expr
    : expr PLUS expr
    | expr MINUS expr
    | expr MUL expr
    | expr DIV expr
    | '(' expr ')'
    | MINUS expr %prec UNARY
    | PLUS expr %prec UNARY
    | NUMBER
    | ID
    ;