/*

    description{Checks that declaring a function parameter as a pointer to an array of unbound size is not allowed}
    compilation-error{2011}
  
*/

int f(char (*arr)[]) { // Error! parameter arr is declared as a pointer to an array with unknown size (first dimension unknown)

}

int main() {

}