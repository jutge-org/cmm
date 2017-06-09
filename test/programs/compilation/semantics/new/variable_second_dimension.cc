/*

    description{Checks that new only accepts variable-sized arrays with only the first dimension being dynamic}
    compilation-error{12002}
  
*/

int main() {
    int n;
    new int[20][n];
}