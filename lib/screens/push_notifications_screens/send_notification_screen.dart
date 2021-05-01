import 'dart:io';

import 'package:ecommerce_store_admin/blocs/inventory_bloc/all_categories_bloc.dart';
import 'package:ecommerce_store_admin/blocs/inventory_bloc/inventory_bloc.dart';
import 'package:ecommerce_store_admin/blocs/push_notifications_bloc/push_notifications_bloc.dart';
import 'package:ecommerce_store_admin/config/config.dart';
import 'package:ecommerce_store_admin/models/category.dart';
import 'package:ecommerce_store_admin/widgets/dialogs/processing_dialog.dart';
import 'package:ecommerce_store_admin/widgets/dialogs/product_added_dialog.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class SendNotificationScreen extends StatefulWidget {
  @override
  _SendNotificationScreenState createState() => _SendNotificationScreenState();
}

class _SendNotificationScreenState extends State<SendNotificationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<dynamic, dynamic> notificationMap = Map();
  var image;
  var selectedImage;
  PushNotificationsBloc pushNotificationsBloc;
  bool isSending;
  String selectedType, selectedTypeDesc, selectedCategory;
  AllCategoriesBloc allCategoriesBloc;
  List<Category> categories;

  @override
  void initState() {
    super.initState();

    isSending = false;
    pushNotificationsBloc = BlocProvider.of<PushNotificationsBloc>(context);
    categories = List();
    allCategoriesBloc = BlocProvider.of<AllCategoriesBloc>(context);
    allCategoriesBloc.add(GetAllCategoriesEvent());

    pushNotificationsBloc.listen((state) {
      print('ADD NEW DELIVERY BLOC :: $state');

      if (state is SendNewNotificationInProgressState) {
        //in progress
        showUpdatingDialog();
      }
      if (state is SendNewNotificationFailedState) {
        //failed
        if (isSending) {
          Navigator.pop(context);
          showSnack('Failed to send notification!', context);
          isSending = false;
        }
      }
      if (state is SendNewNotificationCompletedState) {
        //completed
        if (isSending) {
          isSending = false;
          Navigator.pop(context);
          showProductAddedDialog();
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
          message: 'Notification sent successfully!',
        );
      },
    );

    if (res == 'ADDED') {
      //added
      Navigator.pop(context, true);
    }
  }

  Future cropImage(context) async {
    image = await ImagePicker().getImage(source: ImageSource.gallery);
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: image.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.ratio16x9,
      ],
      aspectRatio: CropAspectRatio(ratioX: 16, ratioY: 9),
      cropStyle: CropStyle.rectangle,
      compressFormat: ImageCompressFormat.jpg,
      maxHeight: 300,
      maxWidth: 600,
      compressQuality: 50,
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Crop image',
        toolbarColor: Theme.of(context).primaryColor,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.square,
        showCropGrid: false,
        lockAspectRatio: true,
        statusBarColor: Theme.of(context).primaryColor,
      ),
      iosUiSettings: IOSUiSettings(
        minimumAspectRatio: 1.0,
        aspectRatioLockEnabled: true,
      ),
    );

    if (croppedFile != null) {
      print('File size: ' + croppedFile.lengthSync().toString());
      setState(() {
        selectedImage = croppedFile;
        notificationMap.update(
          'image',
          (value) => selectedImage,
          ifAbsent: () => selectedImage,
        );
      });
    } else {
      //not croppped

    }
  }

  sendNotification() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      if (selectedType == null) {
        showSnack('Please select the notification type!', context);
        return;
      }
      if (selectedType == 'CATEGORY_NOTIF' && selectedCategory == null) {
        showSnack('Please select category!', context);
        return;
      }

      pushNotificationsBloc.add(SendNewNotification(notificationMap));
      isSending = true;
    }
  }

  showUpdatingDialog() {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return ProcessingDialog(
          message: 'Sending notification..\nPlease wait!',
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
                      'Send Notification',
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
            child: BlocBuilder(
              cubit: allCategoriesBloc,
              buildWhen: (previous, current) {
                if (current is GetAllCategoriesCompletedState ||
                    current is GetAllCategoriesInProgressState ||
                    current is GetAllCategoriesFailedState) {
                  return true;
                }
                return false;
              },
              builder: (context, state) {
                if (state is GetAllCategoriesInProgressState) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is GetAllCategoriesFailedState) {
                  return Center(
                    child: Text(
                      'Failed to load!',
                      style: GoogleFonts.poppins(
                        color: Colors.black87,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }
                if (state is GetAllCategoriesCompletedState) {
                  categories = state.categories;

                  return ListView(
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
                            Center(
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    height: size.width * 0.45,
                                    width: size.width * 0.9,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          offset: Offset(0, 0.0),
                                          blurRadius: 15.0,
                                          spreadRadius: 2.0,
                                          color: Colors.black.withOpacity(0.05),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20.0),
                                      child: selectedImage == null
                                          ? Icon(
                                              Icons.image,
                                              size: 50.0,
                                            )
                                          : ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              child: Image.file(
                                                selectedImage,
                                              ),
                                            ),
                                    ),
                                  ),
                                  selectedImage != null
                                      ? Positioned(
                                          top: 10.0,
                                          right: 10.0,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            child: Material(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              child: InkWell(
                                                splashColor: Colors.white
                                                    .withOpacity(0.5),
                                                onTap: () {
                                                  cropImage(context);
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(),
                                                  width: 30.0,
                                                  height: 30.0,
                                                  child: Icon(
                                                    Icons.edit,
                                                    color: Colors.white,
                                                    size: 16.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Positioned(
                                          top: 10.0,
                                          right: 10.0,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            child: Material(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              child: InkWell(
                                                splashColor: Colors.white
                                                    .withOpacity(0.5),
                                                onTap: () {
                                                  cropImage(context);
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(),
                                                  width: 30.0,
                                                  height: 30.0,
                                                  child: Icon(
                                                    Icons.add,
                                                    color: Colors.white,
                                                    size: 16.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 25.0,
                            ),
                            TextFormField(
                              textAlignVertical: TextAlignVertical.center,
                              validator: (String val) {
                                if (val.trim().isEmpty) {
                                  return 'Title is required';
                                }
                                return null;
                              },
                              onSaved: (val) {
                                notificationMap.update(
                                  'title',
                                  (val) => val.trim(),
                                  ifAbsent: () => val.trim(),
                                );
                              },
                              enableInteractiveSelection: false,
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 14.5,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                              ),
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.sentences,
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
                                labelText: 'Title',
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
                            Padding(
                              padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(15.0),
                                  labelText: 'Select type',
                                  labelStyle: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 14.5,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                ),
                                isEmpty: selectedType == null,
                                child: DropdownButton<String>(
                                    underline: SizedBox(
                                      height: 0,
                                    ),
                                    value: selectedType,
                                    isExpanded: true,
                                    isDense: true,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14.5,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                    ),
                                    items: Config()
                                        .notificationTypes
                                        .map(
                                          (e) => DropdownMenuItem<String>(
                                            child: Text(
                                              e['name'],
                                              style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 14.5,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                            value: e['id'],
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (String type) {
                                      print(type);
                                      setState(() {
                                        selectedType = type;

                                        for (var i = 0;
                                            i <
                                                Config()
                                                    .notificationTypes
                                                    .length;
                                            i++) {
                                          if (Config().notificationTypes[i]
                                                  ['id'] ==
                                              selectedType) {
                                            selectedTypeDesc = Config()
                                                .notificationTypes[i]['desc'];
                                            break;
                                          }
                                        }

                                        notificationMap.putIfAbsent(
                                            'notificationType',
                                            () => selectedType);
                                      });
                                    }),
                              ),
                            ),
                            selectedType != null
                                ? Column(
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
                                            color:
                                                Colors.black.withOpacity(0.65),
                                            fontSize: 13.5,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : SizedBox(),
                            selectedType == 'CATEGORY_NOTIF'
                                ? Column(
                                    children: [
                                      SizedBox(
                                        height: 15.0,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 5.0, bottom: 5.0),
                                        child: InputDecorator(
                                          decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.all(15.0),
                                            labelText: 'Select a category',
                                            labelStyle: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 14.5,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                          ),
                                          isEmpty: selectedCategory == null,
                                          child: DropdownButton<String>(
                                              underline: SizedBox(
                                                height: 0,
                                              ),
                                              value: selectedCategory,
                                              isExpanded: true,
                                              isDense: true,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14.5,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w500,
                                              ),
                                              items: categories
                                                  .map((e) => DropdownMenuItem(
                                                        child: Text(
                                                            e.categoryName),
                                                        value: e.categoryName,
                                                      ))
                                                  .toList(),
                                              onChanged: (String category) {
                                                setState(() {
                                                  selectedCategory = category;

                                                  notificationMap.putIfAbsent(
                                                      'category',
                                                      () => selectedCategory);
                                                });
                                              }),
                                        ),
                                      ),
                                    ],
                                  )
                                : SizedBox(
                                    height: 0.0,
                                  ),
                            SizedBox(
                              height: 15.0,
                            ),
                            TextFormField(
                              textAlignVertical: TextAlignVertical.center,
                              validator: (String val) {
                                if (val.trim().isEmpty) {
                                  return 'Description is required';
                                }

                                return null;
                              },
                              onSaved: (val) {
                                notificationMap.update(
                                  'body',
                                  (val) => val.trim(),
                                  ifAbsent: () => val.trim(),
                                );
                              },
                              enableInteractiveSelection: false,
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 14.5,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                              ),
                              minLines: 1,
                              maxLines: 6,
                              textInputAction: TextInputAction.newline,
                              keyboardType: TextInputType.multiline,
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
                                prefixIcon: Icon(Icons.mail),
                                labelText: 'Description',
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
                              height: 25.0,
                            ),
                            Container(
                              height: 45.0,
                              width: double.infinity,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 0.0),
                              child: FlatButton(
                                onPressed: () {
                                  //add notificationMap
                                  sendNotification();
                                },
                                color: Theme.of(context).primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.send,
                                      color: Colors.white,
                                      size: 20.0,
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Text(
                                      'Send Notification',
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
                              height: 25.0,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
                return SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
