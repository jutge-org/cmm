/*

    description{Checks that deleting a null pointer gives no error}
    
*/

int main() {
    int* x = nullptr;

    delete x;
}