/*

    description{Checks that accessing an out-of-bounds stack address for read gives SEGFAULT}
    status{11}
*/

#include <iostream>
using namespace std;

int main() {
    int arr[1];
    int x = arr[-1];
}