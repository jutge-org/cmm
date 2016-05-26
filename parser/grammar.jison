/* description: Parses and executes mathematical expressions. */

/* lexical grammar */
%lex
%%

"//".*                /* ignore comment */
"/*"(.|\n|\r)*?"*/"   /* ignore multiline comment */
\s+                   /* skip whitespace */
"*"                                         return 'MUL'
"/"                                         return 'DIV'
"-"                                         return 'MINUS'
"%"                                         return 'MOD'
"+"                                         return 'PLUS'
"<<"                                        return '<<'
">>"                                        return '>>'
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
"return"                                    return 'RETURN'
"cin"                                       return 'CIN'
"cout"                                      return 'COUT'
"endl"                                      return 'ENDL'
"int"                                       return 'INT'
"double"                                    return 'DOUBLE'
"char"                                      return 'CHAR'
"bool"                                      return 'BOOL'
"string"                                    return 'STR'
"void"                                      return 'VOID'
"cin"                                       return 'CIN'
"cout"                                      return 'COUT'
"if"                                        return 'IF'
"else"                                      return 'ELSE'
"while"                                     return 'WHILE'
"true"|"false"                              return 'BOOL_LIT'
[0-9]+("."[0-9]+)\b                         return 'DOUBLE_LIT'
([1-9][0-9]*|0)                             return 'INT_LIT'
\'(\\.|[^'])\'                              return 'CHAR_LIT'
\"(\\.|[^"])*\"                             return 'STRING_LIT'
([a-z]|[A-Z]|_)([a-z]|[A-Z]|_|[0-9])*       return 'ID'
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
    : type id '(' arg_list ')' '{' block_instr '}'
        {$$ = new yy.AstNode('FUNCTION',[$1,$2,$4,$7]);}
    ;

arg_list
    : arg_list ',' arg
        {$$.addChild($3);}
    | arg
        {$$ = new yy.AstNode('ARG-LIST', [$1]);}
    |
        {$$ = new yy.AstNode('ARG-LIST', []);}
    ;

arg
    : type id
        {$$ = new yy.AstNode('ARG', [$1, $2]);}
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
    | cin ';'
    | cout ';'
    | funcall ';'
    | return_stmt ';'
    ;

return_stmt
    : RETURN expr
        {$$ = new yy.AstNode('RETURN', [$2]);}
    ;

funcall
    : id '(' param_list ')'
        {$$ = new yy.AstNode('FUNCALL', [$1,$3]);}
    ;

param_list
    : param_list ',' param
        {$$.addChild($3);}
    | param
        {$$ = new yy.AstNode('PARAM-LIST', [$1]);}
    |
        {$$ = new yy.AstNode('PARAM-LIST', []);}
    ;

param
    : expr
        {$$ = new yy.AstNode('PARAM', [$1]);}
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

cin
    : CIN block_cin
        {$$ = new yy.AstNode('CIN', [$2]);}
    ;

block_cin
    : block_cin '>>' expr
        {$$.addChild($3);}
    | '>>' expr
        {$$ = new yy.AstNode('BLOCK-CIN', [$2]);}
    ;

cout
    : COUT block_cout
        {$$ = new yy.AstNode('COUT', [$2]);}
    ;

block_cout
    : block_cout '<<' expr
        {$$.addChild($3);}
    | block_cout '<<' ENDL
        {$$.addChild($3);}
    | '<<' expr
        {$$ = new yy.AstNode('BLOCK-COUT', [$2]);}
    | '<<' ENDL
        {$$ = new yy.AstNode('BLOCK-COUT', [$2]);}
    ;

instruction_body
    : instruction
        {$$ = new yy.AstNode('BLOCK-INSTRUCTIONS', [$1]);}
    | '{' block_instr '}'
        {$$ = $2;}
    ;

block_assign
    : block_assign ',' assign
        {$$.addChild($3);}
    | assign
        {$$ = new yy.AstNode('BLOCK-ASSIGN', [$1]);}
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
    | BOOL
    | STR
    | VOID
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
    | MINUS expr %prec UNARY
        {$$ = new yy.AstNode('UMINUS', [$2]);}
    | PLUS expr %prec UNARY
        {$$ = new yy.AstNode('UPLUS', [$2]);}
    | expr '<' expr
        {$$ = new yy.AstNode('<', [$1,$3]);}
    | expr '>' expr
        {$$ = new yy.AstNode('>', [$1,$3]);}
    | expr '<=' expr
        {$$ = new yy.AstNode('<=', [$1,$3]);}
    | expr '>=' expr
        {$$ = new yy.AstNode('>=', [$1,$3]);}
    | expr '==' expr
        {$$ = new yy.AstNode('==', [$1,$3]);}
    | expr '!=' expr
        {$$ = new yy.AstNode('!=', [$1,$3]);}
    | expr '+=' expr
        {$$ = new yy.AstNode('+=', [$1,$3]);}
    | expr '-=' expr
        {$$ = new yy.AstNode('-=', [$1,$3]);}
    | expr '*=' expr
        {$$ = new yy.AstNode('*=', [$1,$3]);}
    | expr '/=' expr
        {$$ = new yy.AstNode('/=', [$1,$3]);}
    | expr '%=' expr
        {$$ = new yy.AstNode('%=', [$1,$3]);}
    | DOUBLE_LIT
        {$$ = new yy.AstNode('DOUBLE_LIT', [$1]);}
    | INT_LIT
        {$$ = new yy.AstNode('INT_LIT', [$1]);}
    | CHAR_LIT
        {$$ = new yy.AstNode('CHAR_LIT', [$1])}
    | BOOL_LIT
        {$$ = new yy.AstNode('BOOL_LIT', [$1]);}
    | STRING_LIT
        {$$ = new yy.AstNode('STRING_LIT', [$1]);}
    | id
    | funcall
    | '(' expr ')'
    ;

id
    : ID
        {$$ = new yy.AstNode('ID', [$1]);}
    ;
