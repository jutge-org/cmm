#include <iostream>
using namespace std;

int main() {
	int ns;
	cin >> ns;
	for (int i = 0; i < ns; ++i) {
		int a;
		cin >> a;
		double min, max;
		double suma = 0;
		for (int j = 0; j < a; ++j) {
			double n;
			cin >> n;
			suma += n;
			if (j == 0) min = max = n;
			if (n > max) max = n;
			if (n < min) min = n;
		}
		cout << min << " " << max << " " << suma/a << endl;
	}
}
