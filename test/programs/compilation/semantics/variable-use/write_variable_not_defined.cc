/*

    description{Checks that writing on a variable which is not defined gives a compilation error}
    compilation-error{3001}
  
*/

int main() {
    {
        int x;
    }

    x = 2;
}