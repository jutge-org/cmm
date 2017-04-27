/*

 description{Checks that variable shadowing works correctly preserving each scope's values}

 */

 #include <iostream>
 using namespace std;

 int x = 2;


 int f(int x) {
     return x + 2;
 }

 int main() {
     cout << x << endl; // 2
     int x = 3;
     cout << x << endl; // 3

     x = 5;

     cout << x << endl; // 5

     int y = x + 2;

     cout << y << endl; // 7

     if (true) {
         int x = 4;

         cout << x << endl; // 4

         if (not false) {
             int x = 5;
             cout << x << endl; // 5

             int y = 5;
             while (y--) {
                 int x = y;
                 cout << x << endl; // 4, 3, 2, 1, 0
             }

             int c = 0;
             x = 3;
             while ((y = x) and c < 2) { // 3, 4, 2, 4
                 x--;
                 cout << y << endl; // 3, 2 (the scope of the condition is parent of the instruction block scope)
                 int x = 5;
                 --x;
                 cout << x << endl; // 4, 4
                 c++;
             }

             for (int x = 0; x < 3; ++x) { // 0, 1, 77, 1, 2, 2, 3
                 cout << x << endl; // 0, 1, 2
                 cout << y++ << endl; // 1, 2, 3 (inherited)
                 if (x != 0) {}
                 else { int x = 77; cout << x << endl; } // 77
             }
         }

         cout << x << endl; // 4

         x = f(x);

         cout << x << endl; // 6
     }

     cout << x << endl; // 5

     if (true) {
         int x = 6;

         cout << x << endl; // 6
     }

     cout << x << endl; // 5
 }