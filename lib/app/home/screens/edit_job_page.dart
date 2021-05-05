import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracker_app/app/home/models/job.dart';
import 'package:tracker_app/common_widgets/firebase_auth_exception_alert_dialog.dart';
import 'package:tracker_app/common_widgets/platform_alert_dialog.dart';
import 'package:tracker_app/services/database.dart';

class EditJobPage extends StatefulWidget {
  const EditJobPage({Key key, this.database, this.job}) : super(key: key);
  final Database database;
  final Job job;

  static Future<void> show(BuildContext context, {Job job}) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditJobPage(
          database: database,
          job: job,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditJobPageState createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  @override
  void initState() {
    super.initState();
    if (widget.job != null) {
      _name = widget.job.name;
      _ratePerHour = widget.job.ratePerHour;
    }
  }

  final _formKey = GlobalKey<FormState>();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _ratePerHourFocusNode = FocusNode();
  String _name;
  int _ratePerHour;

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _nameEditingComplete() {
    print('name editing complete');
    if (_validateAndSaveForm())
      FocusScope.of(context).requestFocus(_ratePerHourFocusNode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.job == null ? 'New Job' : 'Edit Job'),
        actions: [
          TextButton(
              onPressed: _submit,
              child: Text(
                'Save',
                style: TextStyle(fontSize: 18, color: Colors.white),
              )),
        ],
      ),
      body: _buildContents(),
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
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
        initialValue: _name,
        autocorrect: false,
        enableSuggestions: false,
        focusNode: _nameFocusNode,
        onEditingComplete: _nameEditingComplete,
        decoration: InputDecoration(labelText: 'Job name'),
        onSaved: (value) => _name = value,
        validator: (value) => value.isNotEmpty ? null : 'Name cannot be empty',
      ),
      TextFormField(
        initialValue: _ratePerHour != null ? '$_ratePerHour' : null,
        focusNode: _ratePerHourFocusNode,
        onEditingComplete: _submit,
        decoration: InputDecoration(labelText: 'Rate per hour '),
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        onSaved: (value) => _ratePerHour = int.tryParse(value) ?? 0,
      ),
    ];
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        final jobs = await widget.database.jobsStream().first;
        final allNames = jobs.map((e) => e.name).toList();
        if (widget.job != null) {
          allNames.remove(widget.job.name);
        }
        if (allNames.contains(_name)) {
          PlatformAlertDialog(
            title: 'Name is already used',
            content: 'Please choose a different job name',
            defaultActionText: 'OK',
          ).show(context);
        } else {
          final id = widget.job?.id ?? documentIdFromCurrentDate();
          final job = Job(id: id, name: _name, ratePerHour: _ratePerHour);
          await widget.database.setJob(job);
          Navigator.of(context).pop();
        }
      } on FirebaseException catch (e) {
        FirebaseAuthExceptionAlertDialog(
                title: 'Operation failed', exception: e)
            .show(context);
      }
    }
  }
}
