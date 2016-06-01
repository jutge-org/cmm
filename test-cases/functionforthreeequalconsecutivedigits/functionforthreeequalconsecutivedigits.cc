#include <iostream>
using namespace std;

bool imm_three_equal_consecutive_digits(int n, int past, int consec,
                                        int b) {
    if (n < b) return n == past and consec == 2;
    else {
        int dig = n%b;
        if (consec == 2 and dig == past) return true;
        else if (dig == past) return imm_three_equal_consecutive_digits(n/b,
                                     dig, consec + 1, b);
        else return imm_three_equal_consecutive_digits(n/b, dig, 1, b);
    }
}

bool three_equal_consecutive_digits (int n, int b) {
    if (n < b) return false;
    else return imm_three_equal_consecutive_digits(n/b, n%b, 1, b);
}

int main() {
    int n, b;
    cin >> n >> b;

    if (three_equal_consecutive_digits(n, b)) cout << "It does!" << endl;
    else cout << "It doesn't!" << endl;
}
