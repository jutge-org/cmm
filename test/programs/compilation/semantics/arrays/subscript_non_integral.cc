/*

    description{Checks that using a subscript value which is not of integral type does not compile}
    compilation-error{6001}
  
*/

int main() {
    int arr[20];

    int x;

    x = arr[2.6];
}