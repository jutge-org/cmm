/*
    description{Tests multiple function recursivity}
*/

#include <iostream>
using namespace std;

double dec(double x, bool s) {
    int i = x;
    if (s) return i - (x - i + 0.1);
    else return i + (x - i + 0.1);
}

double b(double c, double d) {
    cout << c << ' ' << d << endl;
    if (d - c < 0.1) return d - c;
    return b(c + 0.01, d - 0.01);
}

double e(double c, double d) {
    cout << c << ' ' << d << endl;
    if (d - c < 1.0) return b(c, d);
    return e(dec(c, false) , dec(d, true));
}

double a(double c, double d) {
    cout << c << ' ' << d << endl;
    if (d - c < 5.0) return e(c, d);
    else return a(c + 0.5, d - 0.5);
}

int main() {
    double x, y;
    while (cin >> x >> y) cout << a(x, y) << endl;
}