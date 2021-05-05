import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracker_app/app/home/screens/edit_job_page.dart';
import 'package:tracker_app/app/home/screens/list_items_builder.dart';
import 'package:tracker_app/app/home/screens/news_list.dart';
import 'package:tracker_app/common_widgets/firebase_auth_exception_alert_dialog.dart';
import 'package:tracker_app/common_widgets/platform_alert_dialog.dart';
import 'package:tracker_app/services/auth.dart';
import 'package:tracker_app/services/database.dart';

import '../models/job.dart';
import 'job_list_tile.dart';

class JobsPage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await PlatformAlertDialog(
      title: 'Logout',
      content: 'Are you sure?',
      defaultActionText: 'Logout',
      cancelActionText: 'Cancel',
    ).show(context);
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jobs'),
        actions: [
          TextButton(
            onPressed: () => _confirmSignOut(context),
            child: Text(
              'Logout',
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
        ],
      ),
      body: _buildContents(context),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            heroTag: 'news',
            backgroundColor: Colors.deepOrange[900],
            child: Icon(Icons.access_time),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewsList(),
                ),
              );
            },
          ),
          FloatingActionButton(
            heroTag: 'job',
            child: Icon(Icons.add),
            onPressed: () => EditJobPage.show(context),
          ),
        ],
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context);
    return StreamBuilder<List<Job>>(
      stream: database.jobsStream(),
      builder: (BuildContext context, snapshot) {
        return ListItemsBuilder<Job>(
          snapshot: snapshot,
          itemBuilder: (context, job) => Dismissible(
            key: Key('job_${job.id}'),
            background: Container(
              color: Colors.red,
            ),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _delete(context, job),
            child: JobListTile(
              job: job,
              onTap: () => EditJobPage.show(
                context,
                job: job,
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _delete(BuildContext context, Job job) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteJob(job);
    } on FirebaseException catch (e) {
      FirebaseAuthExceptionAlertDialog(title: 'Operation failed', exception: e)
          .show(context);
    }
  }
}
