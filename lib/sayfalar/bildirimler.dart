import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialapp/modeller/bildirim.dart';
import 'package:socialapp/modeller/kullanici.dart';
import 'package:socialapp/sayfalar/profil.dart';
import 'package:socialapp/sayfalar/tekligonderi.dart';
import 'package:socialapp/servisler/firestoreservisi.dart';
import 'package:socialapp/servisler/yetkilendirmeservisi.dart';
import 'package:timeago/timeago.dart'as timeago;


//Duyurular
class Bildirimler extends StatefulWidget {
  @override
  _BildirimlerState createState() => _BildirimlerState();
}

class _BildirimlerState extends State<Bildirimler> {
  List<Bildirim> _bildirimler;
  String _aktifKullaniciId;
  bool _yukleniyor = true;

  @override
  void initState() {
    super.initState();
    _aktifKullaniciId =
        Provider.of<YetkilendirmeServisi>(context, listen: false)
            .aktifKullaniciId;
    bildirimleriGetir();
    timeago.setLocaleMessages('tr', timeago.TrMessages());

  }

  Future<void>bildirimleriGetir() async {
    List<Bildirim> bildirimler =
        await FireStoreServisi().bildirimleriGetir(_aktifKullaniciId);
    if (mounted) {
      setState(() {
        _bildirimler = bildirimler;
        _yukleniyor = false;
      });
    }
  }

  bildirimleriGoster() {
    if (_yukleniyor) {
      return Center(child: CircularProgressIndicator());
    }
    if (_bildirimler.isEmpty) {
      return Center(child: Text("Hiç bildirim yok"));
    }

    return Padding(
      padding: const EdgeInsets.only(top:12.0),
      child: RefreshIndicator(
        onRefresh: bildirimleriGetir,
        child: ListView.builder(
          itemCount: _bildirimler.length,
          itemBuilder: (context,index){
            Bildirim bildirim=_bildirimler[index];
            return bildirimSatiri(bildirim);
          }
        ),
      ),
    );
  }

  bildirimSatiri(Bildirim bildirim){
   String mesaj= mesajOlustur(bildirim.aktiviteTipi);
   return FutureBuilder(
     future: FireStoreServisi().kullaniciGetir(bildirim.aktiviteYapanId),
       builder: (context, snapshot) {
         if(!snapshot.hasData){
           return SizedBox(height: 0.0,);
         }
         Kullanici aktiviteYapan=snapshot.data;

         return ListTile(
           leading: InkWell(
             onTap: () {
               Navigator.push(context, MaterialPageRoute(builder: (context)=>Profil(profilSahibiId: bildirim.aktiviteYapanId,)));

             },
             child: CircleAvatar(
               backgroundImage: NetworkImage(aktiviteYapan.fotoUrl),
             ),
           ),
           title: RichText(
             text: TextSpan(
               recognizer: TapGestureRecognizer()..onTap=(){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Profil(profilSahibiId: bildirim.aktiviteYapanId,)));
               },
               text: "${aktiviteYapan.kullaniciAdi}",
               style: TextStyle(
                 color: Colors.black,fontWeight: FontWeight.bold
               ),
                 children: [
                   TextSpan(
                 text: bildirim.yorum==null ?" $mesaj ":" $mesaj: ${bildirim.yorum}"  ,style: TextStyle(fontWeight: FontWeight.normal)
             )
                 ]
             ),
           ),
           subtitle: Text(timeago.format(bildirim.olusturulmaZamani.toDate(),locale: "tr")),
           trailing: gonderiGorsel(bildirim.aktiviteTipi, bildirim.gonderiFoto,bildirim.gonderiId),
         );
       },);

  }
  gonderiGorsel(String aktiviteTipi,String gonderiFoto,String gonderiId){
    if(aktiviteTipi=="takip"){
      return null;
    }
    else if(aktiviteTipi=="begeni"||aktiviteTipi=="yorum"){
      return GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>TekliGonderi(gonderiId: gonderiId,gonderiSahibiId: _aktifKullaniciId,)));
        },
          child: Image.network(gonderiFoto,width: 50.0,height: 50.0,fit: BoxFit.cover,)
      );
    }
  }

  mesajOlustur(String aktiviteTipi){
    if(aktiviteTipi=="begeni"){
      return "gönderini beğendi";
    }else if(aktiviteTipi=="takip"){
      return "seni takip etti";
    }else if(aktiviteTipi=="yorum"){
      return "gönderine yorum yaptı";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Bildirimler",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.orange,
      ),
      body: bildirimleriGoster(),
    );
  }
}
