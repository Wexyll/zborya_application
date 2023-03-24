import 'dart:convert';
import 'dart:math';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:camera/camera.dart';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:zboryar_application/constants/constants.dart';

import '../../database/hive/model/boxes.dart';
import '../../database/hive/model/invWeapon.dart';
import '../../domain/weapon.dart';
import '../../main.dart';
import 'confirmation.dart';

class cameraPage extends StatefulWidget {
  cameraPage({Key? key}) : super(key: key);

  @override
  State<cameraPage> createState() => _cameraPageState();
}

class _cameraPageState extends State<cameraPage> {
  //Camera Controller
  dynamic controller;

  //List of Weapons
  var wMap = new Map();

  //List of Weapon Objects
  List<Weapon> wList = [];

  //Is Camera Controller busy?
  bool isBusy = false;

  //Confidence check for above 50% confidence
  bool confidence = false;

  //Is the Camera Scanning?
  bool scanning = false;

  dynamic objectDetector;

  late Size size;

  @override
  void initState() {
    super.initState();
    //TODO: add onpressed to this
    initializeCamera();
  }

  //Init Camera, Init ObjectDetector Model, Launch Camera Stream, Feed Detector Frames
  initializeCamera() async {
    final mode = DetectionMode.stream;
    final modelPath = await _getModel('assets/ml/model.tflite');
    final options = LocalObjectDetectorOptions(
        modelPath: modelPath,
        classifyObjects: true,
        multipleObjects: false,
        confidenceThreshold: 0.5,
        mode: mode);
    objectDetector = ObjectDetector(options: options);

    controller = CameraController(cameras[0], ResolutionPreset.high);
    //If camera is mounted then begin object detection using ML Kit

    await controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      controller.startImageStream((image) => {
            if (!isBusy)
              {isBusy = true, img = image, doObjectDetectionOnFrame()}
          });
    });
  }

  //close all resources
  @override
  void dispose() {
    controller?.dispose();
    objectDetector.close();
    super.dispose();
  }

  //Retrieving Model from Assets
  Future<String> _getModel(String assetPath) async {
    if (Platform.isAndroid) {
      return 'flutter_assets/$assetPath';
    }
    final path = '${(await getApplicationSupportDirectory()).path}/$assetPath';
    await Directory(dirname(path)).create(recursive: true);
    final file = File(path);
    if (!await file.exists()) {
      final byteData = await rootBundle.load(assetPath);
      await file.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    }
    return file.path;
  }

  dynamic _scanResults;
  CameraImage? img;

  //Perform Object Detection on each frame and create a list of the objects found.
  doObjectDetectionOnFrame() async {
    var frameImg = getInputImage();

    List<DetectedObject> objects = await objectDetector.processImage(frameImg);
    List<DetectedObject> empty = [];

    for (final object in objects) {
      var list = object.labels;
      for (Label label in list) {
        if (label.confidence >= 0.5) {
           confidence = true;
        } else {
          confidence = false;
        }
      }
    }

    //If Confidence is greater than 50% then highlight, if not feed an empty array
    if(confidence == true) {
      setState(() {
        _scanResults = objects;
      });
    }else {
      setState(() {
        _scanResults = empty;
      });
    }
    isBusy = false;
  }

  //Retrieving and Formatting input Image
  InputImage getInputImage() {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in img!.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();
    final Size imageSize = Size(img!.width.toDouble(), img!.height.toDouble());
    final camera = cameras[0];
    final imageRotation =
        InputImageRotationValue.fromRawValue(camera.sensorOrientation);
    // if (imageRotation == null) return;

    final inputImageFormat =
        InputImageFormatValue.fromRawValue(img!.format.raw);
    // if (inputImageFormat == null) return null;

    final planeData = img!.planes.map(
      (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: imageRotation!,
      inputImageFormat: inputImageFormat!,
      planeData: planeData,
    );

    final inputImage =
        InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);

    return inputImage;
  }

  //Show rectangles around detected objects
  Widget buildResult() {
    if (_scanResults == null ||
        controller == null ||
        !controller.value.isInitialized) {
      return Text('');
    }

    final Size imageSize = Size(
      controller.value.previewSize!.height,
      controller.value.previewSize!.width,
    );
    CustomPainter painter = ObjectDetectorPainter(imageSize, _scanResults);
    return CustomPaint(
      painter: painter,
    );
    return Container();
  }

  //Function to scan a new object and add it to the array of weapons. Adds name and quantity
  objectAddition() async {
    var frameImg = getInputImage();
    final objects = await objectDetector.processImage(frameImg);
    String weapon = '';
    for (final object in objects) {
      weapon += '${object.labels.map((e) => e.text)}';
    }
    weapon = weapon.replaceAll(RegExp(r'\(|\)'), '');
    print(weapon);


    //Creating hashmap of weapons that have been scanned from object detector
    if(wMap.isEmpty && weapon != ''){ //If nothing is added yet
      wMap[weapon]=1;
    } else if(wMap.containsKey(weapon)) { //If the weapon has already been scanned
      wMap.update(weapon, (int) => wMap[weapon]+1);
    } else  if(!wMap.containsKey(weapon) && weapon != ''){ //If it is a new weapon
      wMap[weapon] = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> stackChildren = [];
    size = MediaQuery.of(context).size;
    if (controller != null) {
      stackChildren.add(
        Positioned(
          top: 0.0,
          left: 0.0,
          width: size.width,
          height: size.height,
          child: Container(
            child: (controller.value.isInitialized)
                ? AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: CameraPreview(controller),
                  )
                : Container(),
          ),
        ),
      );

      //If the child is scanning then highlight objects
      if (scanning == true) {
        stackChildren.add(
          Positioned(
            top: 0.0,
            left: 0.0,
            width: size.width,
            height: size.height,
            child: buildResult(),
          ),
        );
      }

      //Scanning button
      stackChildren.add(
        Positioned(
            child: Padding(
          padding: EdgeInsets.all(10),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: InkWell(
              onTap: () async {
                if (scanning == false) {
                  scanning = true;
                } else {
                  //If Scanning is finished and the weapons hashmap is not empty then transfer the list to a new listview page to confirm additions
                  if(!wMap.isEmpty) {
                    scanning = false;
                    final String response = await rootBundle.loadString(
                        'assets/json/weapons.json');
                    final data = await json.decode(response);

                    //Adding an instance of an object to the weapons list of Weapon Objects
                    for(int j = 0; j <= data["weapons"].length-1; j++) {
                      if(wMap.containsKey(data["weapons"][j]["Name"])){
                        wList.add(Weapon.create(name: data["weapons"][j]["Name"], quantity: wMap[data["weapons"][j]["Name"]], type: data["weapons"][j]["Type"], caliber: data["weapons"][j]["Caliber"], roundC: data["weapons"][j]["Round_Count"], magC: data["weapons"][j]["Mag_Count"]));
                      }
                    }

                    //Pushing Data to a new page
                    print(wList[0].caliber);
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => confirmWeapons(wpnList: wList,),
                        ));
                    wList.clear();
                  } else{
                    scanning = false;
                  }
                  // wList = [];
                  // wMap.clear();
                }
              },
              //Changing Circle Icon Color
              child: (scanning == false)
                  ? Icon(
                      Icons.circle_outlined,
                      size: 90,
                      color: Colors.white,
                    )
                  : Icon(
                      Icons.circle_outlined,
                      size: 90,
                      color: Colors.red,
                    ),
            ),
          ),
        )),
      );

      //Snackbar on press of the addition button and calling of the addition function
      if (scanning == true) {
        stackChildren.add(
          Positioned(
              child: Padding(
            padding: EdgeInsets.fromLTRB(70, 00, 0, 30),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: InkWell(
                onTap: () {
                  objectAddition();
                  AnimatedSnackBar(
                    mobileSnackBarPosition: MobileSnackBarPosition.top,
                    duration: Duration(milliseconds: 5),
                    snackBarStrategy: RemoveSnackBarStrategy(),
                    builder: ((context) {
                      return Container(
                        height: 40,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: bg_login,
                        ),
                        child: Text('Weapon Added', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),),
                      );
                    }),
                  ).show(context);
                },
                child: Icon(
                  Icons.add,
                  size: 50,
                  color: Colors.white,
                ),
              ),
            ),
          )),
        );
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(top: 0),
          color: Colors.black,
          child: Stack(
            children: stackChildren,
          ),
        ),
      ),
    );
  }
}

//Paint the Objects detected in the cameraView
class ObjectDetectorPainter extends CustomPainter {
  ObjectDetectorPainter(this.imageSize, this.objects);

  final Size imageSize;
  final List<DetectedObject> objects;

  @override
  void paint(Canvas canvas, Size size) {
    final double X = size.width / imageSize.width;
    final double Y = size.height / imageSize.height;
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.pinkAccent;

    for (DetectedObject detectedObject in objects) {
      canvas.drawRect(
        Rect.fromLTRB(
          detectedObject.boundingBox.left * X,
          detectedObject.boundingBox.top * Y,
          detectedObject.boundingBox.right * X,
          detectedObject.boundingBox.bottom * Y,
        ),
        paint,
      );

      var list = detectedObject.labels;
      for (Label label in list) {
        //print("${label.text}   ${label.confidence.toStringAsFixed(2)}");
        TextSpan span = TextSpan(
            text: label.text,
            style: const TextStyle(fontSize: 25, color: Colors.blue));
        TextPainter tp = TextPainter(
            text: span,
            textAlign: TextAlign.left,
            textDirection: TextDirection.ltr);
        tp.layout();
        tp.paint(
            canvas,
            Offset(detectedObject.boundingBox.left * X,
                detectedObject.boundingBox.top * Y));
        break;
      }
    }
  }

  @override
  bool shouldRepaint(ObjectDetectorPainter oldDelegate) {
    return oldDelegate.imageSize != imageSize || oldDelegate.objects != objects;
  }
}

/*if (controller?.value.isInitialized == false) {
      return Container();
    }

    final size = MediaQuery.of(context).size;
    // calculate scale depending on screen and camera ratios
    // this is actually size.aspectRatio / (1 / camera.aspectRatio)
    // because camera preview size is received as landscape
    // but we're calculating for portrait orientation
    var scale = size.aspectRatio * controller!.value.aspectRatio;

    // to prevent scaling down, invert the value
    if (scale < 1) scale = 1 / scale;

    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Transform.scale(
            scale: scale,
            child: Center(
              child:
                   CameraPreview(controller!),
            ),
          ),
        ],
      ),
    );
    //print(data["weapons"].length);
                    // print();
                    //print(data["weapons"][0]["Name"]); //Name
                    //print(data["weapons"][0]["Type"]); //Type
                    //print(wMap[data["weapons"][0]["Name"]]); QUANTITY
                    //print(wMap["SV98"]);
    */

/*
final String response = await rootBundle.loadString(
                        'assets/json/weapons.json');
                    final data = await json.decode(response);
                    for(int j = 0; j <= data["weapons"].length-1; j++) {
                      if(wMap.containsKey(data["weapons"][j]["Name"])){
                        wList.add(Weapon.create(name: data["weapons"][j]["Name"], quantity: wMap[data["weapons"][0]["Name"]], type: data["weapons"][0]["Type"], caliber: data["weapons"][0]["Caliber"]));
                      }
                    }
                    print(wList[0].caliber);
 */
