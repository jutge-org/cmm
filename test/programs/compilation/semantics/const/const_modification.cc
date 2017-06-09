/*

    description{Checks that modifying const variables is not allowed}
    compilation-error{5004}
  
*/

const int SIZE = 3;

int main() {
    SIZE = 5;
}