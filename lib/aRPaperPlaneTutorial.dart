import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class ARPaperPlaneTutorial extends StatefulWidget {
  const ARPaperPlaneTutorial({super.key});

  @override
  _ARPaperPlaneTutorialState createState() => _ARPaperPlaneTutorialState();
}

class _ARPaperPlaneTutorialState extends State<ARPaperPlaneTutorial> {
  ArCoreController? arCoreController;
  int currentStep = 0;

  // List of paper plane tutorial steps
  final List<String> tutorialSteps = [
    "andy.sfb", // Ensure these files are in your assets folder
    "andy.sfb",
    "andy.sfb",
  ];

  // Function to load a specific tutorial step
  void _loadStepInAR() {
    arCoreController?.removeNode(nodeName: "paper_plane_step");
    _addTutorialStep();
  }

  // Add the current step's 3D model to the AR scene
  void _addTutorialStep() {
    final tutorialStepNode = ArCoreReferenceNode(
      name: "paper_plane_step",
      object3DFileName: tutorialSteps[currentStep],
      position: vector.Vector3(0, 0, -1.5), // Adjust position relative to the user
    );
    arCoreController?.addArCoreNode(tutorialStepNode);
  }

  @override
  void dispose() {
    arCoreController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AR Paper Plane Tutorial"),
      ),
      body: ArCoreView(
        onArCoreViewCreated: _onArCoreViewCreated,
        enableTapRecognizer: true, // Enable tap detection on AR surface
      ),
    );
  }

  // AR session initialization
  void _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
    // Detect taps on the AR surface
    arCoreController?.onPlaneTap = _handleOnPlaneTap;
    // Load the first step of the tutorial
    _loadStepInAR();
  }

  // Handle taps on AR surfaces
  void _handleOnPlaneTap(List<ArCoreHitTestResult> hitResults) {
    if (hitResults.isNotEmpty) {
      var hitResult = hitResults.first;
      _placeNextButtonOnSurface(hitResult);
    }
  }

  // Load the "Next" button as a 3D model in AR
  void _placeNextButtonOnSurface(ArCoreHitTestResult hitResult) {
    final nextButtonNode = ArCoreReferenceNode(
      name: "next_button",
      object3DFileName: "andy.sfb", // 3D model for "Next" button
      position: hitResult.pose.translation,
      rotation: hitResult.pose.rotation,
    );
    arCoreController?.addArCoreNode(nextButtonNode);

    arCoreController?.onNodeTap = (name) {
      if (name == "next_button") {
        print('Object Tapped !!!');
        _onNextStep();
      }
    };
  }

  // Function to go to the next tutorial step
  void _onNextStep() {
    setState(() {
      currentStep = (currentStep + 1) % tutorialSteps.length;
      _loadStepInAR(); // Load the next tutorial step
    });
  }
}
