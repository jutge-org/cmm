/*

    description{Checks that assigning to an array is not allowed}
    compilation-error{5003}
  
*/

int arr[20][30];

int arr2[20][30];

int main() {
    arr = arr2;
}