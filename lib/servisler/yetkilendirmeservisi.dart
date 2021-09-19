import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:instantmessage/modeller/kullanici.dart';

class YetkilendirmeServisi {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String aktifKullaniciId;

  Kullanici _kullaniciOlustur(User kullanici) {
    //USer objesi göndereceğiz Kullanıcı objesi alacağız bu methotdan.
    return kullanici == null ? null : Kullanici.firebasedenUret(kullanici);
  }

  Stream<Kullanici> get durumTakipcisi {
    //Güvenlik merkezinin yaptığı yayındaki firebase user obbjesini kullanıcı oluştura göndererek, kullancıı verisine çevirip tekrar yayınlıyor.
    return _firebaseAuth.authStateChanges().map(_kullaniciOlustur);
  }

  Future<Kullanici> mailIleKayit(String eposta, String sifre) async {
    //Kullanıcıdan alacağımız mail ve sişfreyi mailIleKayit metoduna gönderecek.
    var girisKarti = await _firebaseAuth.createUserWithEmailAndPassword(
        //Gönderdiğimiz veriler ile Firebase bilgisi oluşturulacak.
        email: eposta,
        password: sifre);
    return _kullaniciOlustur(girisKarti.user);
    //Bize kullanıcı objesi döndürecek.
  }

  Future<Kullanici> mailIleGiris(String eposta, String sifre) async {
    //Kullanıcıdan alacağımız mail ve sişfreyi mailIleGiris metoduna gönderecek.
    var girisKarti = await _firebaseAuth.signInWithEmailAndPassword(
        //Kullanıcının giriş yapabilmesini sağlayan metod.
        email: eposta,
        password: sifre);
    return _kullaniciOlustur(girisKarti.user);
    //Bize kullanıcı objesi döndürecek.
  }

  Future<void> cikisYap() {
    //Çıkış yapmamızı sağlayacak metod.
    //Metod çalıştığında bize Future içerisinde bir değer döndürmeyecek.
    return _firebaseAuth.signOut();
  }

  Future<void> sifremiSifirla(String eposta) async {
    await _firebaseAuth.sendPasswordResetEmail(email: eposta);
  }

  Future<Kullanici> googleIleGiris() async {
    GoogleSignInAccount googleHesabi = await GoogleSignIn().signIn();
    GoogleSignInAuthentication googleYetkiKartim =
        await googleHesabi.authentication;
    AuthCredential sifresizGirisBelgesi = GoogleAuthProvider.credential(
        idToken: googleYetkiKartim.idToken,
        accessToken: googleYetkiKartim.accessToken);
    UserCredential girisKarti =
        await _firebaseAuth.signInWithCredential(sifresizGirisBelgesi);
    return _kullaniciOlustur(girisKarti.user);
  }
}
