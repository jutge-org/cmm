/*
    description{Checks that the compiler outputs an error when the static stack size limit is exceeded}
    compilation-error{302}
*/

int main() {
    int a[500][500][500];
}