/*
    description{Checks recursivity}
*/

#include <iostream>
using namespace std;

void rec(int x, int y) {
    cout << x << ' ' << y << endl;
    if (x > 0) {
        if (y == 0) rec(x - 1, y);
        else rec(x, y - 1);
    }
}

int main() {
    int x, y;
    while (cin >> x >> y) rec(x, y);
}