/*

    description{Checks that modulo operations with non-integrals are not allowed}
    compilation-error{8003}
  
*/

int main() {
    int x;
    double y;

    x%y;
}