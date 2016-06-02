#include <iostream>
using namespace std;

int main() {
	int x;
	cin >> x;
	int counta, countb, countc;
	counta = countb = countc = 0;
	for (int i = 0; i < x; ++i) {
		char y;
		cin >> y;
		if (y == 'a') counta += 1;
		if (y == 'b') countb++;
		if (y == 'c') ++countc;
	}
	if (counta >= countb and counta >= countc) cout << "majoria de a" << endl << counta << " repeticio(ns)" << endl;
	else if (countb > counta and countb >= countc) cout << "majoria de b" << endl << countb << " repeticio(ns)" << endl;
	else if (countc > counta and countc > countb) cout << "majoria de c" << endl << countc << " repeticio(ns)" << endl;
}
