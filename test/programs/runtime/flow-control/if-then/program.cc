/*
description{Tests if-then functionality}
*/

#include <iostream>
using namespace std;

bool f(bool x) { return x; }

int main() {
    if (f(1)) {
        cout << "yes" << endl;
    }

    if (f(0)) {
        cout << "no" << endl;
    }
}