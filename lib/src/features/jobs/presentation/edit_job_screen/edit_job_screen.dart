import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hntd/src/common_widgets/responsive_center.dart';
import 'package:hntd/src/constants/breakpoints.dart';
import 'package:hntd/src/features/jobs/domain/job.dart';
import 'package:hntd/src/features/jobs/presentation/edit_job_screen/edit_job_screen_controller.dart';
import 'package:hntd/src/utils/async_value_ui.dart';

// TODO (ikess): It is Keep Screen (Temporal implemenation)
class EditJobScreen extends ConsumerStatefulWidget {
  const EditJobScreen({super.key, this.jobId, this.job});
  final JobID? jobId;
  final Job? job;

  @override
  ConsumerState<EditJobScreen> createState() => _EditJobPageState();
}

class _EditJobPageState extends ConsumerState<EditJobScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _book;
  int? _page;

  @override
  void initState() {
    super.initState();
    if (widget.job != null) {
      _book = widget.job?.book;
      _page = widget.job?.page;
    }
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
          await ref.read(editJobScreenControllerProvider.notifier).submit(
                jobId: widget.jobId,
                oldJob: widget.job,
                book: _book ?? '',
                page: _page ?? 0,
              );
      if (success && mounted) {
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      editJobScreenControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    final state = ref.watch(editJobScreenControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.job == null ? 'New Job' : 'Edit Job'),
        actions: <Widget>[
          TextButton(
            onPressed: state.isLoading ? null : _submit,
            child: const Text(
              'Save',
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
        decoration: const InputDecoration(labelText: 'Job name'),
        keyboardAppearance: Brightness.light,
        initialValue: _book,
        validator: (value) =>
            (value ?? '').isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _book = value,
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: 'Rate per hour'),
        keyboardAppearance: Brightness.light,
        initialValue: _page != null ? '$_page' : null,
        keyboardType: const TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        onSaved: (value) => _page = int.tryParse(value ?? '') ?? 0,
      ),
    ];
  }
}
