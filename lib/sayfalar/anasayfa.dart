import 'package:flutter/material.dart';
import 'package:instantmessage/sayfalar/akis.dart';
import 'package:instantmessage/sayfalar/ara.dart';
import 'package:instantmessage/sayfalar/duyurular.dart';
import 'package:instantmessage/sayfalar/profil.dart';
import 'package:instantmessage/sayfalar/yukle.dart';
import 'package:instantmessage/servisler/yetkilendirmeservisi.dart';
import 'package:provider/provider.dart';

class Anasayfa extends StatefulWidget {
  @override
  _AnasayfaState createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  @override
  int _aktifSayfaNo = 0;
  PageController sayfaKumandasi;

  @override
  void initState() {
    super.initState();
    sayfaKumandasi = PageController();
  }

  @override
  void dispose() {
    sayfaKumandasi.dispose();
    super.dispose();
  }
  //Ansayfadan çıkış yapılırken dispose ile kumanda kapanacak.

  Widget build(BuildContext context) {
    String aktifKullaniciId =
        Provider.of<YetkilendirmeServisi>(context, listen: false)
            .aktifKullaniciId;

    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        //Kaydırarak sayfa değiştirme özelliğini kapadık.
        onPageChanged: (acilanSayfaNo) {
          _aktifSayfaNo = acilanSayfaNo;
        },
        //Sayfa kayınca da Navigatörün değişmesini sağlıyor.
        controller: sayfaKumandasi,
        children: <Widget>[
          Akis(),
          Ara(),
          Yukle(),
          Duyurular(),
          Profil(
            profilSahibiId: aktifKullaniciId,
          )
        ],
      ),
      //Her butona takladığımızda farklı sayfaların görünmesini sağlayacağız.
      //Pageview içerisine eklenen her widgetı farklı sayfada gösterir.
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _aktifSayfaNo,
        //Tıklanan sayfayı currentIndex e aktarır.
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey[600],
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Akış"),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Keşfet"),
          BottomNavigationBarItem(
              icon: Icon(Icons.file_upload), label: "Yükle"),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: "Duyurular"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
        onTap: (secilenSayfaNo) {
          setState(() {
            _aktifSayfaNo = secilenSayfaNo;
            sayfaKumandasi.jumpToPage(secilenSayfaNo);
            //jump atlamak demek sayfalara atlayacak kumanda ile çalışacak.
          });
        },
      ),
    );
  }
}
