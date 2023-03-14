import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class PictureScreen extends StatefulWidget {
  final File image;

  const PictureScreen(this.image);

  State<PictureScreen> createState() => PictureState();
}

class PictureState extends State<PictureScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Image.file(widget.image),
            ),
            SizedBox(
              width: 30,
              child: CupertinoButton(
                onPressed: () => {uploadFile(widget.image)},
                child: Icon(
                  Icons.upload,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  uploadFile(File image) async {
    final token =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjQ5IiwiZW1haWwiOiJzYS5ncmVlbmlmeXZuQGdtYWlsLmNvbSIsInJvbGUiOiJTVVBFUl9BRE1JTiIsInN1YkFjY291bnRJZCI6IjYwIiwidGltZXpvbmUiOiJBc2lhL0hvX0NoaV9NaW5oIiwiY3VycmVuY3kiOiJBWk4iLCJpYXQiOjE2Nzg3MDI3NzUsImV4cCI6MTY3ODc4OTE3NX0.YaxJgu0w3odSmABs9ApKjgTSkyVoIvgoNp747c4hItE';
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json", // or whatever
      HttpHeaders.authorizationHeader: "Bearer $token",
    };
    var stream = new http.ByteStream(DelegatingStream.typed(image.openRead()));
    var length = await image.length();
    var uri = Uri.parse('http://dev.rentmynt.com/api/settings/upload-file');
    var request = new http.MultipartRequest("POST", uri);
    var multipartFileSign = new http.MultipartFile('file', stream, length,
        filename: basename(image.path));
    request.files.add(multipartFileSign);
    request.headers.addAll(headers);
    var response = await request.send();

    print(response.statusCode);

    // listen for response
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }
}
