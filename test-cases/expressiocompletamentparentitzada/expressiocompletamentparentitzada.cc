#include <iostream>
using namespace std;

int parent() {
    int res;
    char c;
    cin >> c;
    if (c >= '0' and c <= '9') res = c - '0';
    else {
        int n = parent();
        cin >> c;
        while (c == ')') cin >> c;
        if (c == '+') res = n + parent();
        else if (c == '-') res = n - parent();
        else if (c == '*') res = n * parent();
    }
    return res;
}

int main() {
    cout << parent() << endl;
}
