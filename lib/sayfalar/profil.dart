import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:instantmessage/modeller/gonderi.dart';
import 'package:instantmessage/modeller/kullanici.dart';
import 'package:instantmessage/sayfalar/profiliduzenle.dart';
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
  String _aktifKullaniciId;
  Kullanici _profilSahibi;
  bool _takipEdildi = false;

  _takipciSayisiGetir() async {
    int takipciSayisi =
        await FireStoreServisi().takipciSayisi(widget.profilSahibiId);
    if (mounted) {
      setState(() {
        _takipci = takipciSayisi;
      });
    }
  }

  _takipEdilenSayisiGetir() async {
    int takipEdilenSayisi =
        await FireStoreServisi().takipEdilenSayisi(widget.profilSahibiId);
    if (mounted) {
      setState(() {
        _takipEdilen = takipEdilenSayisi;
      });
    }
  }

  _gonderileriGetir() async {
    List<Gonderi> gonderiler =
        await FireStoreServisi().gonderileriGetir(widget.profilSahibiId);
    if (mounted) {
      if (mounted) {
        setState(() {
          _gonderiler = gonderiler;
          _gonderiSayisi = _gonderiler.length;
        });
      }
    }
  }

  _takipKontrol() async {
    bool takipVarMi = await FireStoreServisi().takipKontrol(
        profilSahibiId: widget.profilSahibiId,
        aktifKullaniciId: _aktifKullaniciId);

    setState(() {
      _takipEdildi = takipVarMi;
    });
  }

  @override
  void initState() {
    super.initState();
    _takipciSayisiGetir();
    _takipEdilenSayisiGetir();
    _gonderileriGetir();
    _aktifKullaniciId =
        Provider.of<YetkilendirmeServisi>(context, listen: false)
            .aktifKullaniciId;
    _takipKontrol();
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
          widget.profilSahibiId == _aktifKullaniciId
              ? IconButton(
                  icon: Icon(Icons.exit_to_app, color: Colors.black),
                  onPressed: _cikisYap)
              : SizedBox(
                  height: 0.0,
                )
        ],
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: FutureBuilder<Object>(
          future: FireStoreServisi().kullaniciGetir(widget.profilSahibiId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            _profilSahibi = snapshot.data;
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
          //??htiyac??n kadar yer kapla.
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
          //Izgara ??eklinde g??stermek i??in.
          crossAxisCount: 3,
          shrinkWrap: true,
          mainAxisSpacing: 2.0,
          crossAxisSpacing: 2.0,
          childAspectRatio: 1.0,
          //shrink d??r??m demek kullanmad??????m??z alanlar??n ??zerini GridView in kapatmamas?? i??in diyoruz.
          physics: NeverScrollableScrollPhysics(),
          //Kayd??rma Sorunumuzu ????z??yor.
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
        // Elemanlar?? Sola Hizalamak i??in.
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
                //Yatay eksende t??m alan?? kaplamas?? i??in kulland??k.
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _sosyalSayaclar(baslik: "G??nderiler", sayi: _gonderiSayisi),
                    _sosyalSayaclar(baslik: "Takip??i", sayi: _takipci),
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
          widget.profilSahibiId == _aktifKullaniciId
              ? _profiliDuzenleButon()
              : _takipButonu(),
        ],
      ),
    );
  }

  Widget _takipButonu() {
    return _takipEdildi ? _takiptenCikButonu() : _takipEtButonu();
  }

  Widget _takipEtButonu() {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(),
          onPressed: () {
            FireStoreServisi().takipEt(
                profilSahibiId: widget.profilSahibiId,
                aktifKullaniciId: _aktifKullaniciId);
            setState(() {
              _takipEdildi = true;
              _takipci = _takipci + 1;
            });
          },
          child: Text(
            "Takip Et",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );
  }

  Widget _takiptenCikButonu() {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          FireStoreServisi().takiptenCik(
              profilSahibiId: widget.profilSahibiId,
              aktifKullaniciId: _aktifKullaniciId);
          setState(() {
            _takipEdildi = false;
            _takipci = _takipci - 1;
          });
        },
        child:
            Text("Takipten ????k", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _profiliDuzenleButon() {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfiliDuzenle(
                          profil: _profilSahibi,
                        )));
          },
          child: Text("Profili D??zenle")),
    );
  }

  Widget _sosyalSayaclar({String baslik, int sayi}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      //Dikey eksende ortalad??k.
      crossAxisAlignment: CrossAxisAlignment.center,
      //Yatay eksende hizalad??k.
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
