/*

    description{Checks that assigning between functions is not allowed}
    compilation-error{5001}
  
*/

int f() {
}

int f2() {
}

int main() {
    f = f2; // Error! functions are not assignable
}