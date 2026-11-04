import 'package:flutter/material.dart';
import '../models/room_data.dart';
import 'apartment_view_screen.dart';
import 'room_setup_screen.dart';

class WallScanScreen extends StatefulWidget {
  final RoomData room;
  final List<RoomData> existingRooms;

  const WallScanScreen({
    super.key,
    required this.room,
    required this.existingRooms,
  });

  @override
  State<WallScanScreen> createState() => _WallScanScreenState();
}

class _WallScanScreenState extends State<WallScanScreen> {
  int _currentWallIndex = 0;
  final _depthController = TextEditingController(text: '0.0');

  @override
  void dispose() {
    _depthController.dispose();
    super.dispose();
  }

  void _captureWall() {
    final double depth = double.tryParse(_depthController.text) ?? 0.0;
    widget.room.walls[_currentWallIndex].furnitureDepth = depth;
    widget.room.walls[_currentWallIndex].photoPath = "captured_wall_${_currentWallIndex + 1}";

    if (_currentWallIndex < 3) {
      setState(() {
        _currentWallIndex++;
        _depthController.text = widget.room.walls[_currentWallIndex].furnitureDepth.toString();
      });
    } else {
      // Converte sempre in una nuova lista growable per evitare qualsiasi eccezione di tipo "Unsupported operation"
      final List<RoomData> mutableRooms = List<RoomData>.from(widget.existingRooms);
      mutableRooms.add(widget.room);

      _showRoomCompletedDialog(mutableRooms);
    }
  }

  void _showRoomCompletedDialog(List<RoomData> updatedRooms) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Stanza "${widget.room.name}" Completata!'),
        content: const Text('Cosa desideri fare adesso?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => RoomSetupScreen(existingRooms: updatedRooms),
                ),
              );
            },
            child: const Text('Aggiungi un\'altra stanza'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ApartmentViewScreen(allRooms: updatedRooms),
                ),
              );
            },
            child: const Text('Progetto Completato'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentWall = widget.room.walls[_currentWallIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Scansione: ${widget.room.name} (${currentWall.name})'),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.camera_alt, size: 80, color: Colors.blueGrey),
            const SizedBox(height: 20),
            Text(
              'Parete ${_currentWallIndex + 1} di 4: ${currentWall.name}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Inquadra la parete, scatta mentalmente la foto e indica l\'eventuale profondità dei mobili presenti.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _depthController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Profondità mobili su questa parete (metri)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: _captureWall,
              child: Text(
                _currentWallIndex < 3 ? 'Registra Foto & Prossima Parete' : 'Salva e Termina Stanza',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}