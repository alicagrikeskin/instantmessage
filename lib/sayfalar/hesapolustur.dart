import 'package:flutter/material.dart';
import 'package:instantmessage/modeller/kullanici.dart';
import 'package:instantmessage/servisler/firestoreservisi.dart';
import 'package:instantmessage/servisler/yetkilendirmeservisi.dart';
import 'package:provider/provider.dart';

class HesapOlustur extends StatefulWidget {
  @override
  _HesapOlusturState createState() => _HesapOlusturState();
}

class _HesapOlusturState extends State<HesapOlustur> {
  bool yukleniyor = false; //Yukleniyor ikonu.
  final _formAnahtari = GlobalKey<FormState>();
  final _scaffoldAnahtari = GlobalKey<FormState>();
  //Formun anahtarlarını çalıştırabilmek için form anahtarı ekledik.
  String kullaniciAdi, email, sifre;
  // Değişkenlerimizi/niteliklerimizi tanımladık.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldAnahtari,
      appBar: AppBar(
        title: Text("Hesap Oluştur"),
      ),
      body: ListView(
        children: <Widget>[
          yukleniyor
              ? LinearProgressIndicator()
              : SizedBox(
                  height: 0.0,
                ),
          //Doğrusal Yükleniyor İkonumuzu LinearProgressIndicator ile tanımladık.
          //Soru işareti tek satırlık if sorgumuz ancak Listboxa boş değeer
          //giremeceyeğimiz için SizedBox ekledilk içi boş.
          SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
                key: _formAnahtari, // Anahtarı forma tanıttık.
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      //Yazı yazma alanı ekledik.
                      autocorrect:
                          true, //Klavyenin yazıyı otomatik tamamlamasına yarar.

                      decoration: InputDecoration(
                        // Yazı yazma alanını tasarlamak için decoration ekledik.
                        hintText: "Kullanıcı Adını Giriniz.",
                        labelText: "Kullanıcı Adı:",
                        errorStyle: TextStyle(
                            fontSize:
                                16.0), //Hata mesajımızın yazı boyutunu değiştirdik.
                        prefixIcon: Icon(Icons
                            .person), //prefixIcon ile simgelerimizi ekledik.
                      ),
                      validator: (girilenDeger) {
                        //Validatör doğrulayıcı demektir.
                        if (girilenDeger.isEmpty)
                        // Girilen Değer boşsa True değeri döndürüyor is Empty.
                        {
                          return "Kullanıcı Adı alanı boş bırakılamaz!";
                        } else if (girilenDeger.trim().length < 4 ||
                            girilenDeger.trim().length > 13) {
                          return "Girilen değer en az 4 en fazla 13 karakter olabilir.";
                        }
                        return null; // Eğer boş değilse if' değil retun e gelecek.
                      },
                      //  onSaved: (girilenDeger) {kullaniciAdi = girilenDeger;},
                      onSaved: (girilenDeger) => kullaniciAdi = girilenDeger,
                      //Kayıt işlerimizi yapan fonksiyonumuz onSaved.
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      //Yazı yazma alanı ekledik.
                      autocorrect:
                          true, //Klavyenin yazıyı otomatik tamamlamasına yarayam
                      keyboardType: TextInputType
                          .emailAddress, // @ simgesinin klavyede çıkmasını sağlamakta.

                      decoration: InputDecoration(
                        // Yazı yazma alanını tasarlamak için decoration ekledik.
                        hintText: "E-Posta Adresinizi Giriniz.",
                        labelText: "E-Posta:",
                        errorStyle: TextStyle(
                            fontSize:
                                16.0), //Hata mesajımızın yazı boyutunu değiştirdik.
                        prefixIcon: Icon(
                            Icons.mail), //prefixIcon ile simgelerimizi ekledik.
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
                      //Epostayı, email değişkenine kaydedecek.
                    ),
                    SizedBox(
                      height: 10.0,
                    ), //Boşluk verdik.
                    TextFormField(
                      obscureText:
                          true, // Şifre alanına girilen yazının gizli kalmasını sağlamakta.
                      //Yazı yazma alanı ekledik.
                      decoration: InputDecoration(
                        // Yazı yazma alanını tasarlamak için decoration ekledik.
                        hintText: "Şifrenizi Giriniz.",
                        labelText: "Şifre:",
                        //Yazı yazma alanının içerisine metin yazdık hintText ile.
                        errorStyle: TextStyle(
                            fontSize:
                                16.0), //Hata mesajımızın yazı boyutunu değiştirdik.
                        prefixIcon: Icon(
                            Icons.lock), //prefixIcon ile simgelerimizi ekledik.
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
                      //Şifreyi sifre değişkenine kaydedecek.
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        //ElevatedButtonu 1. çocuk olarak ekliyoruz.
                        onPressed: _kullaniciOlustur,
                        //Hesapoluştur sayfasına yönlendirme yapacak.
                        child: Text(
                          "Hesap Oluştur", // Butonun içerisine Hesap oluştur yazıyoruz.
                          style: TextStyle(
                            //Metinin stilini değiştiriyoruz.
                            fontSize: 20, //Fonstun sizeını belirledik.
                            fontWeight: FontWeight.bold, // Yazıyı kalın yaptık.
                            color: Colors
                                .white, // Yazı rengini beyaz olarak belirledik.
                          ),
                        ),
                        style: (ElevatedButton.styleFrom(
                          //Butona renk verdil.
                          primary: Colors.blueAccent[200],
                        )),
                      ),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  void _kullaniciOlustur() async {
    final _yetkilendirmeServisi =
        Provider.of<YetkilendirmeServisi>(context, listen: false);
    var _formState = _formAnahtari.currentState;

    if (_formState.validate()) {
      //Girilen Bilgilerin geçerli olup olmadığını kontrol ediyor.
      _formState.save();
      setState(() {
        yukleniyor = true;
      });
      try {
        //İşlemi çalıştıracak hata alırsa catchye geçecek.
        Kullanici kullanici =
            await _yetkilendirmeServisi.mailIleKayit(email, sifre);
        //await özlliğini kullanmamızın nedeni gerçekleşmeden Navigatör önceki
        //sayfaya atmasın diye.
        if (kullanici != null) {
          //Girilen değer boş değilse.
          FireStoreServisi().kullaniciOlustur(
              id: kullanici.id, email: email, kullaniciAdi: kullaniciAdi);
        }
        Navigator.pop(context); //Önceki sayfaya atıyor.
      } catch (hata) //catch yakalamak demek hata olursa buraya gelecek.
      {
        setState(() {
          yukleniyor = false;
        });
        uyariGoster(hataKodu: hata.code);
      }
    }
  }

  uyariGoster({hataKodu}) {
    String hataMesaji;
    if (hataKodu == "invalid-email") {
      hataMesaji = "Girdiğiniz E-Posta Adresi Geçersizdir.";
    } else if (hataKodu == "email-already-in-use") {
      hataMesaji = "Girdiğiniz Mail Adresi Zaten Kulllanımda.";
    } else if (hataKodu == "weak-password") {
      hataMesaji = "Tahmin Edilmesi Daha Zor Bir Şifre Tercih Edin.";
    }

    var snackBar = SnackBar(content: Text(hataMesaji));
    //_scaffoldAnahtari.currentState.showSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
