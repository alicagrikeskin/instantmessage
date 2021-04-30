import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageServisi {
  Reference _storage = FirebaseStorage.instance.ref();
  String resimId;

  Future<String> gonderiResmiYukle(File resimDosyasi) async {
    resimId = Uuid().v4(); //Eşsiz idler oluşturuyor, Uuid.
    UploadTask yuklemeYoneticisi = _storage
        .child("resimler/gonderiler/gonderi_$resimId.jpg")
        .putFile(resimDosyasi);
    TaskSnapshot snapshot = await yuklemeYoneticisi;
    String yuklenenResimUrl = await snapshot.ref.getDownloadURL();
    return yuklenenResimUrl;
  }
}
