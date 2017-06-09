/*

    description{Checks that the postdecrement operation over boolean variables is not allowed}
    compilation-error{8004}

*/

int main() {
    bool b;
    b--;
}