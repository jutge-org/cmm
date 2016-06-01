#include <iostream>
#include <string>
using namespace std;

int main() {
	int n;
	bool trobat = false;
	int j = 1;
	while (not trobat and cin >> n) {
		bool ord = true;
		string prev, seg;
		for (int i = 0; i < n; ++i) {
			if (i == 0) cin >> prev;
			else {
				cin >> seg;
				if (seg < prev) ord = false;
			    prev = seg;
			}
		}
		if (ord) trobat = true;
		else ++j;
	}
	if (trobat) cout << "La primera linia ordenada creixentment es la " << j << '.' << endl;
	else cout << "No hi ha cap linia ordenada creixentment." << endl;
}
