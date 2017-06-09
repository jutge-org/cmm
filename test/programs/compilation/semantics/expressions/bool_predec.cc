/*

    description{Checks that the predecrement operation over boolean variables is not allowed}
    compilation-error{8004}
  
*/

int main() {
    bool b;
    --b;
}