/*

    description{Checks that trying to use new on a void type is not allowed}
    compilation-error{9005}
  
*/

int main() {
    void* x = new void; // Wrong! void is not allowed here
}