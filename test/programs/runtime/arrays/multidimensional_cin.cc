/*

    description{Tests cin with multidimensional arrays}
    
*/

#include <iostream>
using namespace std;

int main() {
    int x[5][5];

    for (int i = 0; i < 5; ++i)
        for (int j = 0; j < 5; ++j)
            cin >> x[i][j];

    for (int i = 0; i < 5; ++i) {
        for (int j = 0; j < 5; ++j) {
            cout << x[i][j];
            if (j < 4) cout << ' ';
        }
        cout << endl;
    }
}