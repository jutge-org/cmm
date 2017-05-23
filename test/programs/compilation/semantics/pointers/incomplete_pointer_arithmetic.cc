/*

    description{Checks that pointer arithmetic is not allowed on incomplete types}
    compilation-error{93}
  
*/

int main() {
    int (*x)[];

    ++x;
}