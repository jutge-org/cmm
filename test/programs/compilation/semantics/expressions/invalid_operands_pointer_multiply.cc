/*

    description{Checks that performing multiplications with pointers is not allowed}
    compilation-error{8001}

*/

int main() {
    int* p;

    p = p*3;
}