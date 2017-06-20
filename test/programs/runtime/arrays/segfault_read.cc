/*

    description{Checks that accessing an array for read on a negative value gives a SEGFAULT}
    status{11}
*/

#include <iostream>
using namespace std;

int main() {
    int arr[1];
    int x = arr[-1];
}