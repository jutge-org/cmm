int executeFunction(bool j) {
    for (int i = 0; i < 10; i = i + 1) {
        if (i == 5) {
            if (j) return i;
        }
    }
    return -1;
}

int main() {
    cout << executeFunction(false) << endl;
}