/*

    description{Checks that using cin on arrays is not allowed}
    compilation-error{7002}

*/

#include <iostream>
using namespace std;

int main() {
    int arr[20];
    cin >> arr;
}