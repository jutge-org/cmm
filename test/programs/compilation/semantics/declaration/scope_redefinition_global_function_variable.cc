/*

    description{Checks that redefinition of a variable as a function is not allowed}
    compilation-error{2001}
  
*/

int x;

int x() {
}

int main() {

}