module.exports = this
var self = this;

this.TYPE =
    Object.freeze({
        VOID: 'VOID',
        INT: 'INT',
        DOUBLE: 'DOUBLE',
        STRING: 'STRING',
        CHAR: 'CHAR',
        BOOL: 'BOOL'
    });

this.OPERATOR =
    Object.freeze({
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
    });

this.LITERAL =
    Object.freeze({
        INT: 'INT_LIT',
        DOUBLE: 'DOUBLE_LIT',
        BOOL: 'BOOL_LIT',
        CHAR: 'CHAR_LIT',
        STRING: 'STRING_LIT'
    });

this.ID = 'ID';

this.maybeError = function(condition, message) {
    return condition ? null : message;
}

this.castType = function(data) {
    var type = data.type;
    
    switch(type) {
        case 'int': data.value = parseInt(data.value); break;
    }
}

this.checkType = function (data) {
        var type = data.type;
        var value = data.value;

        switch(type) {
            case 'int':
                return this.maybeError(
                    value == parseInt(data.value) ||
                    value == parseFloat(data.value),
                    "Wrong type - Expected:" + type + " Actual:" + typeof value
                )
            case 'double':
                return this.maybeError(
                    value == parseInt(data.value) ||
                    value == parseFloat(data.value),
                    "Wrong type - Expected:" + type + " Actual:" + typeof value
                )
            case 'void':
                return this.maybeError(
                    value === undefined,
                    "Void type has no value"
                )

        }
    };

this.ensureType = function(data) {
    var check = self.checkType(data);

    if (check != null) throw check;
    else self.castType(data);
}
