import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:starter_architecture_flutter_firebase/src/common_widgets/responsive_center.dart';
import 'package:starter_architecture_flutter_firebase/src/constants/breakpoints.dart';
import 'package:starter_architecture_flutter_firebase/src/features/keeps/domain/keep.dart';
import 'package:starter_architecture_flutter_firebase/src/features/keeps/presentation/edit_keep_screen/edit_keep_screen_controller.dart';
import 'package:starter_architecture_flutter_firebase/src/utils/async_value_ui.dart';

// TODO (ikess): It is Keep Screen (Temporal implemenation)
class EditKeepScreen extends ConsumerStatefulWidget {
  const EditKeepScreen({super.key, this.keepId, this.keep});
  final KeepID? keepId;
  final Keep? keep;

  @override
  ConsumerState<EditKeepScreen> createState() => _EditKeepScreenState();
}

class _EditKeepScreenState extends ConsumerState<EditKeepScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _title;
  String? _verse;
  String? _note;

  @override
  void initState() {
    super.initState();
    print("widget.keep: ${widget.keep}");
    // if (widget.keep != null) {
      _title = widget.keep?.title;
      _verse = widget.keep?.verse;
      _note = widget.keep?.note;
    // }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      final success =
          await ref.read(editKeepScreenControllerProvider.notifier).submit(
                keepId: widget.keepId,
                oldKeep: widget.keep,
                title: _title ?? '',
                verse: _verse ?? '',
                note: _note ?? '',
              );
      if (success && mounted) {
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      editKeepScreenControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    final state = ref.watch(editKeepScreenControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.keep == null ? '말씀 노트' : '말씀 간직하기'),
        actions: <Widget>[
          TextButton(
            onPressed: state.isLoading ? null : _submit,
            child: const Text(
              '닫기',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ],
      ),
      body: _buildContents(),
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: ResponsiveCenter(
        maxContentWidth: Breakpoint.tablet,
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        decoration: const InputDecoration(labelText: '제목'),
        keyboardAppearance: Brightness.light,
        initialValue: _title,
        validator: (value) =>
            (value ?? '').isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _title = value,
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: '구절'),
        keyboardAppearance: Brightness.light,
        initialValue: _verse != null ? '$_verse' : null,
        keyboardType: const TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        onSaved: (value) => _verse = value,
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: '노트'),
        keyboardAppearance: Brightness.light,
        initialValue: _note != null ? '$_note' : null,
        keyboardType: const TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        onSaved: (value) => _note = value,
      ),
    ];
  }
}
