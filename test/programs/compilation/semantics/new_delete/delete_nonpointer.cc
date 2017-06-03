/*

    description{Checks that delete only accepts pointer types}
    compilation-error{104}
  
*/

int main() {
    int x;

    delete x;
}