/*

    description{Checks that assigning to a literal is not allowed}
    compilation-error{5002}
  
*/

int main() {
    2 = 3;
}