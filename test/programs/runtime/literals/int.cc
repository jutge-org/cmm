/*
description{Tests int literal parsing}
*/

#include <iostream>
using namespace std;

void print(int n) { cout << n << endl; }

int main() {
    print(2147483647);
    print(2147483648);
    print(0);
    print(23);
    print(425);
    print(7826);
    print(44594);
    print(283904);
    print(2476268);
    print(42767728);
    print(242782299);
}