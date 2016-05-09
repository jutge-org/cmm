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
"cin"                                       return 'CIN'
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
        {$$.addChild($2);}
    |
        {$$ = new yy.AstNode('BLOCK-FUNCTIONS', []);}
    ;

function
    : type id '(' ')' '{' block_instr '}'
        {$$ = new yy.AstNode('FUNCTION',[$1,$2,$6]);}
    ;

block_instr
    : block_instr instruction 
        {$$.addChild($2);}
    |
        {$$ = new yy.AstNode('BLOCK-INSTRUCTIONS', []);}
    ;

instruction
    : block_assign ';'
        //TODO: fer push directament a la llista d'instruccions
    | declaration ';'
    | if
    | while
    ;

if
    : IF '(' expr ')' instruction_body else
        {$$ = new yy.AstNode('IF-THEN-ELSE', [$3, $5, $6]);}
    | IF '(' expr ')' instruction_body 
        {$$ = new yy.AstNode('IF-THEN', [$3, $5]);}
    ;

while
    : WHILE '(' expr ')' instruction_body
        {$$ = new yy.AstNode('WHILE', [$3, $5]);}
    ;

else
    : ELSE instruction_body
        {$$ = $2;}
    ;

instruction_body
    : instruction
        {$$ = new yy.AstNode('BLOCK-INSTRUCTIONS', [$1]);}
    | '{' block_instr '}'
        {$$ = $2;}
    ;

block_assign
    : block_assign ',' assign
        {$$ = new yy.AstNode('BLOCK-ASSIGN', [$1, $3]);}
    | assign
        {$$ = new yy.AstNode('BLOCK-ASSIGN', [new yy.AstNode('no-op'), $1]);}
    ;

assign
    : ID 'EQUAL' expr
        {$$ = new yy.AstNode('ASSIGN', [$1, $3]);}
    ;

declaration
    : type declaration_body
        {$$ = new yy.AstNode('TYPE-DECL', [$1, $2]);}
    ;

declaration_body
    : declaration_body ',' assign
        {$$.push($3);}
    | declaration_body ',' id
        {$$.push($3);}
    | assign
        {$$ = [$1];}
    | id
        {$$ = [$1];}
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
    | id
    ;

id
    : ID
        {$$ = new yy.AstNode('ID', [$1]);}
    ;
