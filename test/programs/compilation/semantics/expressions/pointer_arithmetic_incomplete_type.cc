/*

    description{Checks that performing pointer arithmetic on a pointer to incomplete type is not allowed}
    compilation-error{8006}
  
*/

int main() {
    int (*arr)[];

    ++arr; // Error! arr is a pointer to an array with unknown first dimension
}