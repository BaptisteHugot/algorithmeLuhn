/**
 * @file main.dart
 * @brief Exemple d'application utilisant Flutter
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'algorithmeLuhn.dart';

/**
 * Fonction principale du programme
 */
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Home()
    );
  }
}

class Home extends StatelessWidget {
  TextEditingController controleurNombreAVerifier = TextEditingController();

  /**
   * Fonction servant à afficher une fenêtre d'alerte
   * @param context Contexte
   * @param message Le message qui sera affiché dans la fenêtre d'alerte
   */
  Future showAlert(BuildContext context, String message) async {
    return showDialog(
        context: context,
        builder: (_) => new AlertDialog(
          title: new Text(message),
          actions: <Widget>[
            new FlatButton(onPressed: () => Navigator.pop(context), child: new Text('OK'))
          ],
        )

    );
  }

  /**
   * Fonction exécutée lorsque l'utilisateur clique sur le bouton "Vérifiez"
   * @return la phrase qui sera affichée à l'utilisateur dans la fenêtre d'alerte
   */
  String actionVerification() {
    String nombreAVerifier = controleurNombreAVerifier.text;

    if(nombreAVerifier.isEmpty){
      return "Veuillez entrer un nombre.";
    }else if(sommeControleLuhn(nombreAVerifier)){
      return "Le numéro entré est valide.";
    } else return "Le numéro entré n\'est pas valide.";
  }

  /**
   * Fonction exécutée lorsque l'utilisateur clique sur le bouton "Effacez"
   */
  void actionEffacement() {
    controleurNombreAVerifier.text = '';
  }

  /**
   * Définit le widget qui sera affiché
   * @param context Contexte
   */
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Algorithme de Luhn',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Algorithme de Luhn'),
        ),
        body: Center(
          child: Column(

            children: [
              Text('Entrez le nombre que vous souhaitez vérifier :'),
              TextField(controller: controleurNombreAVerifier,
                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Nombre à vérifier'
                ),
                onChanged: (v) => controleurNombreAVerifier.text = v,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(
                    onPressed: () => showAlert(context, actionVerification()),
                    child: const Text('Vérifiez'),
                  ),
                  RaisedButton(
                    onPressed: () => actionEffacement(),
                    child: const Text('Effacez'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}