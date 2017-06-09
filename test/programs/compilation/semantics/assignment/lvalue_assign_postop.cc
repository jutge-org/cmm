/*

    description{Checks that assigning to a postincr or postdecr operation is not allowed}
    compilation-error{5002}
  
*/

int main() {
    int x = 0;

    x++ = x;
}