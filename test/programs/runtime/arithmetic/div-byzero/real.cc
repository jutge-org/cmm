/*
    description(Should not throw floating point exception, also tests different inf/nan results)
*/

#include <iostream>
using namespace std;

int main() {
    double x;
    cin >> x;
    double y = 0;
    cout << x/y;
}