/*

    description{Checks that reading a variable which is not defined gives an error}
    compilation-error{3001}
  
*/

int main() {
    {
        int x;
    }

    int y = x;
}