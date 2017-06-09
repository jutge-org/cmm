/*

    description{Checks that performing binary operations with two pointer arguments is not allowed}
    compilation-error{8001}
  
*/

int main() {
    int* p;

    p += p;
}