/*

    description{Checks that modifying a function argument declared const is not allowed}
    compilation-error{5004}
  
*/

int f(const int x) {
    x = 3;
}

int main() {
    f(2);
}