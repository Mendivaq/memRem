import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialapp/modeller/kullanici.dart';
import 'package:socialapp/servisler/firestoreservisi.dart';
import 'package:socialapp/servisler/yetkilendirmeservisi.dart';

class HesapOlustur extends StatefulWidget {
  @override
  _HesapOlusturState createState() => _HesapOlusturState();
}

class _HesapOlusturState extends State<HesapOlustur> {
  bool yukleniyor = false;
  final _formAnahtari=GlobalKey<FormState>();
  final _scaffoldAnahtari=GlobalKey<ScaffoldState>();
  String kullaniciAdi,email,sifre;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldAnahtari,
      appBar: AppBar(
        title: Text("Hesap Oluştur"),
      ),
      body: ListView(
        children: [
          yukleniyor
              ? LinearProgressIndicator()
              : SizedBox(
                  height: 0.0,
                ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formAnahtari,
              child: Column(
                children: [
                  TextFormField(
                    autocorrect: true,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "Kullanıcı adınızı girin",hintStyle: TextStyle(color: Colors.black),
                      labelText: "Kullanıcı Adı:",
                      errorStyle: TextStyle(fontSize: 16.0),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (girilenDeger) {
                      if (girilenDeger.isEmpty) {
                        return "Kullanıcı adı  boş bırakılamaz!";
                      } else if (girilenDeger.trim().length < 4 ||
                          girilenDeger.trim().length > 10) {
                        return "Girilen değer en az 4 en fazla 10 karakter olablir";
                      }
                      return null;
                    },
                    onSaved: (girilenDeger)=>kullaniciAdi=girilenDeger,

                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    autocorrect: true,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "Email adresinizi giriniz",hintStyle: TextStyle(color: Colors.black),
                      labelText: "Email:",
                      errorStyle: TextStyle(fontSize: 16.0),
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (girilenDeger) {
                      if (girilenDeger.isEmpty) {
                        return "Email alanı boş bırakılamaz!";
                      } else if (!girilenDeger.contains("@")) {
                        return "Girilen değer mail formatında olmalı!";
                      }
                      return null;
                    },
                    onSaved: (girilenDeger)=>email=girilenDeger,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    style: TextStyle(color: Colors.black),
                    obscureText: true,
                    decoration: InputDecoration(

                      hintText: "Şifrenizi Girin",hintStyle: TextStyle(color: Colors.black),
                      labelText: "Şifre:",
                      errorStyle: TextStyle(fontSize: 16.0),
                      prefixIcon: Icon(Icons.lock),
                    ),
                    validator: (girilenDeger) {
                      if (girilenDeger.isEmpty) {
                        return "Şifre alanı boş bırakılamaz!";
                      } else if (girilenDeger.trim().length < 4) {
                        return "Şifre 4 karakterden az olamaz!";
                      }
                      return null;
                    },
                    onSaved: (girilenDeger)=>sifre=girilenDeger,
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  Container(
                    width: double.infinity,
                    // ignore: deprecated_member_use
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)
                      ),
                      onPressed: _kullaniciOlustur,
                      child: Text(
                        "Hesap Oluştur",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                        ),
                      ),
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _kullaniciOlustur()async {
    final _yetkilendirmeServisi=Provider.of<YetkilendirmeServisi>(context,listen:false);
    var _formState=_formAnahtari.currentState;

    if(_formState.validate()){
      _formState.save();
      setState(() {
        yukleniyor=true;
      });
      try{
        Kullanici kullanici=await _yetkilendirmeServisi.mailIleKayit(email, sifre);
        if(kullanici!=null){
          FireStoreServisi().kullaniciOlustur(id: kullanici.id,email: email,kullaniciAdi: kullaniciAdi);
        }
        Navigator.pop(context);
      }
      catch(hata){
        setState(() {
          yukleniyor=false;
        });
        uyariGoster(hataKodu: hata.code);
      }

    }

  }

  uyariGoster({hataKodu}){
    String hataMesaji;

    if(hataKodu=="ERROR_INVALID_EMAIL"){
      hataMesaji="Girdiğiniz mail adresi geçersizdir";
    }else if(hataKodu=="ERROR_EMAIL_ALREADY_IN_USE"){
      hataMesaji="Girdiğiniz mail adresi kayıtlıdır";
    }else if(hataKodu=="ERROR_WEAK_PASSWORD"){
      hataMesaji="Daha zor bir şifre tercih ediniz";
    }
    var snackBar=SnackBar(content: Text(hataMesaji),);
    // ignore: deprecated_member_use
    _scaffoldAnahtari.currentState.showSnackBar(snackBar);
  }
}
