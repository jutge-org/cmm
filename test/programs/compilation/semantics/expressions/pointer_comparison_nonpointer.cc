/*

    description{Checks that comparing a pointer with a non-pointer gives a compilation error}
    compilation-error{8001}
  
*/

int main() {
    int* x;

    int y;

    bool b = x == y;
}