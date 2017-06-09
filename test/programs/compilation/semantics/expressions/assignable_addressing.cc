/*

    description{Checks that using an invalid type operand to the unary & operator does not compile}
    compilation-error{9003}
  
*/



int main() {
    int* x = &main;
}