import 'package:flutter/material.dart';
import 'package:instantmessage/sayfalar/girissayfasi.dart';

class Hakkinda extends StatefulWidget {
  @override
  _HakkindaState createState() => _HakkindaState();
}

class _HakkindaState extends State<Hakkinda> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          //Dikey eksende ortaladık.
          crossAxisAlignment: CrossAxisAlignment.center,
          //Yatay eksende hizaladık.
          children: [
            Container(
              margin: EdgeInsets.only(
                left: 50,
                right: 50,
              ),
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Bu uygulama Dr. Öğretim Üyesi Ahmet Cevahir ÇINAR tarafından yürütülen 3301456 kodlu MOBİL PROGRAMLAMA dersi kapsamında 173004020 numaralı Ali Çağrı KESKİN tarafından 30 Nisan 2021 günü yapılmıştır.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GirisSayfasi()),
                );
              },
              child: Text(
                "Giriş Yap",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: (ElevatedButton.styleFrom(
                primary: Colors.blueAccent[500],
              )),
            ),
          ],
        ),
      ),
    );
  }
}
