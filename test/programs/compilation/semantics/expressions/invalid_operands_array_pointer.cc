/*

    description{Checks that performing binary operations with array and pointer arguments is not allowed}
    compilation-error{8001}

*/

int main() {
    int arr[20];
    int * p;

    arr + p;
}