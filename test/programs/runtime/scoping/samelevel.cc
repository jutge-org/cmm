/*

description{Tests that there are no problems when defining variables in the same
            scope level (but different scopes) with the same name}

*/
#include <iostream>
using namespace std;

int f() {
    int x = 2;
    cout << x << endl;
}

int main() {
    f();

    int x = 3;
    cout << x << endl;

    if (true) {
        int y = 5;
        cout << y << endl;
    }

    {
        int y = 25;
        cout << y << endl;
    }


    if (true) {
        int y = 7;
        cout << y << endl;
    }
}