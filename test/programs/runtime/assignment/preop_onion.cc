/*

    description{Checks that using multiple stacked preops gives correct result}
    
*/

#include <iostream>
using namespace std;

int main() {
    int x = 0;
    ++(++(++x));
    cout << x << endl; // Should be 3
}