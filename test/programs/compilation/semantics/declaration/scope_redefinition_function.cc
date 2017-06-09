/*

    description{Checks that redefining a function is not allowed}
    compilation-error{2001}
  
*/

int f() {
}


char f() {

}

int main() {

}