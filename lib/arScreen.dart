import 'package:flutter/material.dart'; // Flutter UI components
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart'; // ARCore plugin
import 'package:vector_math/vector_math_64.dart' as vector_math; // Alias for vector math
import 'package:permission_handler/permission_handler.dart'; // Permission handler

class AR_Test extends StatefulWidget {
  const AR_Test({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AR_TestState();
  }
}

class _AR_TestState extends State<AR_Test> {
  late ArCoreController arCoreController;

  @override
  void initState() {
    super.initState();
    _requestPermissions(); // Request camera permission
  }

  // Request camera permission
  void _requestPermissions() async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      print("Camera permission granted");
    } else {
      print("Camera permission denied");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AR Test App'),
      ),
      body: ArCoreView(
        onArCoreViewCreated: _onARViewCreated,
      ),
    );
  }

  // Called when ARCore view is created
  void _onARViewCreated(ArCoreController controller) {
    arCoreController = controller;
    print('ARCore Controller initialized');

    _addObjectOrCube();
  }


  void _addObjectOrCube() async {
    await Future.delayed(const Duration(seconds: 2)); // Delay for ARCore session initialization

    try {
      print("Attempting to add 3D object from assets");

      // Adding the 3D object from assets
      final node = ArCoreReferenceNode(
        name: "3d_object",
        object3DFileName: "andy.sfb", // Path to the 3D model file in assets
        position: vector_math.Vector3(0, 0, -1), // Position in front of the user
        scale: vector_math.Vector3(0.5, 0.5, 0.5), // Adjust the scale if necessary
      );

      await arCoreController.addArCoreNodeWithAnchor(node);
      print("3D object added to AR scene");
    } catch (e) {
      print("Error adding 3D object: $e");
      print("Falling back to adding cube");

      // Fallback to the cube if there's an error
      _addCube();
    }
  }

  // Function to add a cube to the AR scene
  void _addCube() async {
    await Future.delayed(const Duration(seconds: 2)); // Delay for ARCore session initialization

    final cube = ArCoreCube(
      size: vector_math.Vector3(0.2, 0.2, 0.2), // Simple cube
      materials: [
        ArCoreMaterial(
          color: Colors.cyan, // Green color for visibility
        ),
      ],
    );

    final node = ArCoreNode(
      shape: cube,
      position: vector_math.Vector3(0, 0, -1), // Simple position in front of the user
    );

    try {
      print("Attempting to add cube node");
      await arCoreController.addArCoreNode(node); // Adding node without anchor
      print("Cube added to AR scene");
    } catch (e) {
      print('Error adding cube: $e');
    }
  }

  @override
  void dispose() {
    // Dispose AR controller to clean up resources
    arCoreController.dispose();
    super.dispose();
  }
}
