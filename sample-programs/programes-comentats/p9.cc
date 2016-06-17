// Aquest programa comprova els àmbits de les variables
// En l'últim cout el programa peta perquè les variables
// no tenen valor en aquest scope, encara que si que en tenen
// en scopes més interns

#include <iostream>

int main() {
	if (true) {
    	int x = 2;
    }

  	for (int i = 0; i < 100; ++i);

  	int n = 100;
    while(n > 0) {
      int k = n*2;
      --n;
    }


  	int x, k, i;
  	cout << x << k << i << endl;
}
