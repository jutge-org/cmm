/*
    description{Checks that the compiler outputs an error when the static stack size limit is exceeded}
    compilation-error{13002}
*/

int main() {
    int a[500][500][500];
}