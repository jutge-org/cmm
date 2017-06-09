/*

    description{Checks that modifying a const array is not allowed}
    compilation-error{5004}
  
*/

int main() {
    const int arr[5][5];

    *(*(arr + 2) + 3) = 5;
}