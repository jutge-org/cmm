/*

    description{Checks that pointers are not allowed as arguments to unary minus}
    compilation-error{8002}
  
*/

int main() {
    int * p;
    -p;
}