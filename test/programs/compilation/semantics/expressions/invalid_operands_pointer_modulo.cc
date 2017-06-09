/*

    description{Checks that performing modulos with pointers is not allowed}
    compilation-error{8001}

*/

int main() {
    int* p;

    p%3;
}