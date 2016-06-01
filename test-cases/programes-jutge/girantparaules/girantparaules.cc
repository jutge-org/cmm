#include <iostream>
using namespace std;

void alreves (int n, string y) {
	if (n > 0 and cin >> y) {
		alreves (n-1, y);
		cout << y << endl;
	}
}

int main() {
	int n;
	cin >> n;
	string z;
	alreves (n, z);
}
