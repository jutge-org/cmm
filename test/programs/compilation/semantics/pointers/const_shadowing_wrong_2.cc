/*

    description{Tests that shadowing const pointers inside non-const pointers is not allowed}
    compilation-error{9002}

*/

int main() {
      int * const * * * y;
      int (*  (* const (* const (* const  x)))) = y;
}