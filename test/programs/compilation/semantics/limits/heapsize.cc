/*

    description{Checks that the compiler outputs an error when the total static heap size is exceeded}
    compilation-error{13003}
  
*/

int arr[500][500][500];

int main() {
}