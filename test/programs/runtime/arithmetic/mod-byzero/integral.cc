/*
    description(Should throw floating point exception)
    status(137)
*/

#include <iostream>
using namespace std;

int main() {
    string type;
    cin >> type;

    if (type == "int") {
        int x; cin >> x;
        int y = 0;
        cout << x%y;
    }
    else if (type == "char") {
        char x; cin >> x;
        char y = 0;
        cout << x%y;
    }
    else if (type == "bool") {
        bool x; cin >> x;
        bool y = false;
        cout << x%y;
    }
}