class WallData {
  final String name; // Es. "Nord", "Est", "Sud", "Ovest"
  String? photoPath; // Percorso o stato della foto
  double furnitureDepth; // Profondità dei mobili presenti su questa parete (in metri)

  WallData({
    required this.name,
    this.photoPath,
    this.furnitureDepth = 0.0,
  });
}

class RoomData {
  String name;           // Es. "Salotto", "Camera"
  double width;          // Larghezza (asse X)
  double length;         // Lunghezza / Profondità (asse Z)
  double height;         // Altezza dei soffitti
  List<WallData> walls;  // Le 4 pareti scansionate in sequenza

  RoomData({
    this.name = "Stanza",
    required this.width,
    required this.length,
    required this.height,
    List<WallData>? walls,
  }) : walls = walls ?? List.generate(
         4,
         (index) {
           const names = ["Parete 1 (Nord)", "Parete 2 (Est)", "Parete 3 (Sud)", "Parete 4 (Ovest)"];
           return WallData(name: names[index]);
         },
       );
}