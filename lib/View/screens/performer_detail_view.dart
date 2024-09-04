import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stash_app_mobile/Model/screens/performer_detail_view_model.dart';
import 'package:stash_app_mobile/util/observable.dart';
import 'package:stash_app_mobile/util/ui_helper.dart';
import '../../Controler/screens/performer_detail_view_controller.dart';

class PerformerDetailsPage extends StatefulWidget {
  final int performerId;

  const PerformerDetailsPage({super.key, required this.performerId});

  @override
  _PerformerDetailsPageState createState() => _PerformerDetailsPageState();
}

class _PerformerDetailsPageState extends State<PerformerDetailsPage> implements Observer {
  dynamic performer;
  late PerformerDetailViewController controller;

  @override
  void initState() {
    super.initState();
    controller = PerformerDetailViewController(widget.performerId);
    controller.addListener(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Performer Details'),
      ),
      body: FutureBuilder(
        future: controller.fetchPerformer(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: CachedNetworkImage(
                    height: 550,
                    imageUrl: performer?['image_path'] ?? '',
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      ListTile(
                        title: Text('Performer ID: ${performer?['id'] ?? ''}'),
                      ),
                      ListTile(
                        title: Text('Performer Name: ${performer?['name'] ?? ''}'),
                      ),
                      ListTile(
                        title: Text('Performer Country: ${performer?['country'] ?? ''}'),
                      ),
                      ListTile(
                        title: Text('Performer Birthdate: ${performer?['birthdate'] ?? ''}'),
                      ),
                      ListTile(
                        title: Text('Performer Rating: ${performer?['rating100'] ?? ''}'),
                      ),
                      ListTile(
                        title: Text('Performer Favorite: ${performer?['favorite'] ?? ''}'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  @override
  void update(ObserverEvent event) {
    switch (event) {
      case NetworkEvents.fetchSuccess:
        performer = PerformerDetailViewModel.performer;
        break;
      case NetworkEvents.fetchFailed:
        alertDialogHelper(context, "Error", PerformerDetailViewModel.errorMessage,
          [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
        break;
    }
  }

  @override
  void dispose() {
    controller.removeListener(this);
    super.dispose();
  }
}