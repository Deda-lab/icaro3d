import 'package:flutter/material.dart';
import '../models/room_data.dart';
import 'wall_scan_screen.dart';

class RoomSetupScreen extends StatefulWidget {
  final List<RoomData> existingRooms;

  const RoomSetupScreen({super.key, required this.existingRooms});

  @override
  State<RoomSetupScreen> createState() => _RoomSetupScreenState();
}

class _RoomSetupScreenState extends State<RoomSetupScreen> {
  final _widthController = TextEditingController(text: '4.0');
  final _lengthController = TextEditingController(text: '4.0');
  final _heightController = TextEditingController(text: '2.8');
  final _nameController = TextEditingController(text: 'Stanza');

  @override
  void dispose() {
    _widthController.dispose();
    _lengthController.dispose();
    _heightController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _startScanning() {
    final double width = double.tryParse(_widthController.text) ?? 4.0;
    final double length = double.tryParse(_lengthController.text) ?? 4.0;
    final double height = double.tryParse(_heightController.text) ?? 2.8;
    final String name = _nameController.text.isEmpty ? 'Stanza' : _nameController.text;

    final newRoom = RoomData(
      name: name,
      width: width,
      length: length,
      height: height,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WallScanScreen(
          room: newRoom,
          existingRooms: widget.existingRooms,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Genera Nuova Stanza'),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            const Text(
              'Inserisci le misure geometriche di base',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nome Stanza (es. Salotto, Cucina)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _widthController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Larghezza (metri)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _lengthController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Lunghezza / Profondità (metri)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _heightController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Altezza Soffitto (metri)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: _startScanning,
              child: const Text('Avanti: Scansione Pareti', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}