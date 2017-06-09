/*

    description{Checks that trying to assign a value with void type resulting from a function call is not allowed}
    compilation-error{9001}

*/

void f() {

}

int main() {
    int a;

    a = f();
}