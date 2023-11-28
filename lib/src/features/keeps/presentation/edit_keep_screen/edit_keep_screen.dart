import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hntd/src/common_widgets/responsive_center.dart';
import 'package:hntd/src/constants/breakpoints.dart';
import 'package:hntd/src/features/keeps/domain/keep.dart';
import 'package:hntd/src/features/keeps/presentation/edit_keep_screen/edit_keep_screen_controller.dart';
import 'package:hntd/src/utils/async_value_ui.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

  Future<void> _submit_edit() async {
    if (_validateAndSaveForm()) {
      final success =
          await ref.read(editKeepScreenControllerProvider.notifier).submit(
                keepId: widget.keep?.id,
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

  Future<void> _submit_add() async {
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
    bool is_editting = false;
    if (widget.keep?.note != "") {
      is_editting = true;
    }
    ref.listen<AsyncValue>(
      editKeepScreenControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    final state = ref.watch(editKeepScreenControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(!is_editting ? '말씀 노트 추가' : '말씀 노트 수정'),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              state.isLoading
                  ? null
                  : is_editting
                      ? await _submit_edit()
                      : await _submit_add();
              Fluttertoast.showToast(
                msg: "반영되었습니다.",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                backgroundColor: Colors.green,
                textColor: Colors.black87,
              );
            },
            child: const Text(
              '완료',
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
        padding: const EdgeInsets.all(4.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Container(
          padding: const EdgeInsets.only(
              left: 16.0, right: 16.0, top: 4.0, bottom: 4.0),
          child: Column(children: _buildFormChildren())),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        decoration: const InputDecoration(labelText: '제목'),
        keyboardAppearance: Brightness.light,
        initialValue: _title,
        enabled: false, // Set enabled to false
        validator: (value) =>
            (value ?? '').isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _title = value,
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: '구절'),
        keyboardAppearance: Brightness.light,
        initialValue: _verse != null ? '$_verse' : null,
        enabled: false, // Set enabled to false
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
