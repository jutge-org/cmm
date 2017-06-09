/*

    description{Checks that calling a function which is not defined gives an error}
    compilation-error{4001}
  
*/

int main() {
    f();
}

void f() {
}