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
    ID : 'ID',
    checkType: function (data) {
        var type = data.type;
        var value = data.value;
        switch(type) {
            case 'int':
                // Check if it's a real or int, 
                if (value == parseInt(data.value) || value == parseFloat(data.value)) {
                    data.value = parseInt(data.value);
                } else throw "Wrong type - Expected:" + type + " Actual:" + typeof value;
                break;
            case 'double':
                if (value !== parseInt(data.value) && value !== parseFloat(data.value))
                    throw "Wrong type";
                break;
            case 'void':
                if (value !== undefined)
                    throw "Void type has no value";
        }
    }
};
