/*

description{Tests char overflow}

*/

#include <iostream>
using namespace std;

int main() {
    char u = 127;
    char l = -128;

    cout << --l << endl; // 127
    cout << --l << endl; // 126

    cout << ++u << endl; // -128
    cout << ++u << endl; // -127
}