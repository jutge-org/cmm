/*

    description{Checks that using cin on rvalue expressions is not allowed}
    compilation-error{7001}
  
*/

#include <iostream>
using namespace std;

int main() {
    int a;


    cin >> a + 2;
}