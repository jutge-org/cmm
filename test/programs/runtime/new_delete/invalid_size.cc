/*

    description{Checks that giving a negative size to the array length throws an error}
    status{140}
    
*/

#include <iostream>
using namespace std;

int main() {
    int n = -1;
    new int[n];
}