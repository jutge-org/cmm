/*

    description{Checks that couting a nullptr is not allowed}
    compilation-error{11001}

*/

int main() {
    cout << nullptr;
}