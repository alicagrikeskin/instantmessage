import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instantmessage/modeller/kullanici.dart';
import 'package:instantmessage/sayfalar/anasayfa.dart';
import 'package:instantmessage/sayfalar/girissayfasi.dart';
import 'package:instantmessage/servisler/yetkilendirmeservisi.dart';
import 'package:provider/provider.dart';

class Yonlendirme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _yetkilendirmeServisi =
        Provider.of<YetkilendirmeServisi>(context, listen: false);

    return StreamBuilder(
        stream: _yetkilendirmeServisi.durumTakipcisi,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          if (snapshot.hasData) {
            Kullanici aktifKullanici = snapshot.data;
            _yetkilendirmeServisi.aktifKullaniciId = aktifKullanici.id;
            return Anasayfa();
          } else {
            return GirisSayfasi();
          }
        });
  }
}
