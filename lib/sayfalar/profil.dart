import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:instantmessage/modeller/gonderi.dart';
import 'package:instantmessage/modeller/kullanici.dart';
import 'package:instantmessage/servisler/firestoreservisi.dart';
import 'package:instantmessage/servisler/yetkilendirmeservisi.dart';
import 'package:instantmessage/widgetlar/gonderikarti.dart';
import 'package:provider/provider.dart';

class Profil extends StatefulWidget {
  final String profilSahibiId;

  const Profil({Key key, this.profilSahibiId}) : super(key: key);

  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  int _gonderiSayisi = 0;
  int _takipci = 0;
  int _takipEdilen = 0;
  List<Gonderi> _gonderiler = [];
  String gonderiStili = "liste";

  _takipciSayisiGetir() async {
    int takipciSayisi =
        await FireStoreServisi().takipciSayisi(widget.profilSahibiId);
    setState(() {
      _takipci = takipciSayisi;
    });
  }

  _takipEdilenSayisiGetir() async {
    int takipEdilenSayisi =
        await FireStoreServisi().takipEdilenSayisi(widget.profilSahibiId);
    setState(() {
      _takipEdilen = takipEdilenSayisi;
    });
  }

  _gonderileriGetir() async {
    List<Gonderi> gonderiler =
        await FireStoreServisi().gonderileriGetir(widget.profilSahibiId);
    if (mounted) {
      setState(() {
        _gonderiler = gonderiler;
        _gonderiSayisi = _gonderiler.length;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _takipciSayisiGetir();
    _takipEdilenSayisiGetir();
    _gonderileriGetir();
  }

  /*List<Gonderi> _gonderiler = [];
  String gonderiStili = "liste";
  String _aktifKullaniciId;
  Kullanici _profilSahibi;
  bool _takipEdildi = false;*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profil",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.grey[100],
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.exit_to_app, color: Colors.black),
              onPressed: _cikisYap)
        ],
      ),
      body: FutureBuilder<Object>(
          future: FireStoreServisi().kullaniciGetir(widget.profilSahibiId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            return ListView(
              children: <Widget>[
                _profilDetaylari(snapshot.data),
                _gonderileriGoster(snapshot.data),
              ],
            );
          }),
    );
  }

  Widget _gonderileriGoster(Kullanici profilData) {
    if (gonderiStili == "liste") {
      return ListView.builder(
          shrinkWrap: true,
          //İhtiyacın kadar yer kapla.
          primary: false,
          itemCount: _gonderiler.length,
          itemBuilder: (context, index) {
            return GonderiKarti(
              gonderi: _gonderiler[index],
              yayinlayan: profilData,
            );
          });
    } else {
      List<GridTile> fayanslar = [];
      _gonderiler.forEach((gonderi) {
        fayanslar.add(_fayansOlustur(gonderi));
      });

      return GridView.count(
          //Izgara şeklinde göstermek için.
          crossAxisCount: 3,
          shrinkWrap: true,
          mainAxisSpacing: 2.0,
          crossAxisSpacing: 2.0,
          childAspectRatio: 1.0,
          //shrink dürüm demek kullanmadığımız alanların üzerini GridView in kapatmaması için diyoruz.
          physics: NeverScrollableScrollPhysics(),
          //Kaydırma Sorunumuzu Çözüyor.
          children: fayanslar);
    }
  }

  GridTile _fayansOlustur(Gonderi gonderi) {
    return GridTile(
        child: Image.network(
      gonderi.gonderiResmiUrl,
      fit: BoxFit.cover,
    ));
  }

  Widget _profilDetaylari(Kullanici profilData) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // Elemanları Sola Hizalamak için.
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.grey[300],
                radius: 50.0,
                backgroundImage: profilData.fotoUrl.isNotEmpty
                    ? NetworkImage(profilData.fotoUrl)
                    : AssetImage("assets/images/kyok.png"),
              ),
              Expanded(
                //Yatay eksende tüm alanı kaplaması için kullandık.
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _sosyalSayaclar(baslik: "Gönderiler", sayi: _gonderiSayisi),
                    _sosyalSayaclar(baslik: "Takipçi", sayi: _takipci),
                    _sosyalSayaclar(baslik: "Takip", sayi: _takipEdilen),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            profilData.kullaniciAdi,
            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(profilData.hakkinda),
          SizedBox(
            height: 25.0,
          ),
          _profiliDuzenleButton(),
        ],
      ),
    );
  }

  Widget _profiliDuzenleButton() {
    return Container(
      width: double.infinity,
      child: ElevatedButton(onPressed: () {}, child: Text("Profili Düzenle")),
    );
  }

  Widget _sosyalSayaclar({String baslik, int sayi}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      //Dikey eksende ortaladık.
      crossAxisAlignment: CrossAxisAlignment.center,
      //Yatay eksende hizaladık.
      children: <Widget>[
        Text(
          sayi.toString(),
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 2.0,
        ),
        Text(
          baslik,
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
      ],
    );
  }

  void _cikisYap() {
    Provider.of<YetkilendirmeServisi>(context, listen: false).cikisYap();
  }
}
