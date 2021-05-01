import 'package:ecommerce_store_admin/models/coupon.dart';
import 'package:ecommerce_store_admin/screens/manage_coupons_screen/edit_coupon_screen.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CouponItem extends StatefulWidget {
  final Size size;
  final Coupon coupon;

  const CouponItem({
    @required this.size,
    @required this.coupon,
  });

  @override
  _CouponItemState createState() => _CouponItemState();
}

class _CouponItemState extends State<CouponItem> {
  sendToEditCoupon() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditCouponScreen(
            coupon: widget.coupon,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size.width,
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.04),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Coupon code: ${widget.coupon.couponCode}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: Colors.black.withOpacity(0.8),
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  'Coupon type: ${widget.coupon.typeDesc}',
                  style: GoogleFonts.poppins(
                    color: Colors.black.withOpacity(0.75),
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  'Discount: ${widget.coupon.discount}%',
                  style: GoogleFonts.poppins(
                    color: Colors.black.withOpacity(0.75),
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
                widget.coupon.type == 'LIMITED_TIME_COUPON'
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            'From date: ${DateFormat('dd MMM yyy').format(widget.coupon.fromDate.toDate())}',
                            style: GoogleFonts.poppins(
                              color: Colors.black.withOpacity(0.75),
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            'To date: ${DateFormat('dd MMM yyy').format(widget.coupon.toDate.toDate())}',
                            style: GoogleFonts.poppins(
                              color: Colors.black.withOpacity(0.75),
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            'No. of uses: ${widget.coupon.noOfUses}',
                            style: GoogleFonts.poppins(
                              color: Colors.black.withOpacity(0.75),
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            'Used no. of times: ${widget.coupon.usedNoOfTimes}',
                            style: GoogleFonts.poppins(
                              color: Colors.black.withOpacity(0.75),
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Row(
            children: [
              Text(
                'Status: ',
                style: GoogleFonts.poppins(
                  color: Colors.black.withOpacity(0.75),
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                ),
              ),
              Text(
                widget.coupon.active ? 'Active' : 'Inactive',
                style: GoogleFonts.poppins(
                  color: widget.coupon.active
                      ? Colors.green.shade600
                      : Colors.black.withOpacity(0.75),
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5.0,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: FlatButton(
                  onPressed: () {
                    sendToEditCoupon();
                  },
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  splashColor: Colors.white.withOpacity(0.4),
                  child: Text(
                    'Edit Coupon',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
