/*

    description{Checks that an error is thrown when there is not enough space to allocate an object}
    status{141}

*/

#include <iostream>
using namespace std;

int main() {
    new int[20000000][500];
}