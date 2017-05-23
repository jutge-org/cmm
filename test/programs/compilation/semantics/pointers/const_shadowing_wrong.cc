/*

    description{Tests that shadowing const pointers inside non-const pointers is not allowed}
    compilation-error{20}
  
*/

int main() {
      int * * * * y;
      int const (* const (* const (* (* const  x)))) = y;
}