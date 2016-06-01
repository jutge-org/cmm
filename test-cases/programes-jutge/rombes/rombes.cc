#include <iostream>
using namespace std;

int main() {
	int x;
	cin >> x;
	for (int i = 1; i <= x; ++i) {
		for (int j = 0; j < x + i - 1; ++j) {
			if (j < x - i) cout << ' ';
			else cout << '*';
		}
		cout << endl;
	}
	for (int i = 1; i < x; ++i) {
		for (int j = 0; j < 2*x - i - 1; ++j) {
			if (j >= i) cout << '*';
			else cout << ' ';
		}
		cout << endl;
	}
}
