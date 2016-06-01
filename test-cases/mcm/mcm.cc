int mcd(int a, int b) {
    int r;
    while (b != 0) {
        r = a%b;
        a = b;
        b = r;
    }
    return a;
}
        
int mcm (int a, int b) {
    int mcm2 = a/mcd(a, b);
    return (b*mcm2);
}
    
    
int main() {
    int x;
    cin >> x;
    while (x != 0) {
        int y;
        cin >> y;
        int r = y;
        for (int i = 1; i < x; ++i) {
            cin >> y;
            r = mcm(r, y);
        }
        cout << r << endl;
        cin >> x;
    }
}