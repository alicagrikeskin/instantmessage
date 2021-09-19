import 'package:flutter/material.dart';
import 'package:instantmessage/modeller/kullanici.dart';
import 'package:instantmessage/sayfalar/duyurular.dart';
import 'package:instantmessage/sayfalar/hakkinda.dart';
import 'package:instantmessage/sayfalar/hesapolustur.dart';
import 'package:instantmessage/sayfalar/sifremiunuttum.dart';
import 'package:instantmessage/servisler/firestoreservisi.dart';
import 'package:instantmessage/servisler/yetkilendirmeservisi.dart';
import 'package:provider/provider.dart';

class GirisSayfasi extends StatefulWidget {
  @override
  _GirisSayfasiState createState() => _GirisSayfasiState();
}

class _GirisSayfasiState extends State<GirisSayfasi> {
  final _formAnahtari = GlobalKey<FormState>();
  bool yukleniyor = false;
  String email, sifre;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        _sayfaElemanlari(),
        _yuklemeAnimasyonu(), //2. çocuk olarak ekledik.
      ],
    ));
  }

  Widget _yuklemeAnimasyonu() {
    if (yukleniyor) {
      return Center(child: CircularProgressIndicator());
    } else {
      return SizedBox(
        height: 0.0,
      );
    }
  }

  Widget _sayfaElemanlari() {
    return Form(
      key: _formAnahtari,
      child: ListView(
        padding: EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            top: 60.0), // Logonun üsten boşluklu olmasını sağladık.
        children: <Widget>[
          FlutterLogo(
            //Flutter logosunu ekledik, Logo 90 px.
            size: 90.0,
          ),
          SizedBox(
            height: 80,
          ),
          TextFormField(
            //Yazı yazma alanı ekledik.
            autocorrect: true, //Klavyenin yazıyı otomatik tamamlamasına yarayam
            keyboardType: TextInputType
                .emailAddress, // @ simgesinin klavyede çıkmasını sağlamakta.

            decoration: InputDecoration(
              // Yazı yazma alanını tasarlamak için decoration ekledik.
              hintText: "E-Posta Adresinizi Giriniz.",
              errorStyle: TextStyle(
                  fontSize: 16.0), //Hata mesajımızın yazı boyutunu değiştirdik.
              prefixIcon:
                  Icon(Icons.mail), //prefixIcon ile simgelerimizi ekledik.
            ),
            validator: (girilenDeger) {
              //Validatör doğrulayıcı demektir.
              if (girilenDeger.isEmpty)
              // Girilen Değer boşsa True değeri döndürüyor is Empty.
              {
                return "E-Posta alanı boş bırakılamaz!";
              } else if (!girilenDeger.contains(
                  "@")) //@ sembolü olup olmadığını kontrol ediyoruz.Contains bunu aratıyor.
              {
                return "Girilen değer mail formatında olmalıdır!";
              }
              return null; // Eğer boş değilse if' değil retun e gelecek.
            },
            onSaved: (girilenDeger) => email = girilenDeger,
          ),
          SizedBox(
            height: 40.0,
          ), //Boşluk verdik.
          TextFormField(
            obscureText:
                true, // Şifre alanına girilen yazının gizli kalmasını sağlamakta.
            //Yazı yazma alanı ekledik.
            decoration: InputDecoration(
              // Yazı yazma alanını tasarlamak için decoration ekledik.
              hintText: "Şifrenizi Giriniz.",
              //Yazı yazma alanının içerisine metin yazdık hintText ile.
              errorStyle: TextStyle(
                  fontSize: 16.0), //Hata mesajımızın yazı boyutunu değiştirdik.
              prefixIcon:
                  Icon(Icons.lock), //prefixIcon ile simgelerimizi ekledik.
            ),
            validator: (girilenDeger) {
              //Validatör doğrulayıcı demektir.
              if (girilenDeger.isEmpty)
              // Girilen Değer boşsa True değeri döndürüyor is Empty.
              {
                return "Şifre alanı boş bırakılamaz! ";
              } else if (girilenDeger.trim().length <
                  4) //Girilen karakterlerini sayıyoruz, boşlukları hariç tutarak.
              {
                return "Şifre 4 karakterden az olamaz! ";
              }
              return null; // Eğer boş değilse if' değil retun e gelecek.
            },
            onSaved: (girilenDeger) => sifre = girilenDeger,
          ),

          SizedBox(
            height: 40.0,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  //ElevatedButtonu 1. çocuk olarak ekliyoruz.
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => HesapOlustur()));
                  },
                  //Hesapoluştur sayfasına yönlendirme yapacak.
                  child: Text(
                    "Hesap Oluştur", // Butonun içerisine Hesap oluştur yazıyoruz.
                    style: TextStyle(
                      //Metinin stilini değiştiriyoruz.
                      fontSize: 20, //Fonstun sizeını belirledik.
                      fontWeight: FontWeight.bold, // Yazıyı kalın yaptık.
                      color:
                          Colors.white, // Yazı rengini beyaz olarak belirledik.
                    ),
                  ),
                  style: (ElevatedButton.styleFrom(
                    //Butona renk verdil.
                    primary: Colors.blueAccent[200],
                  )),
                ),
              ),
              SizedBox(
                // Butonlarımızın boyutunu yapılandırdık.
                width: 10.0,
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: _girisYap,
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
              )
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Center(child: Text("veya")),
          SizedBox(
            height: 20.0,
          ),
          Center(
              child: InkWell(
            onTap: _googleIleGiris,
            child: Text(
              "Google ile Giriş Yap",
              style: TextStyle(
                fontSize: 19.9,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
          )),
          SizedBox(
            height: 20.0,
          ),
          Center(
              child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SifremiUnuttum()));
                  },
                  child: Text("Şifremi Unutttum"))),
          SizedBox(
            height: 20.0,
          ),
          SizedBox(
            height: 50.0,
          ),
          Center(
              child: InkWell(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Hakkinda()));
            },
            child: Text(
              "Hakkında",
              style: TextStyle(
                fontSize: 13.3,
                color: Colors.grey[600],
              ),
            ),
          )),
          SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }

  void _girisYap() async {
    final _yetkilendirmeServisi =
        Provider.of<YetkilendirmeServisi>(context, listen: false);

    if (_formAnahtari.currentState.validate()) {
      _formAnahtari.currentState.save();
      //Form Anahtarının Validate parametresini çalıştırmış olduk.
      //Form Anahtarı bizim hata mesajlarımız.
      setState(() {
        yukleniyor = true;
      });
      try {
        await _yetkilendirmeServisi.mailIleGiris(email, sifre);
      } catch (hata) {
        setState(() {
          yukleniyor = false;
        });
        uyariGoster(hataKodu: hata.code());
      }
    }
  }

  void _googleIleGiris() async {
    var _yetkilendirmeServisi =
        Provider.of<YetkilendirmeServisi>(context, listen: false);

    setState(() {
      yukleniyor = true;
    });

    try {
      Kullanici kullanici = await _yetkilendirmeServisi.googleIleGiris();
      if (kullanici != null) {
        Kullanici firestoreKullanici =
            await FireStoreServisi().kullaniciGetir(kullanici.id);
        if (firestoreKullanici == null) {
          FireStoreServisi().kullaniciOlustur(
              id: kullanici.id,
              email: kullanici.email,
              kullaniciAdi: kullanici.kullaniciAdi,
              fotoUrl: kullanici.fotoUrl);
        }
        print("Kullanıcı Dökümanı Oluşturuldu.");
      }
    } catch (hata) {
      setState(() {
        yukleniyor = false;
      });
      uyariGoster(hataKodu: hata.code());
    }
  }

  uyariGoster({hataKodu}) {
    String hataMesaji;
    if (hataKodu == "user-not-found") {
      hataMesaji = "Kullanıcı Bulunamadı.";
    } else if (hataKodu == "invalid-email") {
      hataMesaji = "Girdiğiniz Mail Adresi Geçersizdir.";
    } else if (hataKodu == "wrong-password") {
      hataMesaji = "Girilen Şifre Hatalıdır.";
    } else if (hataKodu == "user-disabled") {
      hataMesaji = "Kullanıcı Engellenmiş.";
    } else {
      hataMesaji = "Belirlenemeyen Bir Hata Oluştu. $hataKodu";
    }

    var snackBar = SnackBar(content: Text(hataMesaji));
    //_scaffoldAnahtari.currentState.showSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
