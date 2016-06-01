#include <iostream>
using namespace std;

void escriu_linia (char c, string s, bool b) {
	bool vocal = c == 'a' or c == 'e' or c == 'i' or c == 'o' or c == 'u' or
			c == 'A' or c == 'E' or c == 'I' or c == 'O' or c == 'U';
	bool majuscula = c >= 'A' and c <= 'Z';
	bool minuscula = c >= 'a' and c <= 'z';
	bool consonant = not vocal and (majuscula or minuscula);
	bool lletra = vocal or consonant;
	bool digit = c >= '0' and c <= '9';
	if (s == "vocal") b = vocal;
	else if (s == "majuscula") b = majuscula;
	else if (s == "minuscula") b = minuscula;
	else if (s == "consonant") b = consonant;
	else if (s == "lletra") b = lletra;
	else b = digit;
	cout << s << "('" << c << "') = ";
	if (b) cout << "cert" << endl;
	else cout << "fals" << endl;
}

int main() {
	char c;
	cin >> c;
	bool b;
	escriu_linia (c, "lletra", b);
	escriu_linia (c, "vocal", b);
	escriu_linia (c, "consonant", b);
	escriu_linia (c, "majuscula", b);
	escriu_linia (c, "minuscula", b);
	escriu_linia (c, "digit", b);
}
