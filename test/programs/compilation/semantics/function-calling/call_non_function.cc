/*

    description{Checks that calling a variable which is not a function does not compile}
    compilation-error{4002}
  
*/

int x() {
}

int main() {
    int x;

    x();
}