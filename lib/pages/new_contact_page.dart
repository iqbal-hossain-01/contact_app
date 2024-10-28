import 'dart:io';

import 'package:contact_app/models/contact_model.dart';
import 'package:contact_app/providers/local_db_provider.dart';
import 'package:contact_app/utils/constants.dart';
import 'package:contact_app/utils/helper_functions.dart';
import 'package:contact_app/widgets/vertical_line.dart';
import 'package:contact_app/widgets/horizontal_line.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class NewContactPage extends StatefulWidget {
  static const String routeName = '/new';

  const NewContactPage({super.key});

  @override
  State<NewContactPage> createState() => _NewContactPageState();
}

class _NewContactPageState extends State<NewContactPage> {
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _webController = TextEditingController();
  DateTime? _selectedDate;
  String? _group;
  Gender? gender;
  String? _imagePath;
  final _formKey = GlobalKey<FormState>();
  late bool _isUpdating;
  int? updateContactId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arg = ModalRoute.of(context)?.settings.arguments;
    if (arg != null) {
      updateContactId = arg as int;
      context.read<LocalDbProvider>().getContactById(updateContactId!)
        .then((contact) {
          setState(() {
            _nameController.text = (contact.name?.isNotEmpty == true ? contact.name! : null)!;
            _numberController.text = contact.number;
            _emailController.text = (contact.email?.isNotEmpty == true ? contact.email! : null)!;
            _webController.text = (contact.website?.isNotEmpty == true ? contact.website! : null)!;
            _addressController.text = (contact.address?.isNotEmpty == true ? contact.address! : null)!;
            _imagePath = contact.image?.isNotEmpty == true ? contact.image! : null;
            _group = contact.group?.isNotEmpty == true ? contact.group! : null;
            if (contact.dob != null) {
              _selectedDate = DateTime.parse(contact.dob!);
            } else {
              _selectedDate = null;
            }
            gender = contact.gender == Gender.Male.name ? Gender.Male : Gender.Female;
          });

      });

    }
    _isUpdating = updateContactId == null ? false : true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isUpdating ? 'Update contact' : 'New contact'),
        centerTitle: true,
        backgroundColor: _isUpdating ? Colors.grey.withOpacity(0.3) : null,
        actions: [
          TextButton(
            onPressed: _contactSave,
            child: const Text('Done'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          children: [
            Column(
              children: [
                Stack(
                  children: [
                    Card(
                      elevation: 3,
                      child: _imagePath == null
                          ? const Icon(
                              Icons.person,
                              size: 120,
                            )
                          : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.file(
                                File(_imagePath!),
                                height: 120,
                                width: 120,
                                fit: BoxFit.cover,
                              ),
                          ),
                    ),
                    Positioned(
                      right: -10,
                      bottom: 100,
                      child: _imagePath != null
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  _imagePath = null;
                                });
                              },
                              icon: const Icon(Icons.cancel))
                          : const Icon(null),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        _getImage(ImageSource.camera);
                      },
                      label: const Column(
                        children: [
                          Icon(Icons.camera_alt_outlined),
                          SizedBox(
                            width: 5,
                          ),
                          Text('Camera'),
                        ],
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        _getImage(ImageSource.gallery);
                      },
                      label: const Column(
                        children: [
                          Icon(Icons.photo_camera_back),
                          SizedBox(
                            width: 5,
                          ),
                          Text('Gallery'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  const SizedBox(
                    width: 80,
                    child: Text(
                      'Name',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const HorizontalLine(),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Name',
                        hintStyle: TextStyle(fontWeight: FontWeight.w300),
                      ),
                      validator: (value) {
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  const SizedBox(
                    width: 80,
                    child: Text(
                      'Phone',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const HorizontalLine(),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _numberController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Phone',
                        hintStyle: TextStyle(fontWeight: FontWeight.w300),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please provide a contact number';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            const VerticalLine(),
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  const SizedBox(
                    width: 80,
                    child: Text(
                      'Email',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const HorizontalLine(),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Email',
                        hintStyle: TextStyle(fontWeight: FontWeight.w300),
                      ),
                      validator: (value) {
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  const SizedBox(
                    width: 80,
                    child: Text(
                      'Address',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const HorizontalLine(),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Address',
                        hintStyle: TextStyle(fontWeight: FontWeight.w300),
                      ),
                      validator: (value) {
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  const SizedBox(
                    width: 80,
                    child:Text(
                      'Web',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const HorizontalLine(),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _webController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Website',
                        hintStyle: TextStyle(fontWeight: FontWeight.w300),
                      ),
                      validator: (value) {
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            const VerticalLine(),
            const SizedBox(height: 10),
            Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                      onPressed: _selectDateofBrith,
                      label: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.calendar_month_sharp),
                          Text('Select Date of Brith')
                        ],
                      )),
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(
                      _selectedDate == null
                          ? 'No date chosen'
                          : getFormattedDate(_selectedDate!)!,
                    ),
                  ),
                ],
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(border: InputBorder.none),
                  value: _group,
                  hint: const Text('Select group'),
                  isExpanded: true,
                  items: group
                      .map((group) => DropdownMenuItem(
                            value: group,
                            child: Text(group),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _group = value;
                    });
                  },
                  validator: (value) {
                    return null;
                  },
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Select Gender'),
                    Row(
                      children: [
                        Radio<Gender>(
                          value: Gender.Male,
                          groupValue: gender,
                          onChanged: (value) {
                            setState(() {
                              gender = value!;
                            });
                          },
                        ),
                        Text(Gender.Male.name),
                        Radio<Gender>(
                          value: Gender.Female,
                          groupValue: gender,
                          onChanged: (value) {
                            setState(() {
                              gender = value!;
                            });
                          },
                        ),
                        Text(Gender.Female.name),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _contactSave() {
    if (_formKey.currentState!.validate()) {
      final contact = ContactModel(
        name: _nameController.text.isNotEmpty ? _nameController.text : null,
        number: _numberController.text,
        gender: gender?.name,
        email: _emailController.text.isNotEmpty ? _emailController.text : null,
        dob: getFormattedDate(_selectedDate),
        group: _group,
        address: _addressController.text.isNotEmpty ? _addressController.text : null,
        website: _webController.text.isNotEmpty ? _webController.text : null,
        image: _imagePath,
      );
      if (_isUpdating) {
        contact.id = updateContactId;
        context.read<LocalDbProvider>().updateContact(contact)
            .then((value) {
          showMsg(context, 'Updated');
          Navigator.pop(context);
        })
            .catchError((error) {
          showMsg(context, error.toString());
        });
      } else {
        context.read<LocalDbProvider>().addContact(contact)
            .then((value) {
          showMsg(context, 'Saved');
          Navigator.pop(context);
        })
            .catchError((error) {
          showMsg(context, error.toString());
        });
      }
    }
  }

  Future<void> _selectDateofBrith() async {
    final DateTime? date = await showDatePicker(
      context: context,
      firstDate: DateTime(1969),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  Future<void> _getImage(ImageSource source) async {
    final xFile = await ImagePicker().pickImage(source: source);
    if (xFile != null) {
      setState(() {
        _imagePath = xFile.path;
      });
    }
  }
}
