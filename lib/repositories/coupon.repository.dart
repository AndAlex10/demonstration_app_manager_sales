import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vendas_mais_manager/models/entities/coupon.entity.dart';
import 'package:random_string/random_string.dart';
import 'package:vendas_mais_manager/repositories/coupon.repository.interface.dart';

class CouponRepository implements ICouponRepository {
  @override
  Future<Coupon> get(String code, String idEstablishment) async {
    Coupon coupon;
    QuerySnapshot list = await Firestore.instance
        .collection("???")
        .document(idEstablishment)
        .collection("???")
        .where("???", isEqualTo: code)
        .getDocuments();

    if (list.documents.length > 0) {
      for (var i = 0; i < list.documents.length; i++) {
        coupon = Coupon.fromDocument(list.documents[i]);

        if (DateTime.now().isAfter(coupon.dateExpiration.toDate())) {
          coupon = null;
        }
      }
    }
    return coupon;
  }

  @override
  Future<String> generateCode(String idEstablishment) async {
    String code;
    bool result = true;
    while (result) {
      code = randomAlpha(5).toUpperCase();
      QuerySnapshot list = await Firestore.instance
          .collection("???")
          .document(idEstablishment)
          .collection("???")
          .where("???", isEqualTo: code)
          .getDocuments();

      if (list.documents.length == 0) {
        result = false;
      }
    }
    return code;
  }

  @override
  void save(String idEstablishment, Coupon coupon) async {
    if (coupon.dateExpiration != null && coupon.value > 0.0) {
      if (coupon.id == '') {
        coupon.code = await generateCode(idEstablishment);

        await Firestore.instance
            .collection("???")
            .document(idEstablishment)
            .collection("???")
            .add(coupon.toMap())
            .then((doc) {
          coupon.id = doc.documentID;
        });
      } else {
        Map map = coupon.toMap();
        await Firestore.instance
            .collection("???")
            .document(idEstablishment)
            .collection("???")
            .document(coupon.id)
            .updateData(map);
      }
    }
  }

  @override
  void delete(String idEstablishment, String idCoupon) async {
    Firestore.instance
        .collection("???")
        .document(idEstablishment)
        .collection("???")
        .document(idCoupon)
        .delete();
  }
}
