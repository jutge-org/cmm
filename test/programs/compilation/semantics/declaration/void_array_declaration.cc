/*

    description{Checks that declaring an array of void values is not allowed}
    compilation-error{2006}
  
*/

int main() {
    void x[20];
}