/*

    description{Checks that using new on an uninitialized const type gives a compilation error}
    compilation-error{12001}
  
*/

int main() {
    const int * x = new const int; // Error! new const int is a const type and it's not initialized
}