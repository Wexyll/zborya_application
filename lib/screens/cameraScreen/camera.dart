import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:camera/camera.dart';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../main.dart';

class cameraPage extends StatefulWidget {
  cameraPage({Key? key}) : super(key: key);

  @override
  State<cameraPage> createState() => _cameraPageState();
}

class _cameraPageState extends State<cameraPage> {
  dynamic controller;

  bool isBusy = false;

  dynamic objectDetector;

  late Size size;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  initializeCamera() async {
    final mode = DetectionMode.stream;
    final modelPath = await _getModel('assets/ml/model.tflite');
    final options = LocalObjectDetectorOptions(
        modelPath: modelPath,
        classifyObjects: true,
        multipleObjects: true,
        mode: mode);
    objectDetector = ObjectDetector(options: options);

    controller = CameraController(cameras[0], ResolutionPreset.high);
    //If camera is mounted then begin object detection using ML Kit
    await controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      controller.startImageStream((image) =>
      {
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
    print("len= ${objects.length}");
    setState(() {
      _scanResults = objects;
    });
    isBusy = false;
  }

  InputImage getInputImage() {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in img!.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes
        .done()
        .buffer
        .asUint8List();
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
  }


  @override
  Widget build(BuildContext context) {
    List<Widget> stackChildren = [];
    size = MediaQuery
        .of(context)
        .size;
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

      stackChildren.add(
        Positioned(
            top: 0.0,
            left: 0.0,
            width: size.width,
            height: size.height,
            child: buildResult()),
      );
    }

      return Scaffold(
        body: Container(
            margin: EdgeInsets.only(top: 0),
            color: Colors.black,
            child: Stack(
              children: stackChildren,
            )),
      );
    }
}



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
        print("${label.text}   ${label.confidence.toStringAsFixed(2)}");
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
    );*/
