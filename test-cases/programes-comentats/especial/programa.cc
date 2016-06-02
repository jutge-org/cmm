#include <iostream>
using namespace std;

int main() {
    string tipusa, tipusb, op;
    while (cin >> tipusa >> tipusb >> op) {
        if (tipusa == "int" and tipusb == "int") {
            int a; int b;
            cin >> a >> b;

            if (op == "+") {
                cout << "int(" << a << ")" << " + int(" << b << "): " << (a + b) << endl;
            }if (op == "-") {
                cout << "int(" << a << ")" << " - int(" << b << "): " << (a - b) << endl;
            }if (op == "/") {
                cout << "int(" << a << ")" << " / int(" << b << "): " << (a / b) << endl;
            }if (op == "*") {
                cout << "int(" << a << ")" << " * int(" << b << "): " << (a * b) << endl;
            }if (op == "or") {
                cout << "int(" << a << ")" << " or int(" << b << "): " << (a or b) << endl;
            }if (op == "and") {
                cout << "int(" << a << ")" << " and int(" << b << "): " << (a and b) << endl;
            }if (op == "<=") {
                cout << "int(" << a << ")" << " <= int(" << b << "): " << (a <= b) << endl;
            }if (op == ">=") {
                cout << "int(" << a << ")" << " >= int(" << b << "): " << (a >= b) << endl;
            }if (op == "==") {
                cout << "int(" << a << ")" << " == int(" << b << "): " << (a == b) << endl;
            }if (op == "!=") {
                cout << "int(" << a << ")" << " != int(" << b << "): " << (a != b) << endl;
            }if (op == ">") {
                cout << "int(" << a << ")" << " > int(" << b << "): " << (a > b) << endl;
            }if (op == "<") {
                cout << "int(" << a << ")" << " < int(" << b << "): " << (a < b) << endl;
            }if (op == "%") {
                cout << "int(" << a << ")" << " % int(" << b << "): " << (a % b) << endl;
            }if (op == "+=") {
                cout << "int(" << a << ")" << " += int(" << b << "): " << (a += b) << endl;
            }if (op == "-=") {
                cout << "int(" << a << ")" << " -= int(" << b << "): " << (a -= b) << endl;
            }if (op == "*=") {
                cout << "int(" << a << ")" << " *= int(" << b << "): " << (a *= b) << endl;
            }if (op == "/=") {
                cout << "int(" << a << ")" << " /= int(" << b << "): " << (a /= b) << endl;
            }if (op == "%=") {
                cout << "int(" << a << ")" << " %= int(" << b << "): " << (a %= b) << endl;
            }
        }
        if (tipusa == "int" and tipusb == "double") {
            int a; double b;
            cin >> a >> b;

            if (op == "+") {
                cout << "int(" << a << ")" << " + double(" << b << "): " << (a + b) << endl;
            }if (op == "-") {
                cout << "int(" << a << ")" << " - double(" << b << "): " << (a - b) << endl;
            }if (op == "/") {
                cout << "int(" << a << ")" << " / double(" << b << "): " << (a / b) << endl;
            }if (op == "*") {
                cout << "int(" << a << ")" << " * double(" << b << "): " << (a * b) << endl;
            }if (op == "or") {
                cout << "int(" << a << ")" << " or double(" << b << "): " << (a or b) << endl;
            }if (op == "and") {
                cout << "int(" << a << ")" << " and double(" << b << "): " << (a and b) << endl;
            }if (op == "<=") {
                cout << "int(" << a << ")" << " <= double(" << b << "): " << (a <= b) << endl;
            }if (op == ">=") {
                cout << "int(" << a << ")" << " >= double(" << b << "): " << (a >= b) << endl;
            }if (op == "==") {
                cout << "int(" << a << ")" << " == double(" << b << "): " << (a == b) << endl;
            }if (op == "!=") {
                cout << "int(" << a << ")" << " != double(" << b << "): " << (a != b) << endl;
            }if (op == ">") {
                cout << "int(" << a << ")" << " > double(" << b << "): " << (a > b) << endl;
            }if (op == "<") {
                cout << "int(" << a << ")" << " < double(" << b << "): " << (a < b) << endl;
            }if (op == "%") {
                cout << "int(" << a << ")" << " % double(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "+=") {
                cout << "int(" << a << ")" << " += double(" << b << "): " << (a += b) << endl;
            }if (op == "-=") {
                cout << "int(" << a << ")" << " -= double(" << b << "): " << (a -= b) << endl;
            }if (op == "*=") {
                cout << "int(" << a << ")" << " *= double(" << b << "): " << (a *= b) << endl;
            }if (op == "/=") {
                cout << "int(" << a << ")" << " /= double(" << b << "): " << (a /= b) << endl;
            }if (op == "%=") {
                cout << "int(" << a << ")" << " %= double(" << b << "): " << "operacio no permesa!" << endl;
            }
        }
        if (tipusa == "int" and tipusb == "char") {
            int a; char b;
            cin >> a >> b;

            if (op == "+") {
                cout << "int(" << a << ")" << " + char(" << b << "): " << (a + b) << endl;
            }if (op == "-") {
                cout << "int(" << a << ")" << " - char(" << b << "): " << (a - b) << endl;
            }if (op == "/") {
                cout << "int(" << a << ")" << " / char(" << b << "): " << (a / b) << endl;
            }if (op == "*") {
                cout << "int(" << a << ")" << " * char(" << b << "): " << (a * b) << endl;
            }if (op == "or") {
                cout << "int(" << a << ")" << " or char(" << b << "): " << (a or b) << endl;
            }if (op == "and") {
                cout << "int(" << a << ")" << " and char(" << b << "): " << (a and b) << endl;
            }if (op == "<=") {
                cout << "int(" << a << ")" << " <= char(" << b << "): " << (a <= b) << endl;
            }if (op == ">=") {
                cout << "int(" << a << ")" << " >= char(" << b << "): " << (a >= b) << endl;
            }if (op == "==") {
                cout << "int(" << a << ")" << " == char(" << b << "): " << (a == b) << endl;
            }if (op == "!=") {
                cout << "int(" << a << ")" << " != char(" << b << "): " << (a != b) << endl;
            }if (op == ">") {
                cout << "int(" << a << ")" << " > char(" << b << "): " << (a > b) << endl;
            }if (op == "<") {
                cout << "int(" << a << ")" << " < char(" << b << "): " << (a < b) << endl;
            }if (op == "%") {
                cout << "int(" << a << ")" << " % char(" << b << "): " << (a % b) << endl;
            }if (op == "+=") {
                cout << "int(" << a << ")" << " += char(" << b << "): " << (a += b) << endl;
            }if (op == "-=") {
                cout << "int(" << a << ")" << " -= char(" << b << "): " << (a -= b) << endl;
            }if (op == "*=") {
                cout << "int(" << a << ")" << " *= char(" << b << "): " << (a *= b) << endl;
            }if (op == "/=") {
                cout << "int(" << a << ")" << " /= char(" << b << "): " << (a /= b) << endl;
            }if (op == "%=") {
                cout << "int(" << a << ")" << " %= char(" << b << "): " << (a %= b) << endl;
            }
        }
        if (tipusa == "int" and tipusb == "bool") {
            int a; bool b;
            cin >> a >> b;

            if (op == "+") {
                cout << "int(" << a << ")" << " + bool(" << b << "): " << (a + b) << endl;
            }if (op == "-") {
                cout << "int(" << a << ")" << " - bool(" << b << "): " << (a - b) << endl;
            }if (op == "/") {
                cout << "int(" << a << ")" << " / bool(" << b << "): " << (a / b) << endl;
            }if (op == "*") {
                cout << "int(" << a << ")" << " * bool(" << b << "): " << (a * b) << endl;
            }if (op == "or") {
                cout << "int(" << a << ")" << " or bool(" << b << "): " << (a or b) << endl;
            }if (op == "and") {
                cout << "int(" << a << ")" << " and bool(" << b << "): " << (a and b) << endl;
            }if (op == "<=") {
                cout << "int(" << a << ")" << " <= bool(" << b << "): " << (a <= b) << endl;
            }if (op == ">=") {
                cout << "int(" << a << ")" << " >= bool(" << b << "): " << (a >= b) << endl;
            }if (op == "==") {
                cout << "int(" << a << ")" << " == bool(" << b << "): " << (a == b) << endl;
            }if (op == "!=") {
                cout << "int(" << a << ")" << " != bool(" << b << "): " << (a != b) << endl;
            }if (op == ">") {
                cout << "int(" << a << ")" << " > bool(" << b << "): " << (a > b) << endl;
            }if (op == "<") {
                cout << "int(" << a << ")" << " < bool(" << b << "): " << (a < b) << endl;
            }if (op == "%") {
                cout << "int(" << a << ")" << " % bool(" << b << "): " << (a % b) << endl;
            }if (op == "+=") {
                cout << "int(" << a << ")" << " += bool(" << b << "): " << (a += b) << endl;
            }if (op == "-=") {
                cout << "int(" << a << ")" << " -= bool(" << b << "): " << (a -= b) << endl;
            }if (op == "*=") {
                cout << "int(" << a << ")" << " *= bool(" << b << "): " << (a *= b) << endl;
            }if (op == "/=") {
                cout << "int(" << a << ")" << " /= bool(" << b << "): " << (a /= b) << endl;
            }if (op == "%=") {
                cout << "int(" << a << ")" << " %= bool(" << b << "): " << (a %= b) << endl;
            }
        }
        if (tipusa == "int" and tipusb == "string") {
            int a; string b;
            cin >> a >> b;

            if (op == "+") {
                cout << "int(" << a << ")" << " + string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "-") {
                cout << "int(" << a << ")" << " - string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "/") {
                cout << "int(" << a << ")" << " / string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "*") {
                cout << "int(" << a << ")" << " * string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "or") {
                cout << "int(" << a << ")" << " or string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "and") {
                cout << "int(" << a << ")" << " and string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "<=") {
                cout << "int(" << a << ")" << " <= string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == ">=") {
                cout << "int(" << a << ")" << " >= string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "==") {
                cout << "int(" << a << ")" << " == string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "!=") {
                cout << "int(" << a << ")" << " != string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == ">") {
                cout << "int(" << a << ")" << " > string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "<") {
                cout << "int(" << a << ")" << " < string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "%") {
                cout << "int(" << a << ")" << " % string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "+=") {
                cout << "int(" << a << ")" << " += string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "-=") {
                cout << "int(" << a << ")" << " -= string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "*=") {
                cout << "int(" << a << ")" << " *= string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "/=") {
                cout << "int(" << a << ")" << " /= string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "%=") {
                cout << "int(" << a << ")" << " %= string(" << b << "): " << "operacio no permesa!" << endl;
            }
        }
        if (tipusa == "double" and tipusb == "int") {
            double a; int b;
            cin >> a >> b;

            if (op == "+") {
                cout << "double(" << a << ")" << " + int(" << b << "): " << (a + b) << endl;
            }if (op == "-") {
                cout << "double(" << a << ")" << " - int(" << b << "): " << (a - b) << endl;
            }if (op == "/") {
                cout << "double(" << a << ")" << " / int(" << b << "): " << (a / b) << endl;
            }if (op == "*") {
                cout << "double(" << a << ")" << " * int(" << b << "): " << (a * b) << endl;
            }if (op == "or") {
                cout << "double(" << a << ")" << " or int(" << b << "): " << (a or b) << endl;
            }if (op == "and") {
                cout << "double(" << a << ")" << " and int(" << b << "): " << (a and b) << endl;
            }if (op == "<=") {
                cout << "double(" << a << ")" << " <= int(" << b << "): " << (a <= b) << endl;
            }if (op == ">=") {
                cout << "double(" << a << ")" << " >= int(" << b << "): " << (a >= b) << endl;
            }if (op == "==") {
                cout << "double(" << a << ")" << " == int(" << b << "): " << (a == b) << endl;
            }if (op == "!=") {
                cout << "double(" << a << ")" << " != int(" << b << "): " << (a != b) << endl;
            }if (op == ">") {
                cout << "double(" << a << ")" << " > int(" << b << "): " << (a > b) << endl;
            }if (op == "<") {
                cout << "double(" << a << ")" << " < int(" << b << "): " << (a < b) << endl;
            }if (op == "%") {
                cout << "double(" << a << ")" << " % int(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "+=") {
                cout << "double(" << a << ")" << " += int(" << b << "): " << (a += b) << endl;
            }if (op == "-=") {
                cout << "double(" << a << ")" << " -= int(" << b << "): " << (a -= b) << endl;
            }if (op == "*=") {
                cout << "double(" << a << ")" << " *= int(" << b << "): " << (a *= b) << endl;
            }if (op == "/=") {
                cout << "double(" << a << ")" << " /= int(" << b << "): " << (a /= b) << endl;
            }if (op == "%=") {
                cout << "double(" << a << ")" << " %= int(" << b << "): " << "operacio no permesa!" << endl;
            }
        }
        if (tipusa == "double" and tipusb == "double") {
            double a; double b;
            cin >> a >> b;

            if (op == "+") {
                cout << "double(" << a << ")" << " + double(" << b << "): " << (a + b) << endl;
            }if (op == "-") {
                cout << "double(" << a << ")" << " - double(" << b << "): " << (a - b) << endl;
            }if (op == "/") {
                cout << "double(" << a << ")" << " / double(" << b << "): " << (a / b) << endl;
            }if (op == "*") {
                cout << "double(" << a << ")" << " * double(" << b << "): " << (a * b) << endl;
            }if (op == "or") {
                cout << "double(" << a << ")" << " or double(" << b << "): " << (a or b) << endl;
            }if (op == "and") {
                cout << "double(" << a << ")" << " and double(" << b << "): " << (a and b) << endl;
            }if (op == "<=") {
                cout << "double(" << a << ")" << " <= double(" << b << "): " << (a <= b) << endl;
            }if (op == ">=") {
                cout << "double(" << a << ")" << " >= double(" << b << "): " << (a >= b) << endl;
            }if (op == "==") {
                cout << "double(" << a << ")" << " == double(" << b << "): " << (a == b) << endl;
            }if (op == "!=") {
                cout << "double(" << a << ")" << " != double(" << b << "): " << (a != b) << endl;
            }if (op == ">") {
                cout << "double(" << a << ")" << " > double(" << b << "): " << (a > b) << endl;
            }if (op == "<") {
                cout << "double(" << a << ")" << " < double(" << b << "): " << (a < b) << endl;
            }if (op == "%") {
                cout << "double(" << a << ")" << " % double(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "+=") {
                cout << "double(" << a << ")" << " += double(" << b << "): " << (a += b) << endl;
            }if (op == "-=") {
                cout << "double(" << a << ")" << " -= double(" << b << "): " << (a -= b) << endl;
            }if (op == "*=") {
                cout << "double(" << a << ")" << " *= double(" << b << "): " << (a *= b) << endl;
            }if (op == "/=") {
                cout << "double(" << a << ")" << " /= double(" << b << "): " << (a /= b) << endl;
            }if (op == "%=") {
                cout << "double(" << a << ")" << " %= double(" << b << "): " << "operacio no permesa!" << endl;
            }
        }
        if (tipusa == "double" and tipusb == "char") {
            double a; char b;
            cin >> a >> b;

            if (op == "+") {
                cout << "double(" << a << ")" << " + char(" << b << "): " << (a + b) << endl;
            }if (op == "-") {
                cout << "double(" << a << ")" << " - char(" << b << "): " << (a - b) << endl;
            }if (op == "/") {
                cout << "double(" << a << ")" << " / char(" << b << "): " << (a / b) << endl;
            }if (op == "*") {
                cout << "double(" << a << ")" << " * char(" << b << "): " << (a * b) << endl;
            }if (op == "or") {
                cout << "double(" << a << ")" << " or char(" << b << "): " << (a or b) << endl;
            }if (op == "and") {
                cout << "double(" << a << ")" << " and char(" << b << "): " << (a and b) << endl;
            }if (op == "<=") {
                cout << "double(" << a << ")" << " <= char(" << b << "): " << (a <= b) << endl;
            }if (op == ">=") {
                cout << "double(" << a << ")" << " >= char(" << b << "): " << (a >= b) << endl;
            }if (op == "==") {
                cout << "double(" << a << ")" << " == char(" << b << "): " << (a == b) << endl;
            }if (op == "!=") {
                cout << "double(" << a << ")" << " != char(" << b << "): " << (a != b) << endl;
            }if (op == ">") {
                cout << "double(" << a << ")" << " > char(" << b << "): " << (a > b) << endl;
            }if (op == "<") {
                cout << "double(" << a << ")" << " < char(" << b << "): " << (a < b) << endl;
            }if (op == "%") {
                cout << "double(" << a << ")" << " % char(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "+=") {
                cout << "double(" << a << ")" << " += char(" << b << "): " << (a += b) << endl;
            }if (op == "-=") {
                cout << "double(" << a << ")" << " -= char(" << b << "): " << (a -= b) << endl;
            }if (op == "*=") {
                cout << "double(" << a << ")" << " *= char(" << b << "): " << (a *= b) << endl;
            }if (op == "/=") {
                cout << "double(" << a << ")" << " /= char(" << b << "): " << (a /= b) << endl;
            }if (op == "%=") {
                cout << "double(" << a << ")" << " %= char(" << b << "): " << "operacio no permesa!" << endl;
            }
        }
        if (tipusa == "double" and tipusb == "bool") {
            double a; bool b;
            cin >> a >> b;

            if (op == "+") {
                cout << "double(" << a << ")" << " + bool(" << b << "): " << (a + b) << endl;
            }if (op == "-") {
                cout << "double(" << a << ")" << " - bool(" << b << "): " << (a - b) << endl;
            }if (op == "/") {
                cout << "double(" << a << ")" << " / bool(" << b << "): " << (a / b) << endl;
            }if (op == "*") {
                cout << "double(" << a << ")" << " * bool(" << b << "): " << (a * b) << endl;
            }if (op == "or") {
                cout << "double(" << a << ")" << " or bool(" << b << "): " << (a or b) << endl;
            }if (op == "and") {
                cout << "double(" << a << ")" << " and bool(" << b << "): " << (a and b) << endl;
            }if (op == "<=") {
                cout << "double(" << a << ")" << " <= bool(" << b << "): " << (a <= b) << endl;
            }if (op == ">=") {
                cout << "double(" << a << ")" << " >= bool(" << b << "): " << (a >= b) << endl;
            }if (op == "==") {
                cout << "double(" << a << ")" << " == bool(" << b << "): " << (a == b) << endl;
            }if (op == "!=") {
                cout << "double(" << a << ")" << " != bool(" << b << "): " << (a != b) << endl;
            }if (op == ">") {
                cout << "double(" << a << ")" << " > bool(" << b << "): " << (a > b) << endl;
            }if (op == "<") {
                cout << "double(" << a << ")" << " < bool(" << b << "): " << (a < b) << endl;
            }if (op == "%") {
                cout << "double(" << a << ")" << " % bool(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "+=") {
                cout << "double(" << a << ")" << " += bool(" << b << "): " << (a += b) << endl;
            }if (op == "-=") {
                cout << "double(" << a << ")" << " -= bool(" << b << "): " << (a -= b) << endl;
            }if (op == "*=") {
                cout << "double(" << a << ")" << " *= bool(" << b << "): " << (a *= b) << endl;
            }if (op == "/=") {
                cout << "double(" << a << ")" << " /= bool(" << b << "): " << (a /= b) << endl;
            }if (op == "%=") {
                cout << "double(" << a << ")" << " %= bool(" << b << "): " << "operacio no permesa!" << endl;
            }
        }
        if (tipusa == "double" and tipusb == "string") {
            double a; string b;
            cin >> a >> b;

            if (op == "+") {
                cout << "double(" << a << ")" << " + string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "-") {
                cout << "double(" << a << ")" << " - string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "/") {
                cout << "double(" << a << ")" << " / string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "*") {
                cout << "double(" << a << ")" << " * string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "or") {
                cout << "double(" << a << ")" << " or string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "and") {
                cout << "double(" << a << ")" << " and string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "<=") {
                cout << "double(" << a << ")" << " <= string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == ">=") {
                cout << "double(" << a << ")" << " >= string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "==") {
                cout << "double(" << a << ")" << " == string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "!=") {
                cout << "double(" << a << ")" << " != string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == ">") {
                cout << "double(" << a << ")" << " > string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "<") {
                cout << "double(" << a << ")" << " < string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "%") {
                cout << "double(" << a << ")" << " % string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "+=") {
                cout << "double(" << a << ")" << " += string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "-=") {
                cout << "double(" << a << ")" << " -= string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "*=") {
                cout << "double(" << a << ")" << " *= string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "/=") {
                cout << "double(" << a << ")" << " /= string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "%=") {
                cout << "double(" << a << ")" << " %= string(" << b << "): " << "operacio no permesa!" << endl;
            }
        }
        if (tipusa == "char" and tipusb == "int") {
            char a; int b;
            cin >> a >> b;

            if (op == "+") {
                cout << "char(" << a << ")" << " + int(" << b << "): " << (a + b) << endl;
            }if (op == "-") {
                cout << "char(" << a << ")" << " - int(" << b << "): " << (a - b) << endl;
            }if (op == "/") {
                cout << "char(" << a << ")" << " / int(" << b << "): " << (a / b) << endl;
            }if (op == "*") {
                cout << "char(" << a << ")" << " * int(" << b << "): " << (a * b) << endl;
            }if (op == "or") {
                cout << "char(" << a << ")" << " or int(" << b << "): " << (a or b) << endl;
            }if (op == "and") {
                cout << "char(" << a << ")" << " and int(" << b << "): " << (a and b) << endl;
            }if (op == "<=") {
                cout << "char(" << a << ")" << " <= int(" << b << "): " << (a <= b) << endl;
            }if (op == ">=") {
                cout << "char(" << a << ")" << " >= int(" << b << "): " << (a >= b) << endl;
            }if (op == "==") {
                cout << "char(" << a << ")" << " == int(" << b << "): " << (a == b) << endl;
            }if (op == "!=") {
                cout << "char(" << a << ")" << " != int(" << b << "): " << (a != b) << endl;
            }if (op == ">") {
                cout << "char(" << a << ")" << " > int(" << b << "): " << (a > b) << endl;
            }if (op == "<") {
                cout << "char(" << a << ")" << " < int(" << b << "): " << (a < b) << endl;
            }if (op == "%") {
                cout << "char(" << a << ")" << " % int(" << b << "): " << (a % b) << endl;
            }if (op == "+=") {
                cout << "char(" << a << ")" << " += int(" << b << "): " << (a += b) << endl;
            }if (op == "-=") {
                cout << "char(" << a << ")" << " -= int(" << b << "): " << (a -= b) << endl;
            }if (op == "*=") {
                cout << "char(" << a << ")" << " *= int(" << b << "): " << (a *= b) << endl;
            }if (op == "/=") {
                cout << "char(" << a << ")" << " /= int(" << b << "): " << (a /= b) << endl;
            }if (op == "%=") {
                cout << "char(" << a << ")" << " %= int(" << b << "): " << (a %= b) << endl;
            }
        }
        if (tipusa == "char" and tipusb == "double") {
            char a; double b;
            cin >> a >> b;

            if (op == "+") {
                cout << "char(" << a << ")" << " + double(" << b << "): " << (a + b) << endl;
            }if (op == "-") {
                cout << "char(" << a << ")" << " - double(" << b << "): " << (a - b) << endl;
            }if (op == "/") {
                cout << "char(" << a << ")" << " / double(" << b << "): " << (a / b) << endl;
            }if (op == "*") {
                cout << "char(" << a << ")" << " * double(" << b << "): " << (a * b) << endl;
            }if (op == "or") {
                cout << "char(" << a << ")" << " or double(" << b << "): " << (a or b) << endl;
            }if (op == "and") {
                cout << "char(" << a << ")" << " and double(" << b << "): " << (a and b) << endl;
            }if (op == "<=") {
                cout << "char(" << a << ")" << " <= double(" << b << "): " << (a <= b) << endl;
            }if (op == ">=") {
                cout << "char(" << a << ")" << " >= double(" << b << "): " << (a >= b) << endl;
            }if (op == "==") {
                cout << "char(" << a << ")" << " == double(" << b << "): " << (a == b) << endl;
            }if (op == "!=") {
                cout << "char(" << a << ")" << " != double(" << b << "): " << (a != b) << endl;
            }if (op == ">") {
                cout << "char(" << a << ")" << " > double(" << b << "): " << (a > b) << endl;
            }if (op == "<") {
                cout << "char(" << a << ")" << " < double(" << b << "): " << (a < b) << endl;
            }if (op == "%") {
                cout << "char(" << a << ")" << " % double(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "+=") {
                cout << "char(" << a << ")" << " += double(" << b << "): " << (a += b) << endl;
            }if (op == "-=") {
                cout << "char(" << a << ")" << " -= double(" << b << "): " << (a -= b) << endl;
            }if (op == "*=") {
                cout << "char(" << a << ")" << " *= double(" << b << "): " << (a *= b) << endl;
            }if (op == "/=") {
                cout << "char(" << a << ")" << " /= double(" << b << "): " << (a /= b) << endl;
            }if (op == "%=") {
                cout << "char(" << a << ")" << " %= double(" << b << "): " << "operacio no permesa!" << endl;
            }
        }
        if (tipusa == "char" and tipusb == "char") {
            char a; char b;
            cin >> a >> b;

            if (op == "+") {
                cout << "char(" << a << ")" << " + char(" << b << "): " << (a + b) << endl;
            }if (op == "-") {
                cout << "char(" << a << ")" << " - char(" << b << "): " << (a - b) << endl;
            }if (op == "/") {
                cout << "char(" << a << ")" << " / char(" << b << "): " << (a / b) << endl;
            }if (op == "*") {
                cout << "char(" << a << ")" << " * char(" << b << "): " << (a * b) << endl;
            }if (op == "or") {
                cout << "char(" << a << ")" << " or char(" << b << "): " << (a or b) << endl;
            }if (op == "and") {
                cout << "char(" << a << ")" << " and char(" << b << "): " << (a and b) << endl;
            }if (op == "<=") {
                cout << "char(" << a << ")" << " <= char(" << b << "): " << (a <= b) << endl;
            }if (op == ">=") {
                cout << "char(" << a << ")" << " >= char(" << b << "): " << (a >= b) << endl;
            }if (op == "==") {
                cout << "char(" << a << ")" << " == char(" << b << "): " << (a == b) << endl;
            }if (op == "!=") {
                cout << "char(" << a << ")" << " != char(" << b << "): " << (a != b) << endl;
            }if (op == ">") {
                cout << "char(" << a << ")" << " > char(" << b << "): " << (a > b) << endl;
            }if (op == "<") {
                cout << "char(" << a << ")" << " < char(" << b << "): " << (a < b) << endl;
            }if (op == "%") {
                cout << "char(" << a << ")" << " % char(" << b << "): " << (a % b) << endl;
            }if (op == "+=") {
                cout << "char(" << a << ")" << " += char(" << b << "): " << (a += b) << endl;
            }if (op == "-=") {
                cout << "char(" << a << ")" << " -= char(" << b << "): " << (a -= b) << endl;
            }if (op == "*=") {
                cout << "char(" << a << ")" << " *= char(" << b << "): " << (a *= b) << endl;
            }if (op == "/=") {
                cout << "char(" << a << ")" << " /= char(" << b << "): " << (a /= b) << endl;
            }if (op == "%=") {
                cout << "char(" << a << ")" << " %= char(" << b << "): " << (a %= b) << endl;
            }
        }
        if (tipusa == "char" and tipusb == "bool") {
            char a; bool b;
            cin >> a >> b;

            if (op == "+") {
                cout << "char(" << a << ")" << " + bool(" << b << "): " << (a + b) << endl;
            }if (op == "-") {
                cout << "char(" << a << ")" << " - bool(" << b << "): " << (a - b) << endl;
            }if (op == "/") {
                cout << "char(" << a << ")" << " / bool(" << b << "): " << (a / b) << endl;
            }if (op == "*") {
                cout << "char(" << a << ")" << " * bool(" << b << "): " << (a * b) << endl;
            }if (op == "or") {
                cout << "char(" << a << ")" << " or bool(" << b << "): " << (a or b) << endl;
            }if (op == "and") {
                cout << "char(" << a << ")" << " and bool(" << b << "): " << (a and b) << endl;
            }if (op == "<=") {
                cout << "char(" << a << ")" << " <= bool(" << b << "): " << (a <= b) << endl;
            }if (op == ">=") {
                cout << "char(" << a << ")" << " >= bool(" << b << "): " << (a >= b) << endl;
            }if (op == "==") {
                cout << "char(" << a << ")" << " == bool(" << b << "): " << (a == b) << endl;
            }if (op == "!=") {
                cout << "char(" << a << ")" << " != bool(" << b << "): " << (a != b) << endl;
            }if (op == ">") {
                cout << "char(" << a << ")" << " > bool(" << b << "): " << (a > b) << endl;
            }if (op == "<") {
                cout << "char(" << a << ")" << " < bool(" << b << "): " << (a < b) << endl;
            }if (op == "%") {
                cout << "char(" << a << ")" << " % bool(" << b << "): " << (a % b) << endl;
            }if (op == "+=") {
                cout << "char(" << a << ")" << " += bool(" << b << "): " << (a += b) << endl;
            }if (op == "-=") {
                cout << "char(" << a << ")" << " -= bool(" << b << "): " << (a -= b) << endl;
            }if (op == "*=") {
                cout << "char(" << a << ")" << " *= bool(" << b << "): " << (a *= b) << endl;
            }if (op == "/=") {
                cout << "char(" << a << ")" << " /= bool(" << b << "): " << (a /= b) << endl;
            }if (op == "%=") {
                cout << "char(" << a << ")" << " %= bool(" << b << "): " << (a %= b) << endl;
            }
        }
        if (tipusa == "char" and tipusb == "string") {
            char a; string b;
            cin >> a >> b;

            if (op == "+") {
                cout << "char(" << a << ")" << " + string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "-") {
                cout << "char(" << a << ")" << " - string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "/") {
                cout << "char(" << a << ")" << " / string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "*") {
                cout << "char(" << a << ")" << " * string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "or") {
                cout << "char(" << a << ")" << " or string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "and") {
                cout << "char(" << a << ")" << " and string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "<=") {
                cout << "char(" << a << ")" << " <= string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == ">=") {
                cout << "char(" << a << ")" << " >= string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "==") {
                cout << "char(" << a << ")" << " == string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "!=") {
                cout << "char(" << a << ")" << " != string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == ">") {
                cout << "char(" << a << ")" << " > string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "<") {
                cout << "char(" << a << ")" << " < string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "%") {
                cout << "char(" << a << ")" << " % string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "+=") {
                cout << "char(" << a << ")" << " += string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "-=") {
                cout << "char(" << a << ")" << " -= string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "*=") {
                cout << "char(" << a << ")" << " *= string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "/=") {
                cout << "char(" << a << ")" << " /= string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "%=") {
                cout << "char(" << a << ")" << " %= string(" << b << "): " << "operacio no permesa!" << endl;
            }
        }
        if (tipusa == "bool" and tipusb == "int") {
            bool a; int b;
            cin >> a >> b;

            if (op == "+") {
                cout << "bool(" << a << ")" << " + int(" << b << "): " << (a + b) << endl;
            }if (op == "-") {
                cout << "bool(" << a << ")" << " - int(" << b << "): " << (a - b) << endl;
            }if (op == "/") {
                cout << "bool(" << a << ")" << " / int(" << b << "): " << (a / b) << endl;
            }if (op == "*") {
                cout << "bool(" << a << ")" << " * int(" << b << "): " << (a * b) << endl;
            }if (op == "or") {
                cout << "bool(" << a << ")" << " or int(" << b << "): " << (a or b) << endl;
            }if (op == "and") {
                cout << "bool(" << a << ")" << " and int(" << b << "): " << (a and b) << endl;
            }if (op == "<=") {
                cout << "bool(" << a << ")" << " <= int(" << b << "): " << (a <= b) << endl;
            }if (op == ">=") {
                cout << "bool(" << a << ")" << " >= int(" << b << "): " << (a >= b) << endl;
            }if (op == "==") {
                cout << "bool(" << a << ")" << " == int(" << b << "): " << (a == b) << endl;
            }if (op == "!=") {
                cout << "bool(" << a << ")" << " != int(" << b << "): " << (a != b) << endl;
            }if (op == ">") {
                cout << "bool(" << a << ")" << " > int(" << b << "): " << (a > b) << endl;
            }if (op == "<") {
                cout << "bool(" << a << ")" << " < int(" << b << "): " << (a < b) << endl;
            }if (op == "%") {
                cout << "bool(" << a << ")" << " % int(" << b << "): " << (a % b) << endl;
            }if (op == "+=") {
                cout << "bool(" << a << ")" << " += int(" << b << "): " << (a += b) << endl;
            }if (op == "-=") {
                cout << "bool(" << a << ")" << " -= int(" << b << "): " << (a -= b) << endl;
            }if (op == "*=") {
                cout << "bool(" << a << ")" << " *= int(" << b << "): " << (a *= b) << endl;
            }if (op == "/=") {
                cout << "bool(" << a << ")" << " /= int(" << b << "): " << (a /= b) << endl;
            }if (op == "%=") {
                cout << "bool(" << a << ")" << " %= int(" << b << "): " << (a %= b) << endl;
            }
        }
        if (tipusa == "bool" and tipusb == "double") {
            bool a; double b;
            cin >> a >> b;

            if (op == "+") {
                cout << "bool(" << a << ")" << " + double(" << b << "): " << (a + b) << endl;
            }if (op == "-") {
                cout << "bool(" << a << ")" << " - double(" << b << "): " << (a - b) << endl;
            }if (op == "/") {
                cout << "bool(" << a << ")" << " / double(" << b << "): " << (a / b) << endl;
            }if (op == "*") {
                cout << "bool(" << a << ")" << " * double(" << b << "): " << (a * b) << endl;
            }if (op == "or") {
                cout << "bool(" << a << ")" << " or double(" << b << "): " << (a or b) << endl;
            }if (op == "and") {
                cout << "bool(" << a << ")" << " and double(" << b << "): " << (a and b) << endl;
            }if (op == "<=") {
                cout << "bool(" << a << ")" << " <= double(" << b << "): " << (a <= b) << endl;
            }if (op == ">=") {
                cout << "bool(" << a << ")" << " >= double(" << b << "): " << (a >= b) << endl;
            }if (op == "==") {
                cout << "bool(" << a << ")" << " == double(" << b << "): " << (a == b) << endl;
            }if (op == "!=") {
                cout << "bool(" << a << ")" << " != double(" << b << "): " << (a != b) << endl;
            }if (op == ">") {
                cout << "bool(" << a << ")" << " > double(" << b << "): " << (a > b) << endl;
            }if (op == "<") {
                cout << "bool(" << a << ")" << " < double(" << b << "): " << (a < b) << endl;
            }if (op == "%") {
                cout << "bool(" << a << ")" << " % double(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "+=") {
                cout << "bool(" << a << ")" << " += double(" << b << "): " << (a += b) << endl;
            }if (op == "-=") {
                cout << "bool(" << a << ")" << " -= double(" << b << "): " << (a -= b) << endl;
            }if (op == "*=") {
                cout << "bool(" << a << ")" << " *= double(" << b << "): " << (a *= b) << endl;
            }if (op == "/=") {
                cout << "bool(" << a << ")" << " /= double(" << b << "): " << (a /= b) << endl;
            }if (op == "%=") {
                cout << "bool(" << a << ")" << " %= double(" << b << "): " << "operacio no permesa!" << endl;
            }
        }
        if (tipusa == "bool" and tipusb == "char") {
            bool a; char b;
            cin >> a >> b;

            if (op == "+") {
                cout << "bool(" << a << ")" << " + char(" << b << "): " << (a + b) << endl;
            }if (op == "-") {
                cout << "bool(" << a << ")" << " - char(" << b << "): " << (a - b) << endl;
            }if (op == "/") {
                cout << "bool(" << a << ")" << " / char(" << b << "): " << (a / b) << endl;
            }if (op == "*") {
                cout << "bool(" << a << ")" << " * char(" << b << "): " << (a * b) << endl;
            }if (op == "or") {
                cout << "bool(" << a << ")" << " or char(" << b << "): " << (a or b) << endl;
            }if (op == "and") {
                cout << "bool(" << a << ")" << " and char(" << b << "): " << (a and b) << endl;
            }if (op == "<=") {
                cout << "bool(" << a << ")" << " <= char(" << b << "): " << (a <= b) << endl;
            }if (op == ">=") {
                cout << "bool(" << a << ")" << " >= char(" << b << "): " << (a >= b) << endl;
            }if (op == "==") {
                cout << "bool(" << a << ")" << " == char(" << b << "): " << (a == b) << endl;
            }if (op == "!=") {
                cout << "bool(" << a << ")" << " != char(" << b << "): " << (a != b) << endl;
            }if (op == ">") {
                cout << "bool(" << a << ")" << " > char(" << b << "): " << (a > b) << endl;
            }if (op == "<") {
                cout << "bool(" << a << ")" << " < char(" << b << "): " << (a < b) << endl;
            }if (op == "%") {
                cout << "bool(" << a << ")" << " % char(" << b << "): " << (a % b) << endl;
            }if (op == "+=") {
                cout << "bool(" << a << ")" << " += char(" << b << "): " << (a += b) << endl;
            }if (op == "-=") {
                cout << "bool(" << a << ")" << " -= char(" << b << "): " << (a -= b) << endl;
            }if (op == "*=") {
                cout << "bool(" << a << ")" << " *= char(" << b << "): " << (a *= b) << endl;
            }if (op == "/=") {
                cout << "bool(" << a << ")" << " /= char(" << b << "): " << (a /= b) << endl;
            }if (op == "%=") {
                cout << "bool(" << a << ")" << " %= char(" << b << "): " << (a %= b) << endl;
            }
        }
        if (tipusa == "bool" and tipusb == "bool") {
            bool a; bool b;
            cin >> a >> b;

            if (op == "+") {
                cout << "bool(" << a << ")" << " + bool(" << b << "): " << (a + b) << endl;
            }if (op == "-") {
                cout << "bool(" << a << ")" << " - bool(" << b << "): " << (a - b) << endl;
            }if (op == "/") {
                cout << "bool(" << a << ")" << " / bool(" << b << "): " << (a / b) << endl;
            }if (op == "*") {
                cout << "bool(" << a << ")" << " * bool(" << b << "): " << (a * b) << endl;
            }if (op == "or") {
                cout << "bool(" << a << ")" << " or bool(" << b << "): " << (a or b) << endl;
            }if (op == "and") {
                cout << "bool(" << a << ")" << " and bool(" << b << "): " << (a and b) << endl;
            }if (op == "<=") {
                cout << "bool(" << a << ")" << " <= bool(" << b << "): " << (a <= b) << endl;
            }if (op == ">=") {
                cout << "bool(" << a << ")" << " >= bool(" << b << "): " << (a >= b) << endl;
            }if (op == "==") {
                cout << "bool(" << a << ")" << " == bool(" << b << "): " << (a == b) << endl;
            }if (op == "!=") {
                cout << "bool(" << a << ")" << " != bool(" << b << "): " << (a != b) << endl;
            }if (op == ">") {
                cout << "bool(" << a << ")" << " > bool(" << b << "): " << (a > b) << endl;
            }if (op == "<") {
                cout << "bool(" << a << ")" << " < bool(" << b << "): " << (a < b) << endl;
            }if (op == "%") {
                cout << "bool(" << a << ")" << " % bool(" << b << "): " << (a % b) << endl;
            }if (op == "+=") {
                cout << "bool(" << a << ")" << " += bool(" << b << "): " << (a += b) << endl;
            }if (op == "-=") {
                cout << "bool(" << a << ")" << " -= bool(" << b << "): " << (a -= b) << endl;
            }if (op == "*=") {
                cout << "bool(" << a << ")" << " *= bool(" << b << "): " << (a *= b) << endl;
            }if (op == "/=") {
                cout << "bool(" << a << ")" << " /= bool(" << b << "): " << (a /= b) << endl;
            }if (op == "%=") {
                cout << "bool(" << a << ")" << " %= bool(" << b << "): " << (a %= b) << endl;
            }
        }
        if (tipusa == "bool" and tipusb == "string") {
            bool a; string b;
            cin >> a >> b;

            if (op == "+") {
                cout << "bool(" << a << ")" << " + string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "-") {
                cout << "bool(" << a << ")" << " - string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "/") {
                cout << "bool(" << a << ")" << " / string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "*") {
                cout << "bool(" << a << ")" << " * string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "or") {
                cout << "bool(" << a << ")" << " or string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "and") {
                cout << "bool(" << a << ")" << " and string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "<=") {
                cout << "bool(" << a << ")" << " <= string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == ">=") {
                cout << "bool(" << a << ")" << " >= string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "==") {
                cout << "bool(" << a << ")" << " == string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "!=") {
                cout << "bool(" << a << ")" << " != string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == ">") {
                cout << "bool(" << a << ")" << " > string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "<") {
                cout << "bool(" << a << ")" << " < string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "%") {
                cout << "bool(" << a << ")" << " % string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "+=") {
                cout << "bool(" << a << ")" << " += string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "-=") {
                cout << "bool(" << a << ")" << " -= string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "*=") {
                cout << "bool(" << a << ")" << " *= string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "/=") {
                cout << "bool(" << a << ")" << " /= string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "%=") {
                cout << "bool(" << a << ")" << " %= string(" << b << "): " << "operacio no permesa!" << endl;
            }
        }
        if (tipusa == "string" and tipusb == "int") {
            string a; int b;
            cin >> a >> b;

            if (op == "+") {
                cout << "string(" << a << ")" << " + int(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "-") {
                cout << "string(" << a << ")" << " - int(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "/") {
                cout << "string(" << a << ")" << " / int(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "*") {
                cout << "string(" << a << ")" << " * int(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "or") {
                cout << "string(" << a << ")" << " or int(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "and") {
                cout << "string(" << a << ")" << " and int(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "<=") {
                cout << "string(" << a << ")" << " <= int(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == ">=") {
                cout << "string(" << a << ")" << " >= int(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "==") {
                cout << "string(" << a << ")" << " == int(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "!=") {
                cout << "string(" << a << ")" << " != int(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == ">") {
                cout << "string(" << a << ")" << " > int(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "<") {
                cout << "string(" << a << ")" << " < int(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "%") {
                cout << "string(" << a << ")" << " % int(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "+=") {
                cout << "string(" << a << ")" << " += int(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "-=") {
                cout << "string(" << a << ")" << " -= int(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "*=") {
                cout << "string(" << a << ")" << " *= int(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "/=") {
                cout << "string(" << a << ")" << " /= int(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "%=") {
                cout << "string(" << a << ")" << " %= int(" << b << "): " << "operacio no permesa!" << endl;
            }
        }
        if (tipusa == "string" and tipusb == "double") {
            string a; double b;
            cin >> a >> b;

            if (op == "+") {
                cout << "string(" << a << ")" << " + double(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "-") {
                cout << "string(" << a << ")" << " - double(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "/") {
                cout << "string(" << a << ")" << " / double(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "*") {
                cout << "string(" << a << ")" << " * double(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "or") {
                cout << "string(" << a << ")" << " or double(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "and") {
                cout << "string(" << a << ")" << " and double(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "<=") {
                cout << "string(" << a << ")" << " <= double(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == ">=") {
                cout << "string(" << a << ")" << " >= double(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "==") {
                cout << "string(" << a << ")" << " == double(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "!=") {
                cout << "string(" << a << ")" << " != double(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == ">") {
                cout << "string(" << a << ")" << " > double(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "<") {
                cout << "string(" << a << ")" << " < double(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "%") {
                cout << "string(" << a << ")" << " % double(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "+=") {
                cout << "string(" << a << ")" << " += double(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "-=") {
                cout << "string(" << a << ")" << " -= double(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "*=") {
                cout << "string(" << a << ")" << " *= double(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "/=") {
                cout << "string(" << a << ")" << " /= double(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "%=") {
                cout << "string(" << a << ")" << " %= double(" << b << "): " << "operacio no permesa!" << endl;
            }
        }
        if (tipusa == "string" and tipusb == "char") {
            string a; char b;
            cin >> a >> b;

            if (op == "+") {
                cout << "string(" << a << ")" << " + char(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "-") {
                cout << "string(" << a << ")" << " - char(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "/") {
                cout << "string(" << a << ")" << " / char(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "*") {
                cout << "string(" << a << ")" << " * char(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "or") {
                cout << "string(" << a << ")" << " or char(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "and") {
                cout << "string(" << a << ")" << " and char(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "<=") {
                cout << "string(" << a << ")" << " <= char(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == ">=") {
                cout << "string(" << a << ")" << " >= char(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "==") {
                cout << "string(" << a << ")" << " == char(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "!=") {
                cout << "string(" << a << ")" << " != char(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == ">") {
                cout << "string(" << a << ")" << " > char(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "<") {
                cout << "string(" << a << ")" << " < char(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "%") {
                cout << "string(" << a << ")" << " % char(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "+=") {
                cout << "string(" << a << ")" << " += char(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "-=") {
                cout << "string(" << a << ")" << " -= char(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "*=") {
                cout << "string(" << a << ")" << " *= char(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "/=") {
                cout << "string(" << a << ")" << " /= char(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "%=") {
                cout << "string(" << a << ")" << " %= char(" << b << "): " << "operacio no permesa!" << endl;
            }
        }
        if (tipusa == "string" and tipusb == "bool") {
            string a; bool b;
            cin >> a >> b;

            if (op == "+") {
                cout << "string(" << a << ")" << " + bool(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "-") {
                cout << "string(" << a << ")" << " - bool(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "/") {
                cout << "string(" << a << ")" << " / bool(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "*") {
                cout << "string(" << a << ")" << " * bool(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "or") {
                cout << "string(" << a << ")" << " or bool(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "and") {
                cout << "string(" << a << ")" << " and bool(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "<=") {
                cout << "string(" << a << ")" << " <= bool(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == ">=") {
                cout << "string(" << a << ")" << " >= bool(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "==") {
                cout << "string(" << a << ")" << " == bool(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "!=") {
                cout << "string(" << a << ")" << " != bool(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == ">") {
                cout << "string(" << a << ")" << " > bool(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "<") {
                cout << "string(" << a << ")" << " < bool(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "%") {
                cout << "string(" << a << ")" << " % bool(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "+=") {
                cout << "string(" << a << ")" << " += bool(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "-=") {
                cout << "string(" << a << ")" << " -= bool(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "*=") {
                cout << "string(" << a << ")" << " *= bool(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "/=") {
                cout << "string(" << a << ")" << " /= bool(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "%=") {
                cout << "string(" << a << ")" << " %= bool(" << b << "): " << "operacio no permesa!" << endl;
            }
        }
        if (tipusa == "string" and tipusb == "string") {
            string a; string b;
            cin >> a >> b;

            if (op == "+") {
                cout << "string(" << a << ")" << " + string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "-") {
                cout << "string(" << a << ")" << " - string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "/") {
                cout << "string(" << a << ")" << " / string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "*") {
                cout << "string(" << a << ")" << " * string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "or") {
                cout << "string(" << a << ")" << " or string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "and") {
                cout << "string(" << a << ")" << " and string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "<=") {
                cout << "string(" << a << ")" << " <= string(" << b << "): " << (a <= b) << endl;
            }if (op == ">=") {
                cout << "string(" << a << ")" << " >= string(" << b << "): " << (a >= b) << endl;
            }if (op == "==") {
                cout << "string(" << a << ")" << " == string(" << b << "): " << (a == b) << endl;
            }if (op == "!=") {
                cout << "string(" << a << ")" << " != string(" << b << "): " << (a != b) << endl;
            }if (op == ">") {
                cout << "string(" << a << ")" << " > string(" << b << "): " << (a > b) << endl;
            }if (op == "<") {
                cout << "string(" << a << ")" << " < string(" << b << "): " << (a < b) << endl;
            }if (op == "%") {
                cout << "string(" << a << ")" << " % string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "+=") {
                cout << "string(" << a << ")" << " += string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "-=") {
                cout << "string(" << a << ")" << " -= string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "*=") {
                cout << "string(" << a << ")" << " *= string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "/=") {
                cout << "string(" << a << ")" << " /= string(" << b << "): " << "operacio no permesa!" << endl;
            }if (op == "%=") {
                cout << "string(" << a << ")" << " %= string(" << b << "): " << "operacio no permesa!" << endl;
            }
        }

    }
}
