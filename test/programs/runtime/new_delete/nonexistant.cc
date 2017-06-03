/*

    description{Checks that deleting a non-allocated pointer gives an error}
    status{142}
*/

#include <iostream>
using namespace std;

int main() {
    int* p = new int[20];

    cout << p << endl;

    delete[] p; // correct

    delete[] p; // crashes
}