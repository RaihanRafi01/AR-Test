
# Flutter AR App Setup Guide

### 1. Install arcore_flutter_plugin
- https://pub.dev/packages/arcore_flutter_plugin

### 2. Install permission_handler
- https://pub.dev/packages/permission_handler/install

### 3. Install vector_math
- https://pub.dev/packages/vector_math

### 4. Android Manifest Configuration
In `android/app/src/main/AndroidManifest.xml`, add the following permissions:

   ```xml
   <uses-permission android:name="android.permission.CAMERA"/>
   <uses-feature android:name="android.hardware.camera.ar" android:required="true"/>
   ```

Inside the `<Application>` tag, add:

   ```xml
   <meta-data
       android:name="com.google.ar.core"
       android:value="required"
       tools:replace="android:value" />
   ```

### 5. App-level build.gradle Configuration
In `android/app/build.gradle`, update `defaultConfig` to set the minimum SDK version to 24:

   ```groovy
   defaultConfig {
       minSdkVersion 24
   }
   ```

Add the following dependencies in `dependencies`:

   ```groovy
   dependencies {
       implementation 'com.google.ar.sceneform.ux:sceneform-ux:1.8.0'
       implementation 'com.google.ar.sceneform:core:1.8.0'
       implementation 'com.google.ar:core:1.31.0'
   }
   ```

### 6. Project-level build.gradle Configuration
In `android/build.gradle`, add the following in `buildscript`:

   ```groovy
   buildscript {
       repositories {
           google()
           mavenCentral()
       }
       dependencies {
           // Android Gradle Plugin version
           classpath 'com.android.tools.build:gradle:7.4.0'

           // Kotlin Gradle Plugin version
           classpath 'org.jetbrains.kotlin:kotlin-gradle-plugin:1.8.0'
       }
   }
   ```

Replace existing `subprojects` with the following two configurations:

- Force all subprojects to use Kotlin 1.8.0:

  ```groovy
  subprojects {
      afterEvaluate { project ->
          if (project.hasProperty("android")) {
              project.buildscript.dependencies.add(
                  "classpath", "org.jetbrains.kotlin:kotlin-gradle-plugin:1.8.0"
              )
          }
      }
  }
  ```

- Solve the namespace issue:

  ```groovy
  subprojects {
      project.buildDir = "${rootProject.buildDir}/${project.name}"
      afterEvaluate { project ->
          if (project.hasProperty('android')) {
              project.android {
                  if (namespace == null) {
                      namespace project.group
                  }
              }
          }
      }
  }
  ```
### 7. Ensure ARCore Support
Ensure that your device supports ARCore by checking here: https://developers.google.com/ar/devices

### 8. Clean and Rebuild

- From Android directory open a Terminal (Right click on android folder from Project and click Open In > Terminal)
   ```bash
  ./gradlew clean build
  ```
- From root directory
  ```bash
  flutter clean
  flutter run
  ```



### 9. Sample Code: Displaying a 3D Object
Create a new Dart file `arScreen.dart` with the following code:

   ```dart
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

       // Add AR content (cube) after a delay
       _addCube();
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
   ```

Call the `AR_Test` class from `main.dart`:

   ```dart
   import 'package:ar_test/arScreen.dart';
   import 'package:flutter/material.dart';

   void main() async {
     WidgetsFlutterBinding.ensureInitialized();
     runApp(MyApp());
   }

   class MyApp extends StatelessWidget {
     @override
     Widget build(BuildContext context) {
       return MaterialApp(
         home: HomeScreen(), // Home screen where the button is
       );
     }
   }

   class HomeScreen extends StatelessWidget {
     @override
     Widget build(BuildContext context) {
       return Scaffold(
         appBar: AppBar(
           title: Text('Home Screen'),
         ),
         body: Center(
           child: Column(
             children: [
               ElevatedButton(
                 onPressed: () {
                   // Navigate to the AR screen
                   Navigator.push(
                     context,
                     MaterialPageRoute(builder: (context) => AR_Test()),
                   );
                 },
                 child: Text('Go to AR Screen'),
               ),
             ],
           ),
         ),
       );
     }
   }
   ```

