/*

    description{Checks that modifying a const pointer is not allowed}
    compilation-error{5004}
  
*/

int main() {
    int * const x;

    int * y;

    x = y;
}