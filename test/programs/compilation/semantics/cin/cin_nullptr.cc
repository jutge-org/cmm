/*

    description{Checks that using cin on a nullptr is not allowed}
    compilation-error{7002}
  
*/

int main() {
    cin >> nullptr;
}