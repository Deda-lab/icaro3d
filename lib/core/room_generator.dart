import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import '../models/room_data.dart';

class RoomGenerator {
  static Future<String> generateApartmentModel(List allRooms) async {
    debugPrint('--- GENERAZIONE MODELLO 3D APPARTAMENTO AVVIATA ---');
    
    if (allRooms.isEmpty) {
      return _generateDefaultCube(RoomData(width: 4.0, length: 4.0, height: 2.8));
    }

    List posList = [];
    List uvList = [];
    List materialsList = [];

    double currentOffsetX = 0.0;

    for (int roomIndex = 0; roomIndex < allRooms.length; roomIndex++) {
      final room = allRooms[roomIndex];
      final double w = room.width;
      final double h = room.height;
      final double l = room.length;

      for (int wall = 0; wall < 4; wall++) {
        List wallVerts = [];
        List wallUvs = [0, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 0];

        double depthOffset = 0.0;
        if (wall < room.walls.length) {
          depthOffset = room.walls[wall].furnitureDepth;
        }

        if (wall == 0) {
          wallVerts = [
            currentOffsetX + 0, 0, -l + depthOffset,   currentOffsetX + w, 0, -l + depthOffset,   currentOffsetX + 0, h, -l + depthOffset,
            currentOffsetX + w, 0, -l + depthOffset,   currentOffsetX + w, h, -l + depthOffset,   currentOffsetX + 0, h, -l + depthOffset,
          ];
        } else if (wall == 1) {
          wallVerts = [
            currentOffsetX + w - depthOffset, 0, -l,   currentOffsetX + w - depthOffset, 0, 0,   currentOffsetX + w - depthOffset, h, -l,
            currentOffsetX + w - depthOffset, 0, 0,   currentOffsetX + w - depthOffset, h, 0,   currentOffsetX + w - depthOffset, h, -l,
          ];
        } else if (wall == 2) {
          wallVerts = [
            currentOffsetX + w, 0, 0 - depthOffset,   currentOffsetX + 0, 0, 0 - depthOffset,   currentOffsetX + w, h, 0 - depthOffset,
            currentOffsetX + 0, 0, 0 - depthOffset,   currentOffsetX + 0, h, 0 - depthOffset,   currentOffsetX + w, h, 0 - depthOffset,
          ];
        } else {
          wallVerts = [
            currentOffsetX + depthOffset, 0, 0,   currentOffsetX + depthOffset, 0, -l,   currentOffsetX + depthOffset, h, 0,
            currentOffsetX + depthOffset, 0, -l,   currentOffsetX + depthOffset, h, -l,   currentOffsetX + depthOffset, h, 0,
          ];
        }

        posList.addAll(wallVerts);
        uvList.addAll(wallUvs);

        materialsList.add({
          "doubleSided": true,
          "pbrMetallicRoughness": {
            "baseColorFactor": [0.85, 0.88, 0.9, 1.0],
            "roughnessFactor": 0.8
          }
        });
      }

      currentOffsetX += w + 1.0; 
    }

    if (materialsList.isEmpty) {
      materialsList.add({
        "doubleSided": true,
        "pbrMetallicRoughness": {
          "baseColorFactor": [0.8, 0.8, 0.8, 1.0],
          "roughnessFactor": 0.9
        }
      });
    }

    final posBytes = Float32List.fromList(posList.cast<double>()).buffer.asUint8List();
    final uvBytes = Float32List.fromList(uvList.cast<double>()).buffer.asUint8List();

    final BytesBuilder byteBuilder = BytesBuilder();
    byteBuilder.add(posBytes);
    byteBuilder.add(uvBytes);
    final combinedBytes = byteBuilder.toBytes();
    final combinedBase64 = base64Encode(combinedBytes);

    final int posByteLength = posBytes.length;
    final int uvByteLength = uvBytes.length;

    final Map<String, dynamic> gltf = {
      "asset": {"version": "2.0", "generator": "Icaro3D Clean Engine"},
      "scene": 0,
      "scenes": [{"nodes": [0]}],
      "nodes": [{"mesh": 0}],
      "meshes": [{
        "primitives": [{
          "attributes": {
            "POSITION": 0,
            "TEXCOORD_0": 1
          },
          "material": 0
        }]
      }],
      "materials": materialsList,
      "textures": [{"sampler": 0, "source": 0}],
      "images": [{"uri": ""}],
      "samplers": [{"magFilter": 9729, "minFilter": 9987}],
      "buffers": [{
        "byteLength": combinedBytes.length,
        "uri": "data:application/octet-stream;base64,$combinedBase64"
      }],
      "bufferViews": [
        {"buffer": 0, "byteOffset": 0, "byteLength": posByteLength, "target": 34962},
        {"buffer": 0, "byteOffset": posByteLength, "byteLength": uvByteLength, "target": 34962}
      ],
      "accessors": [
        {
          "bufferView": 0, "byteOffset": 0, "componentType": 5126,
          "count": posList.length ~/ 3, "type": "VEC3",
          "max": [100.0, 10.0, 100.0], "min": [-100.0, 0.0, -100.0]
        },
        {
          "bufferView": 1, "byteOffset": 0, "componentType": 5126,
          "count": uvList.length ~/ 2, "type": "VEC2",
          "max": [1.0, 1.0], "min": [0.0, 0.0]
        }
      ]
    };

    final jsonString = jsonEncode(gltf);
    return 'data:model/gltf+json;base64,${base64Encode(utf8.encode(jsonString))}';
  }

  static Future<String> _generateDefaultCube(RoomData room) async {
    return generateApartmentModel([room]);
  }
}