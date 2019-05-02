/**
 * @file algorithmeLuhn.dart
 * @brief Implémentation de l'algorithme de Luhn utilisé pour valider la véracité d'un numéro
 */

/**
 * Implémentation de l'algorithme de Luhn
 * @param nombre Le nombre que l'on souhaite tester
 * @return true si la somme de contrôle est correcte, false sinon
 */
bool sommeControleLuhn(String nombre){
	int somme = 0;
	bool alternance = false;

	for(int i = nombre.length-1;i>=0;i--){
		int n = int.parse(nombre.substring(i,i+1));
		if(alternance){
			n = 2*n;
			if(n>9){
				n = (n%10)+1;
			}
		}
		somme = somme + n;
		alternance = !alternance;
	}
	return (somme%10==0);
}