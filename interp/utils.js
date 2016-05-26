module.exports = {
    TYPE : Object.freeze({
        VOID: 'VOID',
        INT: 'INT',
        DOUBLE: 'DOUBLE',
        STRING: 'STRING',
        CHAR: 'CHAR',
        BOOL: 'BOOL'
    }),
    OPERATOR : Object.freeze({
        PLUS: 'PLUS',
        MINUS: 'MINUS',
        MUL: 'MUL',
        DIV: 'DIV',
        MOD: 'MOD',
        LT: '<',
        GT: '>',
        LTE: '<=',
        GTE: '>=',
        EQ: '==',
        NEQ: '!='
    }),
    LITERAL : Object.freeze({
        INT: 'INT_LIT',
        DOUBLE: 'DOUBLE_LIT',
        BOOL: 'BOOL_LIT',
        CHAR: 'CHAR_LIT',
        STRING: 'STRING_LIT'
    }),
    ID : 'ID'
};
