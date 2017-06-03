/*

    description{Checks that using new with void types is not allowed}
    compilation-error{101}
  
*/

int main() {
    void* x = new void;
}