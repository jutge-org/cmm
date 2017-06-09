/*
    description{Checks lazy-evaluation with side effects on different contexts}
*/

#include <iostream>
using namespace std;

int global = -5;

int f() {
    return 5;
}

int main() {
    int a = 3;
    bool b = true;

    while ((b or (a = 2)) and global) {
        cout << a << endl; // 3
        b = false;
        global = 0;
    }

    int x = 0 and ((global = 3) or (a = -3));

    cout << global << ' ' << a << endl; // 0 2

    for (int i = 0, c = 2; c--; 0 and ++i) {
        cout << i << endl; // 0, 0
    }

    cout << global << endl; // 0
    cout << a << endl; // 2

    if (1 or ((global = 5) and (a = 5))) {
        cout << global << ' ' << a << endl; // 0 2
    }
}