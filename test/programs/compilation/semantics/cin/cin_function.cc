/*

    description{Checks that using cin on functions is not allowed}
    compilation-error{7002}
  
*/

#include <iostream>
using namespace std;

int main() {
    cin >> main;
}