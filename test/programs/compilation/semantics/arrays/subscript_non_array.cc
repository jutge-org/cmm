/*

    description{Checks that subscripting on something which is not a pointer or array is not allowed}
    compilation-error{6001}
  
*/

int main() {
    int x;

    x[0] = 2;
}