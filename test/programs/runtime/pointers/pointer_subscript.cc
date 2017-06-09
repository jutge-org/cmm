/*

    description{Checks that subscripts can be used with pointers}
    
*/

#include <iostream>
using namespace std;

int main() {
    int * x = new int[20];

    for (int i = 0; i < 20; ++i)
        x[i] = i;

    for (int i = 0; i < 20; ++i)
        cout << x[i] << endl;
}