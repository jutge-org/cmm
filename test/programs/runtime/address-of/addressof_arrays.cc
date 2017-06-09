/*

    description{Checks that taking the address of an array results in the same pointer value as the array itself}
    
*/

#include <iostream>
using namespace std;

int main() {
    int arr[20];

    cout << arr << endl
         << &arr << endl;
    
}