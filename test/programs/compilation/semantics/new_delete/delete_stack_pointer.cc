/*

    description{Checks that deleting a stack pointer with the same offset as a alloc'd heap pointer still throws an error}
    status{142}

*/

#include <iostream>
using namespace std;



int main() {
    char arr[272];
    char arr2[1];

    char* x = new char[200];

    delete arr2;
}