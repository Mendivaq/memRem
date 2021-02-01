import 'package:cloud_firestore/cloud_firestore.dart';

class Bildirim{
  final String id;
  final String aktiviteYapanId;
  final String aktiviteTipi;
  final String gonderiId;
  final String gonderiFoto;
  final String yorum;
  final Timestamp olusturulmaZamani;

  Bildirim({this.id, this.aktiviteYapanId, this.aktiviteTipi, this.gonderiId, this.gonderiFoto, this.yorum, this.olusturulmaZamani});



  factory Bildirim.dokumandanUret(DocumentSnapshot doc) {

    return Bildirim(
      id : doc.documentID,
      aktiviteYapanId: doc['aktiviteYapanId'],
      aktiviteTipi: doc['aktiviteTipi'],
      gonderiId: doc['gonderiId'],
      gonderiFoto: doc['gonderiFoto'],
      yorum: doc['yorum'],
      olusturulmaZamani: doc['olusturulmaZamani'],

    );
  }
}