import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FileUploadField extends StatefulWidget {
  final String label;
  final IconData icon;
  final Function(XFile) onFileSelected;

  FileUploadField({
    required this.label,
    required this.icon,
    required this.onFileSelected,
  });

  @override
  _FileUploadFieldState createState() => _FileUploadFieldState();
}

class _FileUploadFieldState extends State<FileUploadField> {
  XFile? _file;

  Future<void> _pickFile() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _file = pickedFile;
      });
      widget.onFileSelected(pickedFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: _pickFile,
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: Color(0xFF2C2C2C),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey),
            ),
            child: Row(
              children: [
                Icon(widget.icon, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _file != null ? _file!.name : widget.label,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
