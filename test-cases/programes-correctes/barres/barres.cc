#include <iostream>
using namespace std;

void escriu_estrella(int n) {
	if (n == 0) cout << endl;
	else {
		cout << '*';
		escriu_estrella(n - 1);
	}
}

void escriu_barres(int n) {
	if (n == 1) cout << '*' << endl;
	else {
		escriu_estrella(n);
		escriu_barres(n - 1);
		escriu_barres(n - 1);
	}
}

int main() {
	int n;
	cin >> n;
	escriu_barres(n);
}
