import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialapp/sayfalar/akis.dart';
import 'package:socialapp/sayfalar/ara.dart';
import 'package:socialapp/sayfalar/bildirimler.dart';
import 'package:socialapp/sayfalar/profil.dart';
import 'package:socialapp/sayfalar/yukle.dart';
import 'package:socialapp/servisler/yetkilendirmeservisi.dart';

class AnaSayfa extends StatefulWidget {
  @override
  _AnaSayfaState createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
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

  @override
  Widget build(BuildContext context) {
    String aktifKullaniciId =
        Provider.of<YetkilendirmeServisi>(context, listen: false)
            .aktifKullaniciId;
    return Scaffold(
      extendBody: true,
      body: PageView(
        //kaydırma özelliğini devre dışı bırakma
        //physics: NeverScrollableScrollPhysics(),
        onPageChanged: (acilanSayfaNo) {
          setState(() {
            _aktifSayfaNo = acilanSayfaNo;
          });
        },
        controller: sayfaKumandasi,
        children: [
          Akis(),
          Ara(),
          Yukle(),
          //Duyurular
          Bildirimler(),
          Profil(
            profilSahibiId: aktifKullaniciId,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.upload_rounded),
        onPressed: () {
          setState(() {
            if(sayfaKumandasi.jumpToPage==2){

            }
            sayfaKumandasi.jumpToPage(2);
          });

        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        clipBehavior: Clip.antiAlias,
        shape: CircularNotchedRectangle(),
        notchMargin: 10.0,
        child: BottomNavigationBar(
          backgroundColor: Colors.orange,
          type: BottomNavigationBarType.fixed,
          currentIndex: _aktifSayfaNo,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.black,
          onTap: (secilenSayfaNo) {
            setState(() {
              sayfaKumandasi.jumpToPage(secilenSayfaNo);
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home), title: Text("Akış")),
            BottomNavigationBarItem(
                icon: Icon(Icons.explore), title: Text("Ara")),
             BottomNavigationBarItem(icon: Icon(Icons.file_upload),title: Text("")),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications), title: Text("Bildirimler")),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), title: Text("Profil")),
          ],
        ),
      ),
    );
  }
}
