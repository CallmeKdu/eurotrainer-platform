import 'package:flutter/material.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'manager_assign_viewmodel.dart';

class ManagerUploadViewModel extends ChangeNotifier {
  final ManagerAssignViewModel _assignViewModel;

  ManagerUploadViewModel(this._assignViewModel);

  bool _isUploading = false;
  bool get isUploading => _isUploading;

  double _uploadProgress = 0.0;
  double get uploadProgress => _uploadProgress;

  String? _selectedFileName;
  String? get selectedFileName => _selectedFileName;

  String _courseTitle = '';
  String _courseDescription = '';

  void setCourseTitle(String title) {
    _courseTitle = title;
    notifyListeners();
  }

  void setCourseDescription(String desc) {
    _courseDescription = desc;
    notifyListeners();
  }

  bool get canUpload => _courseTitle.isNotEmpty && _courseDescription.isNotEmpty;

  Future<void> pickAndUploadScorm() async {
    final uploadInput = html.FileUploadInputElement();
    uploadInput.accept = '.zip'; // Aceita SCORM (que é um ZIP)
    uploadInput.click();

    uploadInput.onChange.listen((e) async {
      final files = uploadInput.files;
      if (files != null && files.isNotEmpty) {
        final file = files[0];
        _selectedFileName = file.name;
        _isUploading = true;
        _uploadProgress = 0.0;
        notifyListeners();

        // Simulate upload progress
        for (int i = 1; i <= 10; i++) {
          await Future.delayed(const Duration(milliseconds: 300));
          _uploadProgress = i / 10.0;
          notifyListeners();
        }

        // Add to courses list
        _assignViewModel.allCourses.add(
          CourseData('c_${DateTime.now().millisecondsSinceEpoch}', _courseTitle),
        );

        _isUploading = false;
        notifyListeners();
      }
    });
  }
}
