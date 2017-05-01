/*
    description{Checks function calls as parameters}
*/

#include <iostream>
using namespace std;


int sum(int i, int n) {
    cout << i << ' ' << n << endl;
    if (i >= n) return 0;
    return i + sum(i + 1 + sum(i + 2 + sum(i + 5, n), n), n);
}

int main() {
    int n;
    while (cin >> n) cout << sum(0, n) << endl;
}
