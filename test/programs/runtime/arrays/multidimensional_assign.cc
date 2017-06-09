/*
    description{Checks multidimensional array assign}
*/

#include <iostream>
using namespace std;

int main() {
    int a[5][13][25];

    double c = 0;
    for (int i = 0; i < 5; ++i)
        for (int j = 0; j < 13; ++j)
            for (int z = 0; z < 25; ++z) a[i][j][z] = c++;

    c = 0;
    for (int i = 0; i < 5; ++i)
        for (int j = 0; j < 13; ++j)
            for (int z = 0; z < 25; ++z) cout << a[i][j][z] << ' ' << c++ << endl;
}
