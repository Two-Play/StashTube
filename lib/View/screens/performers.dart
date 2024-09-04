import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stash_app_mobile/Controler/screens/performers_controller.dart';
import 'package:stash_app_mobile/Model/state.dart';
import 'package:stash_app_mobile/util/observable.dart';

import '../../Model/screens/performers_model.dart';
import '../../util/ui_helper.dart';
import '../widgets/performer_card_widget.dart';
import 'login.dart';

class PerformersPage extends StatefulWidget {
  const PerformersPage({super.key});

  @override
  State<PerformersPage> createState() => _PerformersPageState();
}

class _PerformersPageState extends State<PerformersPage>
    with AutomaticKeepAliveClientMixin<PerformersPage> implements Observer {
  bool _loaded = false;
  final _performersController = PerformersController();

  @override
  void initState() {
    super.initState();
    _performersController.addListener(this);
    _performersController.fetchPerformers();
  }

  @override
  void dispose() {
    _performersController.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Performers'),
      ),

      body: ValueListenableBuilder(
        valueListenable: GraphQLState.client,
        builder: (context, value, child) => child!,
        child: _loaded
            ? _buildPerformerList()
            : const Center(child: CircularProgressIndicator()),
      )
    );
  }

  Widget _buildPerformerList() {
    final performerList = PerformersModel.performers;

    if (performerList.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async {
          _performersController.fetchPerformers();
          HapticFeedback.mediumImpact();
        },
        child: ListView(
          children: [
            Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 88.0),
                    child: Text(
                      'No performers found',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 58.0),
                    child: SvgPicture.asset(
                      height: 300.0,
                      'assets/images/images.svg',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        _performersController.fetchPerformers();
        HapticFeedback.mediumImpact();
      },
      child: ListView.builder(
        itemCount: performerList.length,
        itemBuilder: (context, index) {
          return PerformerCard(
            performer: performerList[index],
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void update(ObserverEvent event) {
    print("PerformersPage: $event");
    switch (event) {
      case PerformersEvents.fetchPerformersSuccess:
        print("UPDATE Scenes: $PerformersModel.scenes");
        setState(() {
          _loaded = true;
        });
        break;

      case PerformersEvents.fetchPerformersFailed:
        _loaded = true;
        if (PerformersModel.isLinkException) {
          // alert dialog and push to login page
          WidgetsBinding.instance.addPostFrameCallback((_) {
            alertDialogHelper(
              context,
              'Error',
              PerformersModel.errorMessage,
              [
                TextButton(
                  onPressed: () {
                    //Navigator.of(context).pop();
                    Navigator.of(context).pushAndRemoveUntil(
                    CupertinoPageRoute(builder: (context) => const LoginPage()),
                    (route) => false);
                  },
                  child: const Text('OK'),
                ),
                TextButton(onPressed: () {
                  Navigator.of(context).pop();
                },
                  child: const Text('Cancel'),),
              ],
            );
          });
        } else {
          // snackbar
          WidgetsBinding.instance.addPostFrameCallback((_) {
            snackBarHelper(context, PerformersModel.errorMessage);
          });
        }
        break;
    }
  }
}
