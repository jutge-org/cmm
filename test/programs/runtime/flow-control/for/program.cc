/*
    description{Tests for loop functionality}
*/

#include <iostream>
using namespace std;


int main() {
    int a, n;
    cin >> a >> n;
    for (int i = a, c = 1; i < n; i += c) {
        cout << i << ' ' << c << endl;
    }

    int i = 0;
    for (; i < n; ++i) cout << i << endl;

    i = 0;
    bool b; cin >> b;
    if (b) {
        for (;; ++i) {
            cout << i << endl;
            if (i == n) return 0;
        }
    }
    else {
        i = 0;
        for (;;) {
            cout << i << endl;
            if (i == n) return 0;
            ++i;
        }
    }
}