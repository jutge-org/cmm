/*

    description{Checks that using the dereference operator on an operand which is not a pointer or array does not compile}
    compilation-error{9004}
  
*/

int main() {
    int x;

    int y = *x;
}