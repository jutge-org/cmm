/*
    description{Tests while loop functionality}
*/

#include <iostream>
using namespace std;

int main() {
    int i = 0;
    int n; cin >> n;
    int sum = 0;

    while (i < n) {
       ++i;
       sum += i;
    }

    cout << sum << endl;
}