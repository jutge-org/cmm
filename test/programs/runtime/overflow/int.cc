/*

description{Tests int overflow}

*/

#include <iostream>
using namespace std;

int main() {
    int u = 2147483647;
    int l = -2147483648;

    cout << l - 1 << endl; // 2147483647
    cout << l - 2 << endl; // 2147483646

    cout << --l << endl; // 2147483647
    cout << --l << endl; // 2147483646


    cout << u + 1 << endl; // -2147483648
    cout << u + 2 << endl; // -2147483647

    cout << ++u << endl; // -2147483648
    cout << ++u << endl; // -2147483647
}