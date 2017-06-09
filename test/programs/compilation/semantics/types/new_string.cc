/*

    description{Checks that using new with a string type is not allowed (missing implementation)}
    compilation-error{9007}

*/

// TODO: Should remove test when they are supported

int main() {
    new string;
}