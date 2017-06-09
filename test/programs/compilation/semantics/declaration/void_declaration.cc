/*

    description{Checks that declaring variables with type void is not allowed}
    compilation-error{2005}
  
*/

int main() {
    void x;
}