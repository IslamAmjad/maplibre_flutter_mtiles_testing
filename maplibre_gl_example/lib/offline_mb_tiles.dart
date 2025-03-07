import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:maplibre_gl_example/page.dart';
import 'package:path_provider/path_provider.dart';

class OfflineMBTilesPage extends ExamplePage  {
  const OfflineMBTilesPage({super.key})
      : super(const Icon(Icons.map), 'Offline MBTiles');

  @override
  Widget build(BuildContext context) {
    return const OfflineMBTiles();
  }
}

class OfflineMBTiles extends StatefulWidget {
  const OfflineMBTiles({super.key});

  @override
  State<OfflineMBTiles> createState() => _OfflineMBTilesPageState();
}

class _OfflineMBTilesPageState extends State<OfflineMBTiles> {
  MaplibreMapController? mapController;
  String mbtilesPath = "";

  @override
  void initState()  {
    super.initState();

  }

  void _onMapCreated(MapLibreMapController controller) {
    mapController = controller;
  }

  Future<void> loadMbtiles() async {
    print("file path>>>>>>>>>>>>>>>>>> : $mbtilesPath");
    const sourceId = 'MbtileSourceId';
    // const layerId = 'MbtileLayerID';
    if (!await File(mbtilesPath).exists()) {
      print("file do not exist");
    }else{
      print("file  exist");

    }
    mapController!.addSource(
      sourceId,
      RasterSourceProperties(
        tiles: ['mbtiles://$mbtilesPath'],
        tileSize: 256,
        attribution: 'Map data &copy; OpenStreetMap contributors',
      ),
    );
    print('Source added: mbtiles-source');
    mapController!.addLayer(
      sourceId,
      sourceId,
      const RasterLayerProperties(),
    );
    print('Layer added: mbtiles-layer');
    mapController!.moveCamera(
      CameraUpdate.newLatLngZoom(const LatLng(30.7, -88.0), 6), // Mobile, AL
    );
    setState(() {});
  }


  Future<String> copyMbtilesFromAssets() async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/map.mbtiles';
    try {
      if (!await File(filePath).exists()) {
        final data = await rootBundle.load('assets/synthetic.mbtiles');
        final bytes = data.buffer.asUint8List();

        await File(filePath).writeAsBytes(bytes);
      }
    } catch (e) {
      print(e);
    }

    return filePath;
  }

  Future<void> _loadMbtiles() async {
    mbtilesPath = await copyMbtilesFromAssets();
    loadMbtiles();


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Stack(children: [
              MaplibreMap(
                  onMapCreated: _onMapCreated,
                  onStyleLoadedCallback: (){
                    _loadMbtiles();
                  },
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(0.0, 0.0),
                    zoom: 1,
                  )),

              Positioned(
                right: 10,
                top: MediaQuery.of(context).size.height * 0.5 - 60,
                child: Opacity(
                  opacity: 0.5,
                  child: Column(
                    children: [
                      FloatingActionButton(
                        onPressed: () => mapController?.animateCamera(
                          CameraUpdate.zoomIn(),
                        ),
                        child: const Icon(Icons.zoom_in),
                      ),
                      const SizedBox(height: 10),
                      FloatingActionButton(
                        onPressed: () => mapController?.animateCamera(
                          CameraUpdate.zoomOut(),
                        ),
                        child: const Icon(Icons.zoom_out),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
    );
  }
}
