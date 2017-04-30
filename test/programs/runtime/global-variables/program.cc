/*
    description{Tests functionality of global variables and top-level variable declarations}
*/

#include <iostream>
using namespace std;

int x = 2;

int f() {
    return x;
}

const int Y = 3;
double d = Y + 5 - f();

void print() {
    cout << x << ' ' << f() << ' ' << Y << ' ' << d << endl; // 2, 2, 3, 6
    d = 5.7;
    x = d;
}

int main() {
    print();
    cout << x << ' ' << d << endl; // 5, 5.7
}