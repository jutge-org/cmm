/*
description{Tests if-then-else functionality}
*/

#include <iostream>
using namespace std;

bool f(bool x) { return x; }

int main() {
    if (f(1)) {
        cout << "then1" << endl;
    }
    else {
        cout << "else1" << endl;
    }

    if (f(0)) {
        cout << "then2" << endl;
    }
    else {
        cout << "else2" << endl;
    }
}