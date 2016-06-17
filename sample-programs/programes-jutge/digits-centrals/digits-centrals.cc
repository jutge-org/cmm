#include <iostream>
using namespace std;

// PRE: n natural.
// POST: Nombre de digits de n.
int ndigits(int x) {
	int i = 1;
	while (x > 9) {
		x /= 10;
		++i;
	}
	return i;
}

// PRE: n natural, ndigits(n)%2 != 0.
// POST: Digit central de n.
int dig_central(int x) {
	int j = ndigits(x)/2;
	while (j > 0) {
		x /= 10;
		--j;
	}
	return x%10;
}

// PRE: n > 0 natural i sequencia de 2*n naturals X.
// POST: 'B' si ndigits(Xi)%2 == 0 o dig_central(Xi) !=
//       dig_central( X(i-1) ) per i parell.
//       'A' si ndigits(Xj)%2 == 0 o dig_central(Xj) !=
//       dig_central( X(j-1) ) per j senar.
//       '=' si ndigits(Xu)%2 != 0 i dig_central(Xu) ==
//		 dig_central( X(u-1) ) per qualsevol u.
int main() {
	int n, x;
	cin >> n >> x;
	if (ndigits(x)%2 == 0) cout << 'B' << endl;
	else {
		int a = dig_central(x);
		bool trobat = false;
		int i = 1;
		while (not trobat and i < 2*n) {
			cin >> x;
			if ( (ndigits(x)%2 == 0) or (dig_central(x) != a) ) trobat = true;
			else ++i;
		}
		if (not trobat) cout << '=' << endl;
		else if (i%2 == 0) cout << 'B' << endl;
		else cout << 'A' << endl;
	}
}
