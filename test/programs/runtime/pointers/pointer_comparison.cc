/*

    description{Checks that comparing pointers works as expected}
  
*/

int main() {
    int x;
    int y;

    int *p = &x;
    const int *p2 = &y;

    cout << (p == p) << endl
         << (p == p2) << endl
         << (p2 > p) << endl;
}