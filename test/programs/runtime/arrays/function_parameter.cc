/*
    description{Checks arrays as function parameters}
*/

#include <iostream>
using namespace std;

int f(int x[13][25]) {
    cout << x << endl;
    return 0;
}

int main() {
    int a[5][13][25];
    f(a[2]);
}
