# broetchenservice

Eine App mit der Schüler Brötchen bestellen können

## Developer Guideline

Es gibt eigentlich nur wenig Regeln. Commitet lieber wenig, dafür oft, anstatt selten und viel. So sparen wir uns Merge Konflikte. Außerdem wäre es gut, wenn wir nicht an der selben Datei arbeiten, Absprachen wären dafür gut.

## Firebase

Der Benutzer kann sich über Google durch Firebase anmelden. Siehe dazu ```googleSignInProvider.dart``` Klasse. Wenn ihr die Daten des Nutzer haben wollt, könnt ihr das wie folgt:
``` Dart
import 'package:firebase_auth/firebase_auth.dart';

...
var user = FirebaseAuth.instance.currentUser;
var profilbild = user.photoURL;  

```

## Geplante Features
 
* Account balance wird oben in der AppBar angezeigt
* Der Benutzer kann Daueraufträge einrichten und beenden
* Alle Bestellungen des Nutzers werden angezeigt
* Nutzer kann Theme in Einstellungen wechseln
* Zahlungslink zu meinem PayPal
* Admin hat eigene Schaltfläche, wo er beispielsweise Guthaben aufladen kann

## Was noch getan werden muss

* Frontend entwickeln
* Firebase Datenbank aufsetzen
* Datenbankschema erstellen
* Bestellung wird in Bestellung-tabelle geschrieben, aber noch nicht in user_order (Hilfstabelle). Dafür müssen Bestellungen aber erstmal indiziert werden (Aufsteigende Bestellnummer bekommen)
* Front end Bestellungen mit Backend Bestellungen verbinden

## Realtime Database 

### Code Beispiel

```Dart
  final database = FirebaseDatabase.instance.ref();

Widget build(BuildContext context) {
    final dailySpecial = database.child('/produkte/');
    ...
    dailySpecial
        .set({'normalesBroetchen': 0.3})
        .then((value) => print("Erfolgreich geschrieben")) //Wird ausgeführt nachdem geschrieben wurde, sonst nicht
        .catchError((onError) => print(onError));
```

[Gutes Video für Realtime Database](https://www.youtube.com/watch?v=sXBJZD0fBa4&t)

### Regeln

Queries werden am Anfang und Ende mit "/" geschrieben:

~database.child('produkte');~
**database.child('/produkte/');**

Beides funktioniert, lasst uns trotzdem auf eins einiges

## Bestellungen abspeichern

Um Bestellungen abzuspeichern werden zwei Klassen verwendet. ```SingleOrder``` und ```WholeOrder```. ```WholeOrder``` muss eine Liste aus  ```SingleOrder``` übergeben werden. Die ```WholeOrder``` wird dann in ```WriteToDB.writeOrder``` übergeben.^

```Dart
    //Create SingleOrder List
    List<SingleOrder> sol = [
      new SingleOrder("normalesbroetchen", 3, 0.3),
      new SingleOrder("kornerbroetchen", 1, 0.8)
    ];

    //Create WholeOrder Object which sets userID and Value
    WholeOrder wo = new WholeOrder(sol);

    //Write Whole Order to DB
    writeToDB().writeOrder(wo);
```

![Klassendiagramm Bestellung](/db_model_writeorder.png?raw=true "Klassendiagramm Bestellung")