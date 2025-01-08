// ignore_for_file: deprecated_member_use, unnecessary_null_comparison

import 'dart:io';

import 'package:favorite_places/model/place.dart';
import 'package:favorite_places/providers/user_places.dart';
import 'package:favorite_places/widgets/image_input.dart';
import 'package:favorite_places/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class AddPlacesScreen extends ConsumerStatefulWidget {
  const AddPlacesScreen({super.key});

  @override
  ConsumerState<AddPlacesScreen> createState() => _AddPlacesScreenState();
}

class _AddPlacesScreenState extends ConsumerState<AddPlacesScreen> {
  final _titlController = TextEditingController();
  File? _selectedImage;
  PlaceLocation? _selectedLocation;

  void _savePlace(){
    final enteredText = _titlController.text;
    if(enteredText == null || enteredText.isEmpty  || _selectedImage == null || _selectedLocation == null){
      _showErrorDialog();
      return;
    }
    ref.read(userPlacesProvider.notifier).addPlace(enteredText, _selectedImage!, _selectedLocation!);
    Navigator.of(context).pop();
  }

 void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Invalid input'),
        content: const Text('Please enter a valid title.'),
        actions: <Widget>[
          TextButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new Place'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                label: Text('Title'),
              ),
              controller: _titlController,
              style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
            ),
            const SizedBox(height: 10,),
            ImageInput(onPickImage: (image) {
              _selectedImage = image;
            },),
            const SizedBox(height: 10,),
            LocationInput(onSelectLocation: (location) {
                _selectedLocation = location;
            },),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton.icon(onPressed: _savePlace, label: const Text('Add Place'), icon: const Icon(Icons.add), )
          ],
        ),
      ),
    );
  }
}
