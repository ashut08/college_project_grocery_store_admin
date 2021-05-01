import 'package:ecommerce_store_admin/blocs/manage_coupons_bloc/manage_coupons_bloc.dart';
import 'package:ecommerce_store_admin/config/config.dart';
import 'package:ecommerce_store_admin/models/coupon.dart';
import 'package:ecommerce_store_admin/widgets/dialogs/delete_confirm_dialog.dart';
import 'package:ecommerce_store_admin/widgets/dialogs/processing_dialog.dart';
import 'package:ecommerce_store_admin/widgets/dialogs/product_added_dialog.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class EditCouponScreen extends StatefulWidget {
  final Coupon coupon;

  const EditCouponScreen({Key key, @required this.coupon}) : super(key: key);
  @override
  _EditCouponScreenState createState() => _EditCouponScreenState();
}

class _EditCouponScreenState extends State<EditCouponScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, dynamic> couponMap = Map();
  String selectedType, selectedTypeDesc;
  ManageCouponsBloc manageCouponsBloc;
  bool isAdding;
  DateTime selectedFromDate, selectedToDate;
  int noOfUseTimes = 0;

  @override
  void initState() {
    super.initState();

    isAdding = false;
    manageCouponsBloc = BlocProvider.of<ManageCouponsBloc>(context);

    //getting vals
    selectedType = widget.coupon.type;

    for (var i = 0; i < Config().couponTypes.length; i++) {
      if (Config().couponTypes[i]['id'] == selectedType) {
        selectedTypeDesc = Config().couponTypes[i]['desc'];
        break;
      }
    }
    if (selectedType == 'LIMITED_TIME_COUPON') {
      selectedFromDate = widget.coupon.fromDate.toDate();
      selectedToDate = widget.coupon.toDate.toDate();
    } else {
      selectedFromDate = DateTime.now();
      selectedToDate = DateTime.now().add(Duration(days: 2));
    }

    manageCouponsBloc.listen((state) {
      print('COUPON :: $state');

      if (state is EditCouponInProgressState) {
        //in progress
        showUpdatingDialog();
      }
      if (state is EditCouponFailedState) {
        //failed
        if (isAdding) {
          Navigator.pop(context);
          showSnack('Failed to add new coupon!', context);
          isAdding = false;
        }
      }
      if (state is EditCouponCompletedState) {
        //completed
        if (isAdding) {
          isAdding = false;
          Navigator.pop(context);

          if (state.res.isEmpty) {
            manageCouponsBloc.add(GetAllCoupons());
            showProductAddedDialog();
          } else {
            showSnack(state.res, context);
          }
        }
      }
    });
  }

  showProductAddedDialog() async {
    var res = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return ProductAddedDialog(
          message: 'Coupon updated successfully!',
        );
      },
    );

    if (res == 'ADDED') {
      //added
      Navigator.pop(context, true);
    }
  }

  showDeactivateDialog() async {
    bool res = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return DeleteConfirmDialog(
          message: 'Do you want to deactivate this coupon?',
        );
      },
    );

    if (res == true) {
      //delete
      couponMap.update(
        'couponId',
        (value) => widget.coupon.couponId,
        ifAbsent: () => widget.coupon.couponId,
      );
      couponMap.update(
        'active',
        (value) => false,
        ifAbsent: () => false,
      );
      manageCouponsBloc.add(EditCoupon(couponMap));
      isAdding = true;
    }
  }

  showActivateDialog() async {
    bool res = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return DeleteConfirmDialog(
          message: 'Do you want to activate this coupon?',
        );
      },
    );

    if (res == true) {
      //delete
      couponMap.update(
        'couponId',
        (value) => widget.coupon.couponId,
        ifAbsent: () => widget.coupon.couponId,
      );
      couponMap.update(
        'active',
        (value) => true,
        ifAbsent: () => true,
      );
      manageCouponsBloc.add(EditCoupon(couponMap));
      isAdding = true;
    }
  }

  addCoupon() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      couponMap.update(
        'couponId',
        (value) => widget.coupon.couponId,
        ifAbsent: () => widget.coupon.couponId,
      );

      if (selectedType != null) {
        if (selectedType == 'LIMITED_TIME_COUPON') {
          if (selectedToDate != null && selectedFromDate != null) {
            couponMap.update(
              'toDate',
              (value) => selectedToDate,
              ifAbsent: () => selectedToDate,
            );
            couponMap.update(
              'fromDate',
              (value) => selectedFromDate,
              ifAbsent: () => selectedFromDate,
            );

            manageCouponsBloc.add(EditCoupon(couponMap));
            isAdding = true;
          } else {
            showSnack('Please select TO and FROM dates!', context);
          }
        } else {
          couponMap.update(
            'usedNoOfTimes',
            (value) => 0,
            ifAbsent: () => 0,
          );
          manageCouponsBloc.add(EditCoupon(couponMap));
          isAdding = true;
        }
      } else {
        showSnack('Please select coupon type!', context);
      }
    }
  }

  showUpdatingDialog() {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return ProcessingDialog(
          message: 'Updating coupon..\nPlease wait!',
        );
      },
    );
  }

  void showSnack(String text, BuildContext context) {
    Flushbar(
      margin: const EdgeInsets.all(8.0),
      borderRadius: 8.0,
      backgroundColor: Colors.red.shade500,
      animationDuration: Duration(milliseconds: 300),
      isDismissible: true,
      boxShadows: [
        BoxShadow(
          color: Colors.black12,
          spreadRadius: 1.0,
          blurRadius: 5.0,
          offset: Offset(0.0, 2.0),
        )
      ],
      shouldIconPulse: false,
      duration: Duration(milliseconds: 2000),
      icon: Icon(
        Icons.error,
        color: Colors.white,
      ),
      messageText: Text(
        '$text',
        style: GoogleFonts.poppins(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
          color: Colors.white,
        ),
      ),
    )..show(context);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            width: size.width,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, top: 0.0, bottom: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50.0),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          splashColor: Colors.white.withOpacity(0.5),
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                            ),
                            width: 38.0,
                            height: 35.0,
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 24.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Text(
                      'Edit Coupon',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 19.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        validator: (String val) {
                          if (val.trim().isEmpty) {
                            return 'Coupon code is required';
                          }
                          return null;
                        },
                        onSaved: (val) {
                          couponMap.update(
                            'couponCode',
                            (val) => val.trim(),
                            ifAbsent: () => val.trim(),
                          );
                        },
                        readOnly: true,
                        initialValue: widget.coupon.couponCode,
                        enableInteractiveSelection: false,
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.characters,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 15.0),
                          helperStyle: GoogleFonts.poppins(
                            color: Colors.black.withOpacity(0.65),
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                          errorStyle: GoogleFonts.poppins(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.black54,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                          prefixIcon: Icon(Icons.title),
                          labelText: 'Coupon code',
                          labelStyle: GoogleFonts.poppins(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        onSaved: (val) {
                          couponMap.update(
                            'type',
                            (value) => selectedType,
                            ifAbsent: () => selectedType,
                          );
                          couponMap.update(
                            'typeDesc',
                            (value) => selectedTypeDesc,
                            ifAbsent: () => selectedTypeDesc,
                          );
                        },
                        initialValue: widget.coupon.typeDesc,
                        enableInteractiveSelection: false,
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                        readOnly: true,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.characters,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 15.0),
                          helperStyle: GoogleFonts.poppins(
                            color: Colors.black.withOpacity(0.65),
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                          errorStyle: GoogleFonts.poppins(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.black54,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                          // prefixIcon: Icon(Icons.title),
                          labelText: 'Select type',
                          labelStyle: GoogleFonts.poppins(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                      // Padding(
                      //   padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                      //   child: InputDecorator(
                      //     decoration: InputDecoration(
                      //       contentPadding: EdgeInsets.all(15.0),
                      //       labelText: 'Select type',
                      //       labelStyle: TextStyle(
                      //         color: Colors.black87,
                      //         fontSize: 14.5,
                      //         fontFamily: 'Poppins',
                      //         fontWeight: FontWeight.w500,
                      //       ),
                      //       border: OutlineInputBorder(
                      //         borderRadius: BorderRadius.circular(15.0),
                      //       ),
                      //     ),
                      //     isEmpty: selectedType == null,
                      //     child: DropdownButton<String>(
                      //         underline: SizedBox(
                      //           height: 0,
                      //         ),
                      //         value: selectedType,
                      //         isExpanded: true,
                      //         isDense: true,
                      //         style: TextStyle(
                      //           color: Colors.black,
                      //           fontSize: 14.5,
                      //           fontFamily: 'Poppins',
                      //           fontWeight: FontWeight.w500,
                      //         ),
                      //         items: Config()
                      //             .couponTypes
                      //             .map(
                      //               (e) => DropdownMenuItem<String>(
                      //                 child: Text(
                      //                   e['name'],
                      //                   style: GoogleFonts.poppins(
                      //                     color: Colors.black,
                      //                     fontSize: 14.5,
                      //                     fontWeight: FontWeight.w500,
                      //                     letterSpacing: 0.5,
                      //                   ),
                      //                 ),
                      //                 value: e['id'],
                      //               ),
                      //             )
                      //             .toList(),
                      //         onChanged: (String type) {
                      //           print(type);
                      //           setState(() {
                      //             selectedType = type;

                      //             for (var i = 0;
                      //                 i < Config().couponTypes.length;
                      //                 i++) {
                      //               if (Config().couponTypes[i]['id'] ==
                      //                   selectedType) {
                      //                 selectedTypeDesc =
                      //                     Config().couponTypes[i]['desc'];
                      //                 break;
                      //               }
                      //             }

                      //             couponMap.update(
                      //               'type',
                      //               (value) => selectedType,
                      //               ifAbsent: () => selectedType,
                      //             );
                      //             couponMap.update(
                      //               'typeDesc',
                      //               (value) => selectedTypeDesc,
                      //               ifAbsent: () => selectedTypeDesc,
                      //             );
                      //           });
                      //         }),
                      //   ),
                      // ),
                      selectedType != null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 3.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 2),
                                  child: Text(
                                    'NOTE: $selectedTypeDesc',
                                    style: GoogleFonts.poppins(
                                      color: Colors.black.withOpacity(0.65),
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : SizedBox(),
                      selectedType != null
                          ? selectedType == 'LIMITED_TIME_COUPON'
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 15.0,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Row(
                                        children: [
                                          Text(
                                            'From date: ${DateFormat('dd MMM yyyy').format(selectedFromDate)}',
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 14.5,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Spacer(),
                                          Container(
                                            height: 30,
                                            child: FlatButton(
                                                padding:
                                                    const EdgeInsets.all(0),
                                                visualDensity:
                                                    VisualDensity.compact,
                                                onPressed: () {
                                                  DatePicker.showDatePicker(
                                                    context,
                                                    showTitleActions: true,
                                                    onChanged: (date) {
                                                      print('change $date');
                                                    },
                                                    onConfirm: (date) {
                                                      print('confirm $date');
                                                      setState(() {
                                                        selectedFromDate = date;
                                                      });
                                                    },
                                                    currentTime:
                                                        selectedFromDate,
                                                    locale: LocaleType.en,
                                                  );
                                                },
                                                child: Text(
                                                  'Change Date',
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    fontSize: 14.5,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Row(
                                        children: [
                                          Text(
                                            'To date: ${DateFormat('dd MMM yyyy').format(selectedToDate)}',
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 14.5,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Spacer(),
                                          Container(
                                            height: 30,
                                            child: FlatButton(
                                                padding:
                                                    const EdgeInsets.all(0),
                                                visualDensity:
                                                    VisualDensity.compact,
                                                onPressed: () {
                                                  DatePicker.showDatePicker(
                                                    context,
                                                    showTitleActions: true,
                                                    onChanged: (date) {
                                                      print('change $date');
                                                    },
                                                    onConfirm: (date) {
                                                      print('confirm $date');
                                                      setState(() {
                                                        selectedToDate = date;
                                                      });
                                                    },
                                                    currentTime: selectedToDate,
                                                    locale: LocaleType.en,
                                                  );
                                                },
                                                child: Text(
                                                  'Change Date',
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    fontSize: 14.5,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 15.0,
                                    ),
                                    TextFormField(
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      validator: (String val) {
                                        if (val.trim().isEmpty) {
                                          return 'Usage no. of times is required';
                                        }

                                        return null;
                                      },
                                      onSaved: (val) {
                                        couponMap.update(
                                          'noOfUses',
                                          (val) => val.trim(),
                                          ifAbsent: () => val.trim(),
                                        );
                                      },
                                      initialValue: widget.coupon.noOfUses,
                                      enableInteractiveSelection: false,
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.5,
                                      ),
                                      textInputAction: TextInputAction.done,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 15.0, vertical: 15),
                                        helperStyle: GoogleFonts.poppins(
                                          color: Colors.black.withOpacity(0.65),
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.5,
                                        ),
                                        errorStyle: GoogleFonts.poppins(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.5,
                                        ),
                                        hintStyle: GoogleFonts.poppins(
                                          color: Colors.black54,
                                          fontSize: 14.5,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.5,
                                        ),
                                        prefixIcon: Icon(
                                          Icons.timer_sharp,
                                        ),
                                        labelText: 'Usage no. of times (eg: 5)',
                                        labelStyle: GoogleFonts.poppins(
                                          fontSize: 14.5,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.5,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                          : SizedBox(),
                      SizedBox(
                        height: 15.0,
                      ),
                      TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        validator: (String val) {
                          if (val.trim().isEmpty) {
                            return 'Discount percent is required';
                          }

                          return null;
                        },
                        onSaved: (val) {
                          couponMap.update(
                            'discount',
                            (val) => val.trim(),
                            ifAbsent: () => val.trim(),
                          );
                        },
                        initialValue: widget.coupon.discount,
                        enableInteractiveSelection: false,
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 15),
                          helperStyle: GoogleFonts.poppins(
                            color: Colors.black.withOpacity(0.65),
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                          errorStyle: GoogleFonts.poppins(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.black54,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                          prefixIcon: Icon(Icons.money),
                          labelText: 'Discount percent',
                          labelStyle: GoogleFonts.poppins(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                      // SizedBox(
                      //   height: 15.0,
                      // ),
                      // TextFormField(
                      //   textAlignVertical: TextAlignVertical.center,
                      //   validator: (String val) {
                      //     if (val.trim().isEmpty) {
                      //       return 'Minimum cart amount is required';
                      //     }

                      //     return null;
                      //   },
                      //   onSaved: (val) {
                      //     couponMap.update(
                      //       'body',
                      //       (val) => val.trim(),
                      //       ifAbsent: () => val.trim(),
                      //     );
                      //   },
                      //   enableInteractiveSelection: false,
                      //   style: GoogleFonts.poppins(
                      //     color: Colors.black,
                      //     fontSize: 14.5,
                      //     fontWeight: FontWeight.w500,
                      //     letterSpacing: 0.5,
                      //   ),
                      //   textInputAction: TextInputAction.done,
                      //   keyboardType: TextInputType.number,
                      //   decoration: InputDecoration(
                      //     contentPadding: EdgeInsets.symmetric(
                      //         horizontal: 15.0, vertical: 15),
                      //     helperStyle: GoogleFonts.poppins(
                      //       color: Colors.black.withOpacity(0.65),
                      //       fontWeight: FontWeight.w500,
                      //       letterSpacing: 0.5,
                      //     ),
                      //     errorStyle: GoogleFonts.poppins(
                      //       fontSize: 13.0,
                      //       fontWeight: FontWeight.w500,
                      //       letterSpacing: 0.5,
                      //     ),
                      //     hintStyle: GoogleFonts.poppins(
                      //       color: Colors.black54,
                      //       fontSize: 14.5,
                      //       fontWeight: FontWeight.w500,
                      //       letterSpacing: 0.5,
                      //     ),
                      //     prefixIcon: Icon(Icons.shopping_cart),
                      //     labelText: 'Minimum cart amount',
                      //     labelStyle: GoogleFonts.poppins(
                      //       fontSize: 14.5,
                      //       fontWeight: FontWeight.w500,
                      //       letterSpacing: 0.5,
                      //     ),
                      //     border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(12.0),
                      //     ),
                      //   ),
                      // ),
                      SizedBox(
                        height: 25.0,
                      ),
                      Container(
                        height: 45.0,
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 0.0),
                        child: FlatButton(
                          onPressed: () {
                            //add couponMap
                            addCoupon();
                          },
                          color: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              // Icon(
                              //   Icons.add,
                              //   color: Colors.white,
                              //   size: 20.0,
                              // ),
                              // SizedBox(
                              //   width: 10.0,
                              // ),
                              Text(
                                'Update Coupon',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Container(
                        height: 40.0,
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 0.0),
                        child: FlatButton(
                          onPressed: () {
                            //add couponMap
                            if (widget.coupon.active) {
                              showDeactivateDialog();
                            } else {
                              showActivateDialog();
                            }
                          },
                          color: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              // Icon(
                              //   Icons.add,
                              //   color: Colors.white,
                              //   size: 20.0,
                              // ),
                              // SizedBox(
                              //   width: 10.0,
                              // ),
                              Text(
                                widget.coupon.active
                                    ? 'Deactivate Coupon'
                                    : 'Activate Coupon',
                                style: GoogleFonts.poppins(
                                  color: widget.coupon.active
                                      ? Colors.red
                                      : Colors.green.shade600,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
