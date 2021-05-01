import 'package:ecommerce_store_admin/blocs/inventory_bloc/inventory_bloc.dart';
import 'package:ecommerce_store_admin/blocs/push_notifications_bloc/push_notifications_bloc.dart';
import 'package:ecommerce_store_admin/models/inventory_analytics.dart';
import 'package:ecommerce_store_admin/screens/push_notifications_screens/send_notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class PushNotificationsPage extends StatefulWidget {
  @override
  _PushNotificationsPageState createState() => _PushNotificationsPageState();
}

class _PushNotificationsPageState extends State<PushNotificationsPage>
    with AutomaticKeepAliveClientMixin {
  PushNotificationsBloc pushNotificationsBloc;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 20.0,
        ),
        scrollDirection: Axis.vertical,
        children: <Widget>[
          // ClipRRect(
          //   borderRadius: BorderRadius.circular(15.0),
          //   child: Material(
          //     child: InkWell(
          //       splashColor: Colors.red.withOpacity(0.3),
          //       onTap: () {
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //             builder: (context) => LowInventoryScreen(),
          //           ),
          //         );
          //       },
          //       child: Container(
          //         padding: const EdgeInsets.all(15.0),
          //         decoration: BoxDecoration(
          //           color: Colors.black.withOpacity(0.01),
          //           borderRadius: BorderRadius.circular(15.0),
          //           border: Border.all(
          //             width: 1.0,
          //             style: BorderStyle.solid,
          //             color: Colors.black.withOpacity(0.08),
          //           ),
          //         ),
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.center,
          //           mainAxisAlignment: MainAxisAlignment.start,
          //           mainAxisSize: MainAxisSize.min,
          //           children: <Widget>[
          //             Container(
          //               width: size.width * 0.25,
          //               height: size.width * 0.25,
          //               padding: const EdgeInsets.all(15.0),
          //               alignment: Alignment.center,
          //               decoration: BoxDecoration(
          //                 shape: BoxShape.circle,
          //                 color: Colors.red.withOpacity(0.2),
          //               ),
          //               child: Icon(
          //                 Icons.notifications_active,
          //                 color: Colors.red.shade500,
          //                 size: size.width * 0.1,
          //               ),
          //             ),
          //             // SizedBox(
          //             //   height: 15.0,
          //             // ),
          //             // Text(
          //             //   '${inventoryAnalytics.lowInventory}',
          //             //   style: GoogleFonts.poppins(
          //             //     color: Colors.black87,
          //             //     fontSize: 18.0,
          //             //     fontWeight: FontWeight.w600,
          //             //   ),
          //             // ),
          //             SizedBox(
          //               height: 15.0,
          //             ),
          //             Text(
          //               'All Previous Notifications',
          //               style: GoogleFonts.poppins(
          //                 color: Colors.black54,
          //                 fontSize: 15.0,
          //                 fontWeight: FontWeight.w500,
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          // SizedBox(
          //   height: 15.0,
          // ),
          ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Material(
              child: InkWell(
                splashColor: Colors.blue.withOpacity(0.3),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SendNotificationScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.01),
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                      width: 1.0,
                      style: BorderStyle.solid,
                      color: Colors.black.withOpacity(0.08),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            Icons.send,
                            size: 19,
                            color: Colors.black.withOpacity(0.7),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            'Send Notification',
                            style: GoogleFonts.poppins(
                              color: Colors.black54,
                              fontSize: 14.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 55.0,
                        height: 55.0,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue.withOpacity(0.2),
                        ),
                        child: Icon(
                          Icons.notifications,
                          color: Colors.blue.shade500,
                          size: 23.0,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
