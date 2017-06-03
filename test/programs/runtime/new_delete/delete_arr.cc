/*

    description{Checks that deleting on an array is allowed by the compiler but gives execution error}
    status{142}

*/

#include <iostream>
using namespace std;

char arr[200];

int main() {
    delete[] arr;
}