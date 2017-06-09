/*

    description{Checks that redefinition of variables within a function inner scope is not allowed}
    compilation-error{2001}
  
*/

int main() {
    {
        int x;

        if (true) {}

        char x;
    }
}