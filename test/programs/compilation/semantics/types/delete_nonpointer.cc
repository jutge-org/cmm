/*

    description{Checks that delete only accepts pointer types}
    compilation-error{9006}
  
*/

int main() {
    int x;

    delete x;
}