/*

description{Test that temporaries are properly scoped and not get overwritten on function calls}

*/

#include <iostream>
using namespace std;

int rec(int x) {
    if (x <= 0) return 1;
    int r = ((2 % 3)*(rec(x/100) < x))*((1/1) + (6+rec(x/100)) + ((5*3) - (1*rec(x - 1))));
    cout << x << ' ' << r << endl;
    return r;
}

int f(int x) {
    // This generates a deep expression tree, which requires some temporaries to not be
    // overwritten by posterior temporary computations. Also, these temporaries have to be saved
    // on function calls to avoid being overwritten.
    return ((5.8 + 3)/(2*3)) - ((5+2)*(3.5/3)) * ((5.8 + 3)/(2*3)) - ((5+2)*(rec(x)/3.5));
}


int main() {
    int x;
    while (cin >> x) cout << f(x) << endl;
}