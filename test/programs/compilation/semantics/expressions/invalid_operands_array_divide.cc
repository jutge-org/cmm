/*

    description{Checks that performing divisions with pointers is not allowed}
    compilation-error{8001}

*/

int main() {
    int* p;

    p = p/3;
}