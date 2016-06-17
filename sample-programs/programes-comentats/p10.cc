// Aquest programa comprova castings entre tipus

#include <iostream>
  using namespace std;

int main() {
	int teninteger = 10;
  	int zerointeger = 0;
  	bool yes = teninteger;
  	bool no = zerointeger;
  	char character = '0';
  	double zerodecimal = 0.0;
  	double pidecimal = 3.14;
    char un = character + 1;

  	cout << (zerodecimal == zerointeger) << ' '
      	 << yes << ' ' << no << ' ' << pidecimal < teninteger
         << ' ' <<  un << endl;

}
