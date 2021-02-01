import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialapp/servisler/yetkilendirmeservisi.dart';

class SifremiUnuttum extends StatefulWidget {
  @override
  _SifremiUnuttumState createState() => _SifremiUnuttumState();
}

class _SifremiUnuttumState extends State<SifremiUnuttum> {
  bool yukleniyor = false;
  final _formAnahtari=GlobalKey<FormState>();
  final _scaffoldAnahtari=GlobalKey<ScaffoldState>();
  String email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldAnahtari,
      appBar: AppBar(
        title: Text("Şifremi Sıfırla"),
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
                      hintText: "Email adresinizi giriniz",
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
                    height: 50.0,
                  ),
                  Container(
                    width: double.infinity,
                    // ignore: deprecated_member_use
                    child: FlatButton(
                      onPressed: _sifreyiSifirla,
                      child: Text(
                        "Şifremi Sıfırla",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
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
  void _sifreyiSifirla()async {
    final _yetkilendirmeServisi=Provider.of<YetkilendirmeServisi>(context,listen:false);
    var _formState=_formAnahtari.currentState;

    if(_formState.validate()){
      _formState.save();
      setState(() {
        yukleniyor=true;
      });
      try{
        await _yetkilendirmeServisi.sifremiSifirla(email);

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
      hataMesaji="Girdiğiniz Mail adresi geçersizdir";
    }else if(hataKodu=="ERROR_USER_NOT_FOUND"){
      hataMesaji="Bu mailde bir kullanıcı bulunmuyor";
    }
    var snackBar=SnackBar(content: Text(hataMesaji),);
    // ignore: deprecated_member_use
    _scaffoldAnahtari.currentState.showSnackBar(snackBar);
  }
}
