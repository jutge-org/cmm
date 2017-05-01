/*
    description{Tests double literal parsing}
*/

#include <iostream>
using namespace std;

void print(double c) {
    cout << c << endl;
}

int main() {
    print(.5);
    print(0.34246238);
    print(55223.23728);
    print(.005);
    print(00.244402);
    print(1.2242);
}