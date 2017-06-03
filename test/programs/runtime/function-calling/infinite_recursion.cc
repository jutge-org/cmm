/*

    description{Checks that a stack overflow error is thrown with infinite recursion}
    status{138}
*/

int main () {
  double x[2000]; // Makes the recursion depth needed for the crash smaller so that the test doesn't take too long to run

  main();
}