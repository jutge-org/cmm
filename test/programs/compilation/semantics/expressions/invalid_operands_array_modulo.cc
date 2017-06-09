/*

    description{Checks that performing modulos with arrays is not allowed}
    compilation-error{8001}

*/

int main() {
    int p[2];

    p%3;
}