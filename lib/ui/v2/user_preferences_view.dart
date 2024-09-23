import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qookit/services/theme/theme_service.dart';
import 'package:qookit/ui/v2/services/hive_service.dart';

class UserPreferencesView extends StatefulWidget {
  @override
  _UserPreferencesViewState createState() => _UserPreferencesViewState();
}

class _UserPreferencesViewState extends State<UserPreferencesView> {
  String userId = FirebaseAuth.instance.currentUser!.uid!;

  final TextEditingController _dietaryController = TextEditingController();
  final TextEditingController _culinaryController = TextEditingController();

  List<String> dietaryRestrictions = [];
  List<String> culinaryPreferences = [];

  late Box<List<String>> _dietaryRestrictionsBox;
  late Box<List<String>> _culinaryPreferencesBox;

  @override
  void initState() {
    super.initState();
    _openHiveBoxes();
  }

  Future<void> _openHiveBoxes() async {
    try {
      _dietaryRestrictionsBox = await Hive.box<List<String>>(HiveBoxes.dietaryRestrictions);
      _culinaryPreferencesBox = await Hive.box<List<String>>(HiveBoxes.culinaryPreferences);

      setState(() {
        dietaryRestrictions = _dietaryRestrictionsBox.get(userId, defaultValue: [])!;
        culinaryPreferences = _culinaryPreferencesBox.get(userId, defaultValue: [])!;
      });
    } catch (error) {
      print('Error opening Hive box: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Preferences', style: qookitLight.textTheme.headline4),
        centerTitle: true,
        backgroundColor: qookitLight.primaryColor,
        iconTheme: IconThemeData(color: Colors.black54),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildSectionCard(
                title: 'Dietary Restrictions',
                inputController: _dietaryController,
                onAdd: _addDietaryRestriction,
                list: dietaryRestrictions,
                onRemove: _removeDietaryRestriction,
              ),
              SizedBox(height: 20),
              _buildSectionCard(
                title: 'Culinary Preferences',
                inputController: _culinaryController,
                onAdd: _addCulinaryPreference,
                list: culinaryPreferences,
                onRemove: _removeCulinaryPreference,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required TextEditingController inputController,
    required VoidCallback onAdd,
    required List<String> list,
    required Function(int) onRemove,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              title,
              style: qookitLight.textTheme.headline6!.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              controller: inputController,
              decoration: InputDecoration(
                labelText: 'Add new',
                labelStyle: TextStyle(color: Colors.black54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.amber),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.amber, width: 2),
                ),
              ),
              style: qookitLight.textTheme.bodyText1,
              cursorColor: Colors.amber,
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: onAdd,
              style: ElevatedButton.styleFrom(
                primary: Colors.amber,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              icon: Icon(Icons.add, color: Colors.black),
              label: Text(
                'Add',
                style: qookitLight.textTheme.headline6!.copyWith(color: Colors.black),
              ),
            ),
            SizedBox(height: 20),
            _buildListView(list, onRemove),
          ],
        ),
      ),
    );
  }

  Widget _buildListView(List<String> items, Function(int) onRemove) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: ListTile(
            title: Text(
              items[index],
              style: qookitLight.textTheme.bodyText1,
            ),
            trailing: IconButton(
              icon: Icon(Icons.remove_circle, color: Colors.amber),
              onPressed: () => onRemove(index),
            ),
          ),
        );
      },
    );
  }

  void _addDietaryRestriction() {
    final restriction = _dietaryController.text.trim();
    if (restriction.isNotEmpty) {
      setState(() {
        dietaryRestrictions.add(restriction);
      });
      _dietaryController.clear();
      _updateDietaryRestrictions();
    }
  }

  void _addCulinaryPreference() {
    final preference = _culinaryController.text.trim();
    if (preference.isNotEmpty) {
      setState(() {
        culinaryPreferences.add(preference);
      });
      _culinaryController.clear();
      _updateCulinaryPreferences();
    }
  }

  void _updateDietaryRestrictions() {
    _dietaryRestrictionsBox.put(userId, dietaryRestrictions);
  }

  void _updateCulinaryPreferences() {
    _culinaryPreferencesBox.put(userId, culinaryPreferences);
  }

  void _removeDietaryRestriction(int index) {
    setState(() {
      dietaryRestrictions.removeAt(index);
    });
    _updateDietaryRestrictions();
  }

  void _removeCulinaryPreference(int index) {
    setState(() {
      culinaryPreferences.removeAt(index);
    });
    _updateCulinaryPreferences();
  }
}