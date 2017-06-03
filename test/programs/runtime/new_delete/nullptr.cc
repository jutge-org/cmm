/*

    description{Checks that deleting a null pointer gives no error}
    
*/

#include <iostream>
using namespace std;

int main() {
    int* x = nullptr;

    delete x;
}