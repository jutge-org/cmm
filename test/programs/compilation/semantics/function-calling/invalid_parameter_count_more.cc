/*

    description{Checks that calling a function with more parameters is not allowed}
    compilation-error{4003}
  
*/


int f(int x, int y) {
}

int main() {
    int x;

    f(x, x, x);
}