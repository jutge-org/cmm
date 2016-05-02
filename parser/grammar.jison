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
"+="                                        return '+='
"-="                                        return '-='
"*="                                        return '*='
"/="                                        return '/='
"%="                                        return '%='
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

%right '+=' '-=' '*=' '/=' '%='
%left '==' '!='
%left '<' '>' '<=' '>='
%left 'PLUS' 'MINUS'
%left 'MUL' 'DIV' 'MOD'
%left UNARY

%start prog

%% /* language grammar */

prog
    : block_functions EOF
        { return $1; } /* to print the tree: typeof console !== 'undefined' ? console.log($1) : print($1); */
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
        {$$ = new yy.AstNode('INSTR', [$1, $2]);}
    |
        {$$ = new yy.AstNode('no-instr');}
    ;

instruction
    : block_assign
    | declaration
    | block_if
    | block_while
    ;

block_assign
    : block_assign ',' assign
        {$$ = new yy.AstNode('BLOCK-ASSIG', [$1, $3]);}
    | assign
    ;

assign
    : ID 'EQUAL' expr
        {$$ = new yy.AstNode(':=', [$1, $3]);}
    ;

declaration
    : type declaration_body
        {$$ = new yy.AstNode('TYPE-DECL', [$1, $2]);}
    ;

declaration_body
    : declaration_body ',' assign
        {$$ = new yy.AstNode('DECL', [$1, $2]);}
    | declaration_body ',' ID
        {$$ = new yy.AstNode('DECL', [$1, $2]);}
    | assign
    | ID
        {$$ = new yy.AstNode('ID', [$1]);}
    ;

type
    : INT
    | DOUBLE
    | CHAR
    | STR
    ;

expr
    : expr PLUS expr
        {$$ = new yy.AstNode('PLUS', [$1,$3]);}
    | expr MINUS expr
        {$$ = new yy.AstNode('MINUS', [$1,$3]);}
    | expr MUL expr
        {$$ = new yy.AstNode('MUL', [$1,$3]);}
    | expr DIV expr
        {$$ = new yy.AstNode('DIV', [$1,$3]);}
    | expr MOD expr
        {$$ = new yy.AstNode('MOD', [$1,$3]);}
    | '(' expr ')'
    | MINUS expr %prec UNARY
    | PLUS expr %prec UNARY
    | expr '<' expr
    | expr '>' expr
    | expr '<=' expr
    | expr '>=' expr
    | expr '==' expr
    | expr '!=' expr
    | expr '+=' expr
    | expr '-=' expr
    | expr '*=' expr
    | expr '/=' expr
    | expr '%=' expr
    | NUMBER
        {$$ = new yy.AstNode('NUMBER', [$1]);}
    | ID
        {$$ = new yy.AstNode('ID', [$1]);}
    ;