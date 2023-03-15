import 'package:flutter/material.dart';

class AdminUploadItemScreen extends StatefulWidget {
  const AdminUploadItemScreen({Key? key}) : super(key: key);

  @override
  State<AdminUploadItemScreen> createState() => _AdminUploadItemScreenState();
}

class _AdminUploadItemScreenState extends State<AdminUploadItemScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body : const Center(
        child: Text("Upload Screen"),
      ),
    );
  }
}
