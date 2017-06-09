/*

    description{Checks that comparing two pointers with different types does not compile}
    compilation-error{9008}
  
*/

int main() {
    int* x;

    double* y;

    bool b = x == y; // Error! x and y have different pointer types
}