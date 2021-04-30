import 'package:flutter/material.dart';
import 'package:instantmessage/modeller/gonderi.dart';
import 'package:instantmessage/modeller/kullanici.dart';

class GonderiKarti extends StatefulWidget {
  final Gonderi gonderi;
  final Kullanici yayinlayan;

  const GonderiKarti({Key key, this.gonderi, this.yayinlayan})
      : super(key: key);
  @override
  _GonderiKartiState createState() => _GonderiKartiState();
}

class _GonderiKartiState extends State<GonderiKarti> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Column(
          children: <Widget>[
            _gonderiBasligi(),
            _gonderiResmi(),
            _gonderiAlt(),
          ],
        ));
  }

  Widget _gonderiBasligi() {
    return ListTile(
      leading: Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: CircleAvatar(
          backgroundColor: Colors.blue,
          backgroundImage: widget.yayinlayan.fotoUrl.isNotEmpty
              ? NetworkImage(widget.yayinlayan.fotoUrl)
              : AssetImage("assets/images/hayalet.png"),
        ),
      ),
      title: Text(
        widget.yayinlayan.kullaniciAdi,
        style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
      ),
      trailing: IconButton(
        icon: Icon(Icons.more_vert),
        onPressed: null,
      ),
      contentPadding: EdgeInsets.all(0.0),
      //3 noktanın özelliğini kapattık daha sağda gözükecek.
    );
  }

  Widget _gonderiResmi() {
    return Image.network(
      widget.gonderi.gonderiResmiUrl,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
      fit: BoxFit.cover,
    );
  }

  Widget _gonderiAlt() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.favorite_border,
                  size: 35.0,
                ),
                onPressed: null),
            IconButton(
                icon: Icon(
                  Icons.comment,
                  size: 35.0,
                ),
                onPressed: null),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text("${widget.gonderi.begeniSayisi} beğeni",
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              )),
        ),
        SizedBox(
          height: 2.0,
        ),
        widget.gonderi.aciklama.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: RichText(
                  text: TextSpan(
                      text: widget.yayinlayan.kullaniciAdi + " ",
                      style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      children: [
                        TextSpan(
                            text: widget.gonderi.aciklama,
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 14.0,
                            ))
                      ]),
                ),
              )
            : SizedBox(
                height: 0.0,
              )
      ],
    );
  }
}
