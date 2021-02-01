import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:socialapp/modeller/kullanici.dart';
import 'package:socialapp/sayfalar/hesapolustur.dart';
import 'package:socialapp/sayfalar/sifremiunuttum.dart';
import 'package:socialapp/servisler/firestoreservisi.dart';
import 'package:socialapp/servisler/yetkilendirmeservisi.dart';

class GirisSayfasi extends StatefulWidget {
  @override
  _GirisSayfasiState createState() => _GirisSayfasiState();
}

class _GirisSayfasiState extends State<GirisSayfasi> {
  final Shader linearGradient = LinearGradient(
    colors: <Color>[
      Colors.orange[100],
      Colors.orange[200],
      Colors.orange[300],
      Colors.orange[400],
      Colors.orange[500],
      Colors.orange[600],
      Colors.orange[700],
      Colors.orange[800],
    ],
  ).createShader(new Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
  final _formAnahtari = GlobalKey<FormState>();
  final _scaffoldAnahtari = GlobalKey<ScaffoldState>();
  bool yukleniyor = false;
  String email, sifre;
  SpinKitPouringHourglass spinkit;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldAnahtari,
        body: Stack(
          children: [_sayfaElemanlari(), _yuklemeAnimasyonu()],
        ));

  }

  Widget _yuklemeAnimasyonu() {
    if (yukleniyor) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Center();
    }
  }
  Widget _sayfaElemanlari() {
    return Form(
      key: _formAnahtari,
      child: ListView(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 60.0),
        children: [
          Image(
            image: AssetImage('assets/images/logo_emo.png'),
            height: 90,
          ),
          SizedBox(height: 20.0),
          Center(
            child: Text(
              "MemRem",
              style: new TextStyle(
                  fontSize: 60.0,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()..shader = linearGradient),
            ),
          ),
          //Center(child:Text("Anılarınızı Yaşatın...",style: new TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),),),
          //FlutterLogo(
          // size: 90.0,
          //         ),
          SizedBox(
            height: 80.0,
          ),
          TextFormField(
            autocorrect: true,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hoverColor: Colors.black,
              hintText: "Email adresinizi giriniz",hintStyle: TextStyle(color: Colors.black),
              errorStyle: TextStyle(fontSize: 16.0),
              prefixIcon: Icon(Icons.email,),
            ),
            validator: (girilenDeger) {
              if (girilenDeger.isEmpty) {
                return "Email alanı boş bırakılamaz!";
              } else if (!girilenDeger.contains("@")) {
                return "Girilen değer mail formatında olmalı!";
              }
              return null;
            },
            onSaved: (girilenDeger) => email = girilenDeger,
          ),
          SizedBox(
            height: 40,
          ),
          TextFormField(
            obscureText: true,
            decoration: InputDecoration(
              hintText: "Şifrenizi giriniz",hintStyle: TextStyle(color: Colors.black),
              errorStyle: TextStyle(fontSize: 16.0),
              prefixIcon: Icon(Icons.lock,),
            ),
            validator: (girilenDeger) {
              if (girilenDeger.isEmpty) {
                return "Şifre alanı boş bırakılamaz!";
              } else if (girilenDeger.trim().length < 4) {
                return "Şifre 4 karakterden az olamaz!";
              }
              return null;
            },
            onSaved: (girilenDeger) => sifre = girilenDeger,
          ),
          SizedBox(
            height: 40,
          ),
          Row(
            children: [
              Expanded(
                child: FlatButton(
                  height: 45,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => HesapOlustur()));
                  },

                  child: Text(
                    "Hesap Oluştur",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: null,
                    ),
                  ),
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(10.0),
                   //side: BorderSide(color: Colors.black)
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: FlatButton(
                  height: 45,
                  onPressed: _girisYap,
                  child: Text(
                    "Giriş Yap",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 21,
                      fontWeight: null,
                    ),
                  ),
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    //side: BorderSide(color: Colors.black)
                  ),

                ),
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Center(child: Text("veya",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),)),
          SizedBox(
            height: 20.0,
          ),
          new Container(
            height: 45,
            margin: EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
            child: new RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)
              ),
                padding: EdgeInsets.only(top: 3.0,bottom: 3.0,left: 20.0),
                color: Colors.red[500],
                onPressed: () {
                _googleIleGiris();
                },
                child: new Row(

                  children: <Widget>[
                    Center(
                      child: new Image.asset(
                        'assets/images/google-logo3.png',
                        height: 28.0,
                      ),
                    ),
                    new Container(
                        padding: EdgeInsets.only(left: 25.0,right: 0.0),
                        child: Center(child: new Text("Google ile giriş yap",style: TextStyle(color: Colors.black,fontWeight: null,fontSize: 20.0),))
                    ),
                  ],
                )
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Center(
            child: InkWell(
              child: Text("Şifremi Unuttum",style: TextStyle(fontWeight: FontWeight.bold),),
              onTap:() {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>SifremiUnuttum()));
              } ,
            ),
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
      setState(() {
        yukleniyor = true;
      });
      try {
        await _yetkilendirmeServisi.mailIleGiris(email, sifre);
      } catch (hata) {
        setState(() {
          yukleniyor = false;
        });
        uyariGoster(hataKodu: hata.code);
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
            fotoUrl: kullanici.fotoUrl,
          );
          print("Kullanıcı dökümanı oluşturuldu");
        }
      }
    } catch (hata) {
      setState(() {
        yukleniyor = false;
      });

      uyariGoster(hataKodu: hata.code);
    }
  }

  uyariGoster({hataKodu}) {
    String hataMesaji;

    if (hataKodu == "ERROR_USER_NOT_FOUND") {
      hataMesaji = "Böyle bir kullanıcı sisteme kayıtlı değil.";
    } else if (hataKodu == "ERROR_INVALID_EMAIL") {
      hataMesaji = "Girdiğiniz mail adresi geçersizdir";
    } else if (hataKodu == "ERROR_WRONG_PASSWORD") {
      hataMesaji = "Girilen şifre hatalı";
    } else if (hataKodu == "ERROR_USER_DISABLED") {
      hataMesaji = "Kullanıcı engellenmiş";
    } else {
      hataMesaji = "Tanımlanamayan bir cisim yaklaştı cisim:$hataKodu";
    }
    var snackBar = SnackBar(
      content: Text(hataMesaji),
    );
    _scaffoldAnahtari.currentState.showSnackBar(snackBar);
  }
}
