/*

    description{Checks that trying to assign a value with void type resulting from a pointer dereference is not allowed}
    compilation-error{9001}
  
*/

int main() {
    void* p;

    int a;

    a = *p;
}