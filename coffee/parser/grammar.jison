/* description: Parses and executes mathematical expressions. */

/* lexical grammar */
%lex
%%

"//".*                /* ignore comment */
"/*"(.|\n|\r)*?"*/"   /* ignore multiline comment */
\s+                   /* skip whitespace */
"+="                                        return '+='
"-="                                        return '-='
"*="                                        return '*='
"/="                                        return '/='
"%="                                        return '%='
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
"string"                                    return 'STRING'
"void"                                      return 'VOID'
"cin"                                       return 'CIN'
"cout"                                      return 'COUT'
"if"                                        return 'IF'
"else"                                      return 'ELSE'
"while"                                     return 'WHILE'
"for"                                       return 'FOR'
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
    | funcall ';'
    | return_stmt ';'
    | ';'
        {$$ = new yy.Ast('NOP', []);}
    ;

basic_stmt
    : block_assign
    | declaration
    | cin
    | cout
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
    : IF '(' expr ')' instruction_body else
        {$$ = new yy.Ast('IF-THEN-ELSE', [$3, $5, $6]);}
    | IF '(' expr ')' instruction_body
        {$$ = new yy.Ast('IF-THEN', [$3, $5]);}
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

cin
    : CIN block_cin
        {$$ = $2;}
    ;

block_cin
    : block_cin '>>' expr
        {$$.addChild($3);}
    | '>>' expr
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
        {$$.addChild($3);}
    | '<<' expr
        {$$ = new yy.Ast('COUT', [$2]);}
    | '<<' ENDL
        {$$ = new yy.Ast('COUT', [$2]);}
    ;

instruction_body
    : instruction
        {$$ = new yy.Ast('BLOCK-INSTRUCTIONS', [$1]);}
    | '{' block_instr '}'
        {$$ = $2;}
    ;

block_assign
    : block_assign ',' assign
        {$$.addChild($3);}
    | assign
        {$$ = new yy.Ast('BLOCK-ASSIGN', [$1]);}
    ;

assign
    : declaration_assign
    | id '+=' expr
        {$$ = new yy.Ast('ASSIGN', [$1, new yy.Ast('PLUS', [$1,$3])]);}
    | id '-=' expr
        {$$ = new yy.Ast('ASSIGN', [$1, new yy.Ast('MINUS', [$1,$3])]);}
    | id '*=' expr
        {$$ = new yy.Ast('ASSIGN', [$1, new yy.Ast('MUL', [$1,$3])]);}
    | id '/=' expr
        {$$ = new yy.Ast('ASSIGN', [$1, new yy.Ast('DIV', [$1,$3])]);}
    | id '%=' expr
        {$$ = new yy.Ast('ASSIGN', [$1, new yy.Ast('MOD', [$1,$3])]);}
    ;

declaration_assign
    : id 'EQUAL' expr
        {$$ = new yy.Ast('ASSIGN', [$1, $3]);}
    ;

declaration
    : type declaration_body
        {$$ = new yy.Ast('DECLARATION', [$1, $2]);}
    ;

declaration_body
    : declaration_body ',' declaration_assign
        {$$.push($3);}
    | declaration_body ',' id
        {$$.push($3);}
    | declaration_assign
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
    : expr PLUS expr
        {$$ = new yy.Ast('PLUS', [$1,$3]);}
    | expr MINUS expr
        {$$ = new yy.Ast('MINUS', [$1,$3]);}
    | expr MUL expr
        {$$ = new yy.Ast('MUL', [$1,$3]);}
    | expr DIV expr
        {$$ = new yy.Ast('DIV', [$1,$3]);}
    | expr MOD expr
        {$$ = new yy.Ast('MOD', [$1,$3]);}
    | MINUS expr %prec UNARY
        {$$ = new yy.Ast('UMINUS', [$2]);}
    | PLUS expr %prec UNARY
        {$$ = new yy.Ast('UPLUS', [$2]);}
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
    | id
    | funcall
    | '(' expr ')'
        {$$ = $2}
    ;

id
    : ID
        {$$ = new yy.Ast('ID', [$1]);}
    ;
