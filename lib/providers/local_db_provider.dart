import 'package:contact_app/local_db/db_helper.dart';
import 'package:contact_app/models/contact_model.dart';
import 'package:flutter/foundation.dart';

class LocalDbProvider with ChangeNotifier{
  List<ContactModel> _contactList = [];
  List<ContactModel> _favoriteContactList = [];

  List<ContactModel> get contactList => _contactList;
  List<ContactModel> get favoriteContactList => _favoriteContactList;
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

  Future<void> getAllFavoriteContacts() async {
    _contactList = await _db.getAllFavoriteContact();
    _favoriteContactList = _contactList.where((c) => c.favorite == true).toList();
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

  Future<void> updatedFavorite(ContactModel contact) async {
    final updatedFavoriteValue = contact.favorite ? 0 : 1;
    //final updatedRowId = await _db.updatedFavorite(contact.id!, updatedFavoriteValue);
    await _db.updatedFavorite(contact.id!, updatedFavoriteValue);
    final position = _contactList.indexOf(contact);
    _contactList[position].favorite = !_contactList[position].favorite;
    //contact.favorite = !contact.favorite;
    notifyListeners();
  }

  Future<void> updateContact(ContactModel contact) async {
    await _db.updateContact(contact);
    final position = _contactList.indexWhere((c) => c.id == contact.id);
    _contactList.removeAt(position);
    _contactList.insert(position, contact);
    notifyListeners();
  }

}