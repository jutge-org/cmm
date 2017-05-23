/*

    description{Tests that missing first dimension in a parameter does compile}

*/

int f(int x[][2]){}

int main() {
    int x[5][2];
    f(x);
}