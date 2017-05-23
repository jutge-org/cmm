/*
    description{Checks arrays as function parameters}
*/

int f(int x[13][25]) {
    cout << x << endl;
    return 0;
}

int main() {
    int a[5][13][25];
    f(a[2]);
}
