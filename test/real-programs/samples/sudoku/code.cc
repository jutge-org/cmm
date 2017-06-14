#include <iostream>

using namespace std;

int const SIZE = 9;
const int SUBSIZE = SIZE/3;

int S[9][9];

bool MR[9][9], MC[9][9], MQ[9][9], SET[9][9];

bool found;

int quad(const int i, const int j) {
    return (i/SUBSIZE)*SUBSIZE + j/SUBSIZE;
}

bool canPutNum(int num, int i, int j) {
    return not MC[j][num-1] and not MQ[quad(i, j)][num-1]
           and not MR[i][num-1];
}

void putNum(int num, int i, int j) {
    S[i][j] = num;
    MR[i][num-1] = MC[j][num-1] = MQ[quad(i, j)][num-1] = true;
}

void removeNum(int num, int i, int j) {
    MR[i][num-1] = MC[j][num-1] = MQ[quad(i, j)][num-1] = false;
}

void backtrack(int i, int j) {
    if (not found) {
        if (i < SIZE) {
            if (not SET[i][j]) {
                for (int num = 1; num <= SIZE; ++num) {
                    if (canPutNum(num, i, j)) {
                        putNum(num, i, j);
                        if (j + 1 == SIZE) backtrack(i + 1, 0);
                        else backtrack(i, j + 1);
                        if (not found) removeNum(num, i, j);
            }	}	}
            else {
                if (j + 1 == SIZE) backtrack(i + 1, 0);
                else backtrack(i, j + 1);
        }	}
        else found = true;
}	}

void initialize() {
    found = false;

    for (int i = 0; i < SIZE; ++i)
        for (int j = 0; j < SIZE; ++j)
            *(*(MR + i) + j) = (*(MC + i))[j] = MQ[i][j] = SET[i][j] = false;
}

void read() {
    for (int i = 0; i < SIZE; ++i) {
        for (int j = 0; j < SIZE; ++j) {
            char c; cin >> c;
            if (c != '.') {
                putNum(c - '0', i, j);
                SET[i][j] = true;
}	}	}	}

void print() {
    cout << endl;
    for (int i = 0; i < SIZE; ++i) {
        cout << S[i][0];
        for (int j = 1; j < SIZE; ++j) cout << ' ' << S[i][j];
        cout << endl;
}	}

void solve() {
    backtrack(0, 0);
}

int main() {
    int n; cin >> n; cout << n << endl;
    for (int i = 0; i < n; ++i) {
        initialize();
        read();
        solve();
        print();
}	}