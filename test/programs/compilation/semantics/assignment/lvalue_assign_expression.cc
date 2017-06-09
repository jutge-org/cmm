/*

    description{Checks that assigning to an expression that does not refer to a memory location is not allowed}
    compilation-error{5002}

*/

int main() {
    int a = 0;

    (a + 5) = 3;
}