/*

    description{Checks that performing binary operations with two array arguments is not allowed}
    compilation-error{8001}
  
*/

int main() {
    int p[20];

    p + p;
}