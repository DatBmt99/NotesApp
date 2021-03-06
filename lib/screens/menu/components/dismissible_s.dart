import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:notes/models/status_model.dart';
import 'package:notes/screens/menu/edit_status.dart';

import 'package:notes/services/data.dart';
import 'package:provider/provider.dart';
import '../../../widgets/custom_alert_dialog.dart';
import 'package:http/http.dart' as http;

class CustomDismissible extends StatelessWidget {
  final List<Status> status;
  final int index;
  const CustomDismissible({Key key, this.status, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var data = context.watch<Data>();

    return Dismissible(
      key: ValueKey(status[index].statusName),
      direction: DismissDirection.endToStart,
      child: Card(
        child: ListTile(
          title: Text(
            status[index].statusName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
          ),
          onTap: () {
           String selectedId = status[index].id;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditStatus(id: selectedId)));
          },
          contentPadding: EdgeInsets.all(17),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      background: Padding(
        padding: EdgeInsets.only(right: 30),
        child: Align(
          alignment: Alignment.centerRight,
          child: Icon(FontAwesomeIcons.trashAlt,
              color: Color(0xFFFA8182), size: 28),
        ),
      ),
      onDismissed: (direction) async {
        await data.deleteStatus(http.Client(), this.status[index].id);
      },
      confirmDismiss: (direction) => showDialog(
          context: context, builder: (context) => CustomAlertDialog()),
    );
  }
}
