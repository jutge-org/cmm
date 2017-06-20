/*

    description{Checks that accessing an out-of-bounds stack address for write on a negative value gives a SEGFAULT}
    status{11}
*/

#include <iostream>
using namespace std;

int main() {
    int arr[1];
    arr[-1] = 2;
}