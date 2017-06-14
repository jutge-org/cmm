#include <iostream>
using namespace std;

double** read_matrix(int* n, int* m) {
    double **M;

    cin >> *n >> *m;

    M = new double* [*n];
    for (int i = 0; i < *n; ++i) M[i] = new double[*m];

    for (int i = 0; i < *n; ++i)
        for (int j = 0; j < *m; ++j)
            cin >> M[i][j];

    return M;
}

void write_matrix(double **M, int n, int m) {
    for (int i = 0; i < n; ++i) {
        if (m >  0) cout << M[i][0];
        for (int j = 1; j < m; ++j) {
            cout << ' ' << M[i][j];
        }
        cout << endl;
    }
}

double** matrix_mul(double **M1, int n1, int m1, double **M2, int n2, int m2) {
    if (m1 != n2) {
        cout << "Cannot multiply matrices with sizes " << n1 << "x" << m1 << " and " << n2 << "x" << m2 << endl;
        return nullptr;
    }
    else {
        double** R = new double*[n1];

        for (int i = 0; i < n1; ++i) R[i] = new double[m2];

        for (int i = 0; i < n1; ++i)
            for (int j = 0; j < m2; ++j)
                for (int k = 0; k < n2; ++k)
                    R[i][j] += M1[i][k]*M2[k][j];

        return R;
    }
}

void free_matrix(double **M, int n) {
    for (int i = 0; i < n; ++i) delete[] M[i];
    delete[] M;
}

int main() {
    int n1, m1, n2, m2;
    double **M1, **M2;

    M1 = read_matrix(&n1, &m1);
    M2 = read_matrix(&n2, &m2);

    double **R = matrix_mul(M1, n1, m1, M2, n2, m2);

    if (R != nullptr) {
        write_matrix(R, n1, m2);
        free_matrix(R, n1);
    }

    free_matrix(M1, n1);
    free_matrix(M2, n2);
}