// ignore_for_file: unused_local_variable

import 'user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Contact {
  String? uid;
  Timestamp? addedOn;

  Contact({
    this.uid,
    this.addedOn,
  });

  Map toMap(Contact contact) {
    var data = <String, dynamic>{};
    data['contact_id'] = contact.uid;
    data['added_on'] = contact.addedOn;
    return data;
  }

  Contact.fromMap(Map<String, dynamic> mapData) {
    uid = mapData['contact_id'];
    addedOn = mapData['added_on'];
  }
}
