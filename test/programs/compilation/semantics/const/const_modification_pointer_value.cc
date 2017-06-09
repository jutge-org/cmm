/*

    description{Checks that modifying the const value pointed by a pointer is not allowed}
    compilation-error{5004}
  
*/

int main() {
    const int * x;

    *x = 2;
}