/*

    description{Checks that using the unary & operator on strings is not allowed}
    compilation-error{9007}
  
*/

int main() {
    string s;
    &s;
}