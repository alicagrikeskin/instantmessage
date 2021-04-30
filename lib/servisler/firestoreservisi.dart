import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instantmessage/modeller/gonderi.dart';
import 'package:instantmessage/modeller/kullanici.dart';

class FireStoreServisi {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final DateTime zaman = DateTime.now(); //Tarih ve Zaman verisi veriyor.

  Future<void> kullaniciOlustur({id, email, kullaniciAdi, fotoUrl = ""}) async {
    await _firestore.collection("kullanicilar").doc(id).set({
      "kullaniciAdi": kullaniciAdi,
      "email": email,
      "fotoUrl": fotoUrl,
      "hakkinda": "",
      "olusturulmaZamani": zaman
    });
  }

//kullaniciGetir daha önce Google'da böyle bir kayıt var mı onu kontrol ediyor
//Eğer böyle bir döküman yoksa Kullanici.dokumandanuret çalışacak.
  Future<Kullanici> kullaniciGetir(id) async {
    DocumentSnapshot doc =
        await _firestore.collection("kullanicilar").doc(id).get();
    if (doc.exists) {
      Kullanici kullanici = Kullanici.dokumandanUret(doc);
      return kullanici;
    }
    return null;
  }

  Future<int> takipciSayisi(kullaniciId) async {
    QuerySnapshot snapshot = await _firestore
        .collection("takipciler")
        .doc(kullaniciId)
        .collection("kullanicininTakipcileri")
        .get();
    return snapshot.docChanges.length;
  }

  Future<int> takipEdilenSayisi(kullaniciId) async {
    QuerySnapshot snapshot = await _firestore
        .collection("takipedilenler")
        .doc(kullaniciId)
        .collection("kullanicininTakipleri")
        .get();
    return snapshot.docChanges.length;
  }

  Future<void> gonderiOlustur(
      {gonderiResmiUrl, aciklama, yayinlayanId, konum}) async {
    await _firestore
        .collection("gonderiler")
        .doc(yayinlayanId)
        .collection("kullaniciGonderileri")
        .add({
      "gonderiResmiUrl": gonderiResmiUrl,
      "aciklama": aciklama,
      "yayinlayanId": yayinlayanId,
      "begeniSayisi": 0,
      "konum": konum,
      "olusturulmaZamani": zaman
    });
  }

  Future<List<Gonderi>> gonderileriGetir(kullaniciId) async {
    QuerySnapshot snapshot = await _firestore
        .collection("gonderiler")
        .doc(kullaniciId)
        .collection("kullaniciGonderileri")
        .orderBy("olusturulmaZamani", descending: true)
        //descending azalan sıra ile getirme.
        .get();
    List<Gonderi> gonderiler =
        snapshot.docs.map((doc) => Gonderi.dokumandanUret(doc)).toList();
    //Her bir dökümanı göstermek için map kullanacağız.
    return gonderiler;
  }
}
