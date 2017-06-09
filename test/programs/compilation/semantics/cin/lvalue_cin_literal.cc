/*

    description{Checks that using cin on literals is not allowed}
    compilation-error{7001}
  
*/

#include <iostream>
using namespace std;

int main() {
    cin >> 2;
}