/*

    description{Checks that variable redefinition within the function root scope is not allowed}
    compilation-error{2001}
  
*/

int main() {
    int x, x;
}