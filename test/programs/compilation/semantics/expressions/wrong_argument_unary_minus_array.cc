/*

    description{Checks that arrays are not allowed as arguments to unary minus}
    compilation-error{8002}

*/

int main() {
    int p[2];
    -p;
}