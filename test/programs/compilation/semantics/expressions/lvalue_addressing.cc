/*

    description{Checks that a lvalue is required as operand of the unary '&' operator}
    compilation-error{8005}
  
*/

int f() {
    return 5;
}

int main() {
    int * x = & (f());
}