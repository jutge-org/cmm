/*

    description{Checks that assigning to an array which is a result of a multidimensional array access is not allowed}
    compilation-error{5003}

*/

int arr[20][30];

int arr2[20][30];

int main() {
    arr[0] = arr2[0];
}