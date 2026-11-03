```
https://pub.dev/packages/flutter_contacts
```

Here’s a complete example of how to use the flutter_contacts package in your Flutter project — including setup steps, permissions, and sample code to **read contacts**. You can adapt it further to create/update contacts or work with groups/vCards as needed.

---

## ✅ Setup & Permissions

### 1. Add dependency

In your `pubspec.yaml`, under `dependencies`, add:

```yaml
flutter_contacts: ^1.1.9+2
```

(as of current version) ([Dart packages][1])

### 2. Platform-specific setup

**Android** (in `android/app/src/main/AndroidManifest.xml`):

```xml
<uses-permission android:name="android.permission.READ_CONTACTS"/>
<uses-permission android:name="android.permission.WRITE_CONTACTS"/>
```

([Dart packages][1])

**iOS** (in `ios/Runner/Info.plist`):

```xml
<key>NSContactsUsageDescription</key>
<string>We need access to your contacts to …</string>
```

([Dart packages][1])

### 3. Import the package

```dart
import 'package:flutter_contacts/flutter_contacts.dart';
```

([Dart packages][1])

---

## 🧩 Sample Code — Read Contacts

Here’s a simple screen that requests permission, fetches contacts, and displays them in a list.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class ContactsListScreen extends StatefulWidget {
  const ContactsListScreen({Key? key}) : super(key: key);

  @override
  _ContactsListScreenState createState() => _ContactsListScreenState();
}

class _ContactsListScreenState extends State<ContactsListScreen> {
  List<Contact>? _contacts;
  bool _permissionDenied = false;

  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  Future<void> _fetchContacts() async {
    // Request READ permission (readonly: true means we won’t ask for write)
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      setState(() {
        _permissionDenied = true;
      });
      return;
    }

    // Fetch contacts (just minimal info)
    List<Contact> contacts = await FlutterContacts.getContacts();
    setState(() {
      _contacts = contacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_permissionDenied) {
      return Scaffold(
        appBar: AppBar(title: const Text('Contacts')),
        body: const Center(child: Text('Permission denied')),
      );
    }
    if (_contacts == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Contacts')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Contacts')),
      body: ListView.builder(
        itemCount: _contacts!.length,
        itemBuilder: (context, index) {
          final c = _contacts![index];
          return ListTile(
            title: Text(c.displayName),
            onTap: () async {
              // Fetch full contact (with properties) when tapped
              final full = await FlutterContacts.getContact(c.id);
              if (full == null) return;
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ContactDetailsScreen(contact: full),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ContactDetailsScreen extends StatelessWidget {
  final Contact contact;
  const ContactDetailsScreen({Key? key, required this.contact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(contact.displayName)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('First name: ${contact.name.first}'),
            Text('Last name: ${contact.name.last}'),
            Text('Phones: ${contact.phones.map((p) => p.number).join(', ')}'),
            Text('Emails: ${contact.emails.map((e) => e.address).join(', ')}'),
            // you can go on to show addresses, organizations etc.
          ],
        ),
      ),
    );
  }
}
```

This code is essentially adapted from the example in the package’s `example/lib/main.dart`. ([Dart packages][2])

---

## 🧠 Notes & Tips

* By default `getContacts()` returns **unified contacts** (merged duplicates) unless you change the config:

  ```dart
  FlutterContacts.config.returnUnifiedContacts = false;
  ```

  ([Dart packages][1])
* You can fetch more detailed data (photos, full properties) via:

  ```dart
  List<Contact> contacts = await FlutterContacts.getContacts(
    withProperties: true,
    withPhoto: true,
  );
  ```

  ([Dart packages][1])
* To create a new contact:

  ```dart
  final newContact = Contact()
    ..name.first = 'John'
    ..name.last = 'Doe'
    ..phones = [Phone('123-456-7890')];
  await newContact.insert();
  ```

  ([Dart packages][1])
* To listen for changes in the device contacts database:

  ```dart
  FlutterContacts.addListener(() => print('Contacts DB changed'));
  ```

  ([Dart packages][1])
* On **iOS 13+**, notes support is disabled by default due to entitlement, but you can enable if you have the entitlement:

  ```dart
  FlutterContacts.config.includeNotesOnIos13AndAbove = true;
  ```

  ([Dart packages][3])

---

If you like, I can **generate a full code sample** for your use case (e-commerce / app context you’re working on) showing how to:

* Pick a contact and display in your UI
* Update a contact’s phone/email
* Delete a contact
* Handle permissions gracefully with your existing architecture

Would that be helpful?

[1]: https://pub.dev/packages/flutter_contacts?utm_source=chatgpt.com "flutter_contacts | Flutter package - Pub.dev"
[2]: https://pub.dev/packages/flutter_contacts/example?utm_source=chatgpt.com "flutter_contacts example | Flutter package - Pub.dev"
[3]: https://pub.dev/packages/flutter_contacts/versions/0.3.3%2B1?utm_source=chatgpt.com "flutter_contacts 0.3.3+1 | Flutter package - Pub.dev"
