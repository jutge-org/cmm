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
%left UMINUS

%start prog

%% /* language grammar */


prog
    : stmt EOF
        { return $1; } /* to print the tree: typeof console !== 'undefined' ? console.log($1) : print($1); */
    ;

stmt
    : statement line ';'
        {$$ = new yy.AstNode('STMT-LINE', [$1, $2]);}
    | statement block_if
        {$$ = new yy.AstNode('STMT-BLCK', [$1, $2]);}
    | statement block_while
        {$$ = new yy.AstNode('STMT-BLCK', [$1, $2]);}
    |
        {$$ = new yy.AstNode('no-op');}
    ;

line
    : assign
    ;

assign
    : declaration 'EQUAL' expr
        {$$ = new yy.AstNode(':=', [$1, $2, $4]);}
    ;

declaration
    : type 'ID'
        {$$ = new yy.AstNode('DECL', [$1, $2]);}
    ;

type
    : 'INT'
        {$$ = new yy.AstNode('INT', [$1]);}
    | 'DOUBLE'
        {$$ = new yy.AstNode('DOUBLE', [$1]);}
    | 'CHAR'
        {$$ = new yy.AstNode('CHAR', [$1]);}
    | 'STR'
        {$$ = new yy.AstNode('STR', [$1]);}
    ;

expr
    : expr 'PLUS' expr
        {$$ = new yy.AstNode('PLUS', [$1, $3]);}
    | expr 'MINUS' expr
        {$$ = new yy.AstNode('MINUS', [$1, $3]);}
    | expr 'MUL' expr
        {$$ = new yy.AstNode('MUL', [$1, $3]);}
    | expr 'DIV' expr
        {$$ = new yy.AstNode('DIV', [$1, $3]);}
    ;