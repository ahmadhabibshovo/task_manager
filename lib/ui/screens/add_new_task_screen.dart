import 'package:flutter/material.dart';
import 'package:task_manager/data/model/network_response.dart';
import 'package:task_manager/data/network_caller/network_caller.dart';
import 'package:task_manager/ui/widgets/background_widget.dart';
import 'package:task_manager/ui/widgets/centered_progress_indicator.dart';
import 'package:task_manager/ui/widgets/profile_appbar_widget.dart';
import 'package:task_manager/ui/widgets/snake_bar_message.dart';

import '../../data/utilities/urls.dart';
import 'main_bottom_nav_screen.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final _titleTEController = TextEditingController();
  final _descriptionTEController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _addNewTaskInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar(context),
      body: BackgroundWidget(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter title';
                      }
                      return null;
                    },
                    controller: _titleTEController,
                    decoration: const InputDecoration(hintText: 'Title'),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter description';
                      }
                      return null;
                    },
                    controller: _descriptionTEController,
                    decoration: const InputDecoration(hintText: 'Description'),
                    maxLines: 4,
                  ),
                  Visibility(
                    visible: _addNewTaskInProgress == false,
                    replacement: const CenteredProgressIndicator(),
                    child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _addNewTask();
                          }
                        },
                        child: const Text('Add')),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addNewTask() async {
    _addNewTaskInProgress = true;
    if (mounted) {
      setState(() {});
    }
    Map<String, dynamic> requestData = {
      'title': _titleTEController.text.trim(),
      'description': _descriptionTEController.text.trim(),
      'status': 'New',
    };
    NetworkResponse response =
        await NetworkCaller.postRequest(Urls.createTask, body: requestData);
    _addNewTaskInProgress = false;
    setState(() {});
    if (response.isSuccess) {
      _clearTextFields();
      if (mounted) {
        showSnakeBarMessage(context, 'New task added!!');
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (ctx) => MainBottomNavScreen()),
            (route) => false);
      }
    } else {
      if (mounted) {
        showSnakeBarMessage(context, 'New task add failed try Again!!', true);
      }
    }
  }

  void _clearTextFields() {
    _titleTEController.clear();
    _descriptionTEController.clear();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _titleTEController.dispose();
    _descriptionTEController.dispose();
    super.dispose();
  }
}
