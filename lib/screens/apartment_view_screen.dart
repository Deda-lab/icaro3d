import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import '../models/room_data.dart';
import '../core/room_generator.dart';

class ApartmentViewScreen extends StatefulWidget {
  final List<RoomData> allRooms;

  const ApartmentViewScreen({super.key, required this.allRooms});

  @override
  State<ApartmentViewScreen> createState() => _ApartmentViewScreenState();
}

class _ApartmentViewScreenState extends State<ApartmentViewScreen> {
  String? _modelUri;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _buildModel();
  }

  Future<void> _buildModel() async {
    try {
      final uri = await RoomGenerator.generateApartmentModel(widget.allRooms);
      setState(() {
        _modelUri = uri;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Errore generazione modello 3D appartamento: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modello 3D Appartamento - Icaro3D'),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 15),
                  Text('Generazione volumetrica in corso...'),
                ],
              ),
            )
          : _modelUri == null
              ? const Center(child: Text('Errore nella generazione del modello 3D.'))
              : Stack(
                  children: [
                    // Visualizzatore 3D interattivo integrato per Chrome
                    ModelViewer(
                      src: _modelUri!,
                      alt: "Modello 3D dell'appartamento",
                      ar: true,
                      autoRotate: false,
                      cameraControls: true,
                      backgroundColor: const Color(0xFFF0F2F5),
                    ),
                    // Pannello informativo in alto
                    Positioned(
                      top: 20,
                      left: 20,
                      right: 20,
                      child: Card(
                        color: Colors.white.withValues(alpha: 0.9),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Stanze create: ${widget.allRooms.length}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueGrey,
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.popUntil(context, (route) => route.isFirst);
                                },
                                child: const Text('Nuovo Progetto'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}