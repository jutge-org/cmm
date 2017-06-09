/*

    description{Checks that calling a function with less parameters is not allowed}
    compilation-error{4003}
  
*/

int f(int x, int y) {
}

int main() {
    f();
}