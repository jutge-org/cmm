/*

    description{Checks that performing multiplications with arrays is not allowed}
    compilation-error{8001}

*/

int main() {
    int p[20];

    p*3;
}