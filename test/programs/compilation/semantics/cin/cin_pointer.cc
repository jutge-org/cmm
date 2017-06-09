/*

    description{Checks that using cin on pointers is not allowed}
    compilation-error{7002}

*/

#include <iostream>
using namespace std;

int main() {
    int* p;
    cin >> p;
}