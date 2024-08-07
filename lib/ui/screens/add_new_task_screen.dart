import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/controller/add_new_task_controller.dart';
import 'package:task_manager/ui/widgets/background_widget.dart';
import 'package:task_manager/ui/widgets/centered_progress_indicator.dart';
import 'package:task_manager/ui/widgets/profile_appbar_widget.dart';
import 'package:task_manager/ui/widgets/snake_bar_message.dart';

import '../../routes.dart';


class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final _titleTEController = TextEditingController();
  final _descriptionTEController = TextEditingController();
  final _formKey = GlobalKey<FormState>();


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
                  GetBuilder<AddNewTaskController>(builder: (addNewTaskController){
                    return Visibility(
                      visible: !addNewTaskController.addNewTaskInProgress,
                      replacement: const CenteredProgressIndicator(),
                      child: ElevatedButton(
                          onPressed: ()async {
                            if (_formKey.currentState!.validate()) {
                              bool isSuccess = await addNewTaskController.addNewTasks(_titleTEController.text, _descriptionTEController.text);
                              if(isSuccess){
                                Get.offAllNamed(Routes.mainNavScreenRoutes);
                              }
                              else{
                                showSnakeBarMessage(context, 'Add New Task Failed Try Again !!!');
                              }
                            }
                          },
                          child: const Text('Add')),
                    );

                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }





  @override
  void dispose() {
    // TODO: implement dispose
    _titleTEController.dispose();
    _descriptionTEController.dispose();
    super.dispose();
  }
}
