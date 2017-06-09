/*

    description{Checks that pointer assignments work correctly}
    
*/

#include <iostream>
using namespace std;

int main() {
    int (*x)[3][4] = new int[2][3][4];

    int c = 0;

    for (int i = 0; i < 2; ++i)
        for (int j = 0; j < 3; ++j)
            for (int k = 0; k < 4; ++k)
                *(*(*(x + i) + j) + k) = c++;


    for (int i = 0; i < 2; ++i)
        for (int j = 0; j < 3; ++j)
            for (int k = 0; k < 4; ++k)
                cout << *(*(*(x + i) + j) + k) << endl;
}