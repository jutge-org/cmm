/*

    description{Checks that declaring an array variable without specifying all of its dimensions is not allowed}
    compilation-error{2010}
  
*/

int main() {
    int arr[][20];
}