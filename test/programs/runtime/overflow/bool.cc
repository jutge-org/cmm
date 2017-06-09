/*

 description{Tests bool overflow}

*/

#include <iostream>
using namespace std;

int main() {
     bool b = 0;

     cout << ++b << endl; // 1
     cout << ++b << endl; // 1

     bool c = 1;

     b = b - c;
     cout << b << endl; // 1
     b = b - c;
     cout << b << endl; // 0
     b = b - c;
     cout << b << endl; // 1
     b = b - c;
     cout << b << endl; // 0
}