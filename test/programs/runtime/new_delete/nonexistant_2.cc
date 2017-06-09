/*

    description{Checks that trying to delete (free) the static heap space is not allowed}
    status{142}
    
*/

int a[20];

int main() {
    int* x = a;

    delete x;
}