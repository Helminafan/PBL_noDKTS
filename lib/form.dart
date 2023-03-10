import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:banksampah/formdata.dart';
import 'package:banksampah/warga.dart';

class MultiContactFormWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MultiContactFormWidgetState();
  }
}

class _MultiContactFormWidgetState extends State<MultiContactFormWidget> {
  List<ContactFormItemWidget> contactForms = List.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Tambah Data Warga Miskin"),
      ),
      bottomNavigationBar: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CupertinoButton(
            color: Colors.green,
            onPressed: () {
              onSave();
            },
            child: Text("Simpan"),
          ),
        ),
        margin: EdgeInsets.only(bottom: 30.0),
      ),
      
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: Icon(Icons.add),
        onPressed: () {
          onAdd();
        },
      ),
      body: contactForms.isNotEmpty
          ? ListView.builder(
              itemCount: contactForms.length,
              itemBuilder: (_, index) {
                return contactForms[index];
              })
          : Center(child: Text("Tap on + to Add Contact")),
    );
  }

  onSave() {
    bool allValid = true;

    contactForms
        .forEach((element) => allValid = (allValid && element.isValidated()));

    if (allValid) {
      List<String> names =
          contactForms.map((e) => e.contactModel.name).toList();
      debugPrint("$names");
    } else {
      debugPrint("Form is Not Valid");
    }
  }

  //Delete specific form
  onRemove(ContactModel contact) {
    setState(() {
      int index = contactForms
          .indexWhere((element) => element.contactModel.id == contact.id);

      if (contactForms != null) contactForms.removeAt(index);
    });
  }

  onAdd() {
    setState(() {
      ContactModel _contactModel = ContactModel(id: contactForms.length);
      contactForms.add(ContactFormItemWidget(
        index: contactForms.length,
        contactModel: _contactModel,
        onRemove: () => onRemove(_contactModel),
      ));
    });
  }
}
