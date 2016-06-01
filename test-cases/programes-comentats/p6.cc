// Aquest programa comprova que no es poden
// assignar resultats de funcions de tipus void a variables

void funcioVoid() {}
int main() {
  funcioVoid();
  	int a = funcioVoid();
}
