import 'package:flutter/material.dart';
import 'package:instantmessage/servisler/yetkilendirmeservisi.dart';
import 'package:provider/provider.dart';

class SifremiUnuttum extends StatefulWidget {
  @override
  _SifremiUnuttumState createState() => _SifremiUnuttumState();
}

class _SifremiUnuttumState extends State<SifremiUnuttum> {
  bool yukleniyor = false; //Yukleniyor ikonu.
  final _formAnahtari = GlobalKey<FormState>();
  final _scaffoldAnahtari = GlobalKey<FormState>();
  //Formun anahtarlarını çalıştırabilmek için form anahtarı ekledik.
  String email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldAnahtari,
      appBar: AppBar(
        title: Text("Şifremi Sıfırla"),
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
                      height: 50.0,
                    ),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        //ElevatedButtonu 1. çocuk olarak ekliyoruz.
                        onPressed: _sifreyiSifirla,
                        //Hesapoluştur sayfasına yönlendirme yapacak.
                        child: Text(
                          "Şifremi Sıfırla", // Butonun içerisine Hesap oluştur yazıyoruz.
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

  void _sifreyiSifirla() async {
    final _yetkilendirmeServisi =
        Provider.of<YetkilendirmeServisi>(context, listen: false);
    var _formState = _formAnahtari.currentState;
    if (_formState.validate()) {
      _formState.save();
      setState(() {
        yukleniyor = true;
      });
      try {
        await _yetkilendirmeServisi.sifremiSifirla(email);
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
    if (hataKodu == "ERROR_INVALID_EMAIL") {
      hataMesaji = "Girdiğiniz E-Posta Adresi Geçersizdir.";
    } else if (hataKodu == "ERROR_USER_NOT_FOUND") {
      hataMesaji = "Bu E- Posta Adresinde Kullanıcı Bulunamıyor.";
    }
    var snackBar = SnackBar(content: Text(hataMesaji));
    //_scaffoldAnahtari.currentState.showSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
