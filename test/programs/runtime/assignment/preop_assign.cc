/*

    description{Checks that assigning to a pre/post op is allowed and gives correct results}
    
*/

#include <iostream>
using namespace std;

int main() {
    int a = 2;

    ++a += a;

    cout << a << endl; // 6, ++a is executed first

    --a += a;

    cout << a << endl; // 10, --a is executed first
}