import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'algorithmeLuhn.dart';

// Fonction servant à connaître la couleur à afficher en fonction du résultat
Color getColor(bool isValid){
  if(isValid == false){
    return Colors.red;
  }else return Colors.green;
}

// Fonction servant à afficher le bon texte en fonction du résultat
String validite(bool isValid){
  if(isValid == false){
    return "Invalide";
  }else return "Valide";
}

// Fonction principale du programme
void main() => runApp(MyApp());

// Classe de départ pour afficher l'application
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = "Validité d'un IMEI ou d'une carte bancaire";

    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: appTitle),
    );
  }
}

// Classe Stateful pour gérer la récupération et le parsing du fichier Json
class MyHomePage extends StatefulWidget{
  final String title;

  MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

// Classe d'état pour gérer la récupération et le parsing du fichier Json
class _MyHomePageState extends State<MyHomePage> {

  /// On définit les contrôleurs de texte et de formulaire
  final inputController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  /// On définit les expressions régulières
  static Pattern patternIMEI = r"^[0-9]{15}$";
  static RegExp regexIMEI = new RegExp(patternIMEI.toString());
  static Pattern patternBankCard = r"^[0-9]{16}$";
  static RegExp regexBankCard = new RegExp(patternBankCard.toString());

  bool showResult = false; /// Booléen pour afficher le résultat ou non
  String inputNumber = ""; /// Numéro entré
  bool isValid = false; /// Booléen pour savoir si le numéro entré est valide ou non

  /// Variables d'affichage de l'application
  int? _radioValue = 0;
  String _displayStartText = "";
  String _displayInputText = "";
  String _displayErrorText = "";

  /// On initialise l'état de l'application
  void initState(){
    _handleRadioValueChange(_radioValue);
    super.initState();
  }

  /// Lorsqu'on clique sur le bouton effacer
  void _erase(){
    setState((){
      showResult = false;
      inputController.text = "";
    });
  }

  /// Lorsqu'on clique sur le bouton valider
  void _validate(){
    if(_formKey.currentState!.validate()){
      setState(() {
        inputNumber = inputController.text;
        isValid = sommeControleLuhn(inputNumber);
        showResult = true;
      });
    }else{
      setState((){
        showResult = false;
      });
    }
  }

  /// Lorsqu'un bouton radio est modifié
  void _handleRadioValueChange(int? value){
    setState((){
      _radioValue = value;
      showResult = false;

      switch(_radioValue){
        case 0:
          _displayStartText = "Entrez un numéro IMEI";
          _displayInputText = "Numéro IMEI";
          _displayErrorText = "Entrez un numéro IMEI au format valide";
          break;
        case 1:
          _displayStartText = "Entrez un numéro de carte bancaire";
          _displayInputText = "Numéro de carte bancaire";
          _displayErrorText = "Entrez un numéro de carte bancaire au format valide";
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Radio(
                    value: 0,
                    groupValue: _radioValue,
                    activeColor: Colors.blue,
                      onChanged: (int? value) {
                        _handleRadioValueChange(value);
                      }
                      ),
                  Text("Numéro IMEI"),
                  Radio(
                    value: 1,
                    groupValue: _radioValue,
                    activeColor: Colors.blue,
                    onChanged: (int? value) {
                      _handleRadioValueChange(value);
                    }
                  ),
                  Text("Numéro de carte bancaire"),
                ]),
            Text(_displayStartText),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: inputController,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                        labelText: _displayInputText
                    ),
                    validator: (value){
                      if(value != null) {
                        if (value.isEmpty) {
                          return _displayStartText;
                        } else if (_radioValue == 0 && !regexIMEI.hasMatch(value)) {
                          return _displayErrorText;
                        } else
                        if (_radioValue == 1 && !regexBankCard.hasMatch(value)) {
                          return _displayErrorText;
                        }
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: 5), /// On ajoute un espacement en hauteur
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: (){
                          _validate();
                        },
                        child: Text("Valider"),
                      ),
                      SizedBox(width: 5), /// On ajoute un espacement entre les 2 boutons
                      ElevatedButton(
                        onPressed: (){
                          _erase();
                        },
                        child: Text("Effacer"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            showResult ? DataTable( /// Si un résultat doit être affiché
              columns: <DataColumn>[
                DataColumn(
                  label: Text(
                      _displayInputText
                  ),
                ),
                DataColumn(
                  label: Text(
                      "Validité"
                  ),
                ),
              ],
              rows: <DataRow>[
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text(inputNumber, style: TextStyle(color: getColor(isValid)))),
                    DataCell(Text(validite(isValid), style: TextStyle(color: getColor(isValid)))),
                  ],
                ),
              ],
            ) : SizedBox(), /// Si aucun résultat ne doit être affiché
          ],
        ),// This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}