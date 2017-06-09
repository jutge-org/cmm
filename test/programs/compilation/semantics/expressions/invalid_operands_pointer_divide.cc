/*

    description{Checks that performing divisions with arrays is not allowed}
    compilation-error{8001}

*/

int main() {
    int* p;

    p = p/3;
}