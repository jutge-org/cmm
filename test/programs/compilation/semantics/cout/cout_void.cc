/*

    description{Checks that couting a void value is not allowed}
    compilation-error{11001}

*/

void f() {
}

int main() {
    cout << f();
}