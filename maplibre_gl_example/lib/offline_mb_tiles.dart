import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:maplibre_gl_example/page.dart';

class OfflineMBTilesPage extends ExamplePage {
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

  void _onMapCreated(MaplibreMapController controller) async {
    mapController = controller;

    await controller.addSource(
      'mbtiles-source',
      const RasterSourceProperties(
        tiles: ['file:///assets/synthetic.mbtiles'],
        tileSize: 256,
      ),
    );
    await controller.addLayer(
      'mbtiles-layer',
      'mbtiles-source',
      const RasterLayerProperties(
        rasterOpacity: 1.0,
      ),
    );

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [MaplibreMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: const CameraPosition(
            target: LatLng(0.0, 0.0),
            zoom: 1,
          ),
        ),
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
        ]
      ),
    );
  }
}
