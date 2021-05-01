import 'package:ecommerce_store_admin/screens/manage_coupons_screen/add_coupon_screen.dart';
import 'package:ecommerce_store_admin/screens/manage_coupons_screen/all_coupons_screen.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class ManageCouponsPage extends StatefulWidget {
  @override
  _ManageCouponsPageState createState() => _ManageCouponsPageState();
}

class _ManageCouponsPageState extends State<ManageCouponsPage>
    with AutomaticKeepAliveClientMixin {
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
          ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Material(
              child: InkWell(
                splashColor: Colors.red.withOpacity(0.3),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllCouponsScreen(),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        width: size.width * 0.25,
                        height: size.width * 0.25,
                        padding: const EdgeInsets.all(15.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red.withOpacity(0.2),
                        ),
                        child: FaIcon(
                          FontAwesomeIcons.ticketAlt,
                          color: Colors.red.shade500,
                          size: size.width * 0.1,
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Text(
                        'All Coupons',
                        style: GoogleFonts.poppins(
                          color: Colors.black54,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Material(
              child: InkWell(
                splashColor: Colors.blue.withOpacity(0.3),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddCouponScreen(),
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
                            Icons.add,
                            size: 19,
                            color: Colors.black.withOpacity(0.7),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            'Add New Coupon',
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
                        child: FaIcon(
                          FontAwesomeIcons.ticketAlt,
                          color: Colors.blue.shade500,
                          size: 22.0,
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
