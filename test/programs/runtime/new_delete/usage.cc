/*

    description{Tests new and delete basic functionality}
    
*/

#include <iostream>
using namespace std;

int a[10];

int main() {

    cout << a << endl; // INITIAL + 10*4

    int * x = new int;

    cout << x << endl; // INITIAL + 10*4

    delete x;

    x = new int;

    cout << x << endl; // INITIAL + 10*4

    int * y = new int;

    cout << y << endl; // INITIAL + 10*4 + 4

    int * z = new int[10]; // INITIAL + 10*4 + 4 + 10*4

    cout << z << endl;

    delete[] z;
    delete y;
    delete x;

    x = new int;

    cout << x << endl; // INITIAL + 10*4

    delete x;
}