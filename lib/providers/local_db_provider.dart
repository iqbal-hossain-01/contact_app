import 'package:contact_app/local_db/db_helper.dart';
import 'package:contact_app/models/contact_model.dart';
import 'package:flutter/foundation.dart';

class LocalDbProvider with ChangeNotifier{
  List<ContactModel> _contactList = [];
  List<ContactModel> get contactList => _contactList;
  final _db = DbHelper();

  Future<void> addContact(ContactModel contact) async {
    final rowId = await _db.insertContact(contact);
    contact.id = rowId;
    _contactList.add(contact);
    _contactList.sort((a, b) {
      if (a.name == null || a.name!.isEmpty) {
        return -1;
      } else if (b.name == null || b.name!.isEmpty) {
        return 1;
      } else {
        return a.name!.compareTo(b.name!);
      }
    });
    notifyListeners();
  }

  Future<void> getAllContacts() async {
    _contactList = await _db.getAllContact();
    notifyListeners();
  }

  Future<void> deleteContact(ContactModel contact) async {
    await _db.deleteContact(contact.id!);
    _contactList.removeWhere((c) => c.id == contact.id);
    notifyListeners();
  }

  Future<ContactModel> getContactById(int id) async {
    return _db.getContactById(id);
  }
}