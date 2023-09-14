import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:starter_architecture_flutter_firebase/src/common_widgets/responsive_center.dart';
import 'package:starter_architecture_flutter_firebase/src/constants/breakpoints.dart';
import 'package:starter_architecture_flutter_firebase/src/features/jobs/domain/job.dart';
import 'package:starter_architecture_flutter_firebase/src/features/jobs/presentation/edit_job_screen/edit_job_screen_controller.dart';
import 'package:starter_architecture_flutter_firebase/src/utils/async_value_ui.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class EditJobScreen extends ConsumerStatefulWidget {
  const EditJobScreen({super.key, this.jobId, this.job});
  final JobID? jobId;
  final Job? job;

  @override
  ConsumerState<EditJobScreen> createState() => _EditJobPageState();
}

class _EditJobPageState extends ConsumerState<EditJobScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _name;
  int? _ratePerHour;

  @override
  void initState() {
    super.initState();
    if (widget.job != null) {
      _name = widget.job?.name;
      _ratePerHour = widget.job?.ratePerHour;
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
                name: _name ?? '',
                ratePerHour: _ratePerHour ?? 0,
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
        initialValue: _name,
        validator: (value) =>
            (value ?? '').isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _name = value,
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: 'Rate per hour'),
        keyboardAppearance: Brightness.light,
        initialValue: _ratePerHour != null ? '$_ratePerHour' : null,
        keyboardType: const TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        onSaved: (value) => _ratePerHour = int.tryParse(value ?? '') ?? 0,
      ),
    ];
  }
}


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = PageController(viewportFraction: 0.8, keepPage: true);

  @override
  Widget build(BuildContext context) {
    final pages = List.generate(
        6,
            (index) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.transparent,
          ),
          // margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Center(
                child: Text(
                  "Page $index",
                  style: TextStyle(color: Colors.indigo),
                )),
          ),
        ));

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 16),
              SizedBox(

                height: MediaQuery.of(context).size.height - 250,
                child: PageView.builder(
                  controller: controller,
                  // itemCount: pages.length,
                  itemBuilder: (_, index) {
                    return pages[index % pages.length];
                  },
                ),
              ),
              SizedBox(height: 16),
              SmoothPageIndicator(
                controller: controller,
                count: pages.length,
                effect: const WormEffect(
                  dotHeight: 5,
                  dotWidth: 5,
                  type: WormType.thinUnderground,
                ),
              ),
              //
              // Padding(
              //   padding: const EdgeInsets.only(top: 16, bottom: 8),
              //   child: Text(
              //     'Jumping Dot',
              //     style: TextStyle(color: Colors.black54),
              //   ),
              // ),
              // Container(
              //   child: SmoothPageIndicator(
              //     controller: controller,
              //     count: pages.length,
              //     effect: JumpingDotEffect(
              //       dotHeight: 16,
              //       dotWidth: 16,
              //       jumpScale: .7,
              //       verticalOffset: 15,
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 16, bottom: 12),
              //   child: Text(
              //     'Scrolling Dots',
              //     style: TextStyle(color: Colors.black54),
              //   ),
              // ),
              // SmoothPageIndicator(
              //     controller: controller,
              //     count: pages.length,
              //     effect: ScrollingDotsEffect(
              //       activeStrokeWidth: 2.6,
              //       activeDotScale: 1.3,
              //       maxVisibleDots: 5,
              //       radius: 8,
              //       spacing: 10,
              //       dotHeight: 12,
              //       dotWidth: 12,
              //     )),
              // Padding(
              //   padding: const EdgeInsets.only(top: 16, bottom: 16),
              //   child: Text(
              //     'Customizable Effect',
              //     style: TextStyle(color: Colors.black54),
              //   ),
              // ),
              // Container(
              //   // color: Colors.red.withOpacity(.4),
              //   child: SmoothPageIndicator(
              //     controller: controller,
              //     count: pages.length,
              //     effect: CustomizableEffect(
              //       activeDotDecoration: DotDecoration(
              //         width: 32,
              //         height: 12,
              //         color: Colors.indigo,
              //         rotationAngle: 180,
              //         verticalOffset: -10,
              //         borderRadius: BorderRadius.circular(24),
              //         // dotBorder: DotBorder(
              //         //   padding: 2,
              //         //   width: 2,
              //         //   color: Colors.indigo,
              //         // ),
              //       ),
              //       dotDecoration: DotDecoration(
              //         width: 24,
              //         height: 12,
              //         color: Colors.grey,
              //         // dotBorder: DotBorder(
              //         //   padding: 2,
              //         //   width: 2,
              //         //   color: Colors.grey,
              //         // ),
              //         // borderRadius: BorderRadius.only(
              //         //     topLeft: Radius.circular(2),
              //         //     topRight: Radius.circular(16),
              //         //     bottomLeft: Radius.circular(16),
              //         //     bottomRight: Radius.circular(2)),
              //         borderRadius: BorderRadius.circular(16),
              //         verticalOffset: 0,
              //       ),
              //       spacing: 6.0,
              //       // activeColorOverride: (i) => colors[i],
              //       inActiveColorOverride: (i) => colors[i],
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 32.0),
            ],
          ),
        ),
      ),
    );
  }
}

final colors = const [
  Colors.red,
  Colors.green,
  Colors.greenAccent,
  Colors.amberAccent,
  Colors.blue,
  Colors.amber,
];