import 'package:contact_app/models/contact_model.dart';
import 'package:contact_app/utils/constants.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DbHelper {
  final createTableContact = '''CREATE TABLE $tableContact(
 $tblContactColId INTEGER PRIMARY KEY AUTOINCREMENT,
 $tblContactColName TEXT,
 $tblContactColNumber TEXT,
 $tblContactColGender TEXT,
 $tblContactColDob TEXT,
 $tblContactColEmail TEXT,
 $tblContactColGroup TEXT,
 $tblContactColWebsite TEXT,
 $tblContactColAddress TEXT,
 $tblContactColImage TEXT,
 $tblContactColFavorite INTEGER)''';

  Future<Database> _open() async {
    final rootPath = await getDatabasesPath();
    final dbPath = path.join(rootPath, 'contact.db');
    return openDatabase(dbPath, version: 1, onCreate: (db, version) {
      db.execute(createTableContact);
    });
  }

  Future<int> insertContact(ContactModel contact) async {
    final db = await _open();
    return db.insert(tableContact, contact.toMap());
  }

  Future<List<ContactModel>> getAllContact() async {
    final db = await _open();
    final mapList = await db.query(tableContact, orderBy: tblContactColName);
    List<ContactModel> contacts = List.generate(
      mapList.length,
      (index) => ContactModel.fromMap(mapList[index]),
    );
    return contacts;
  }
}
