import 'package:flutter/material.dart';
import 'package:todo/utils/custom_color.dart';



class CustomStyle {
  static String regular = "PoppinsRegular";
  static String bold = "PoppinsBold";
  static String semiBold = "PoppinsSemiBold";

  static TextStyle regularBlack(double fontSize) {
    return TextStyle(fontSize: fontSize, color: CustomColor.blackColor, fontFamily: regular);
  }

  static TextStyle regularBlueColor(double fontSize, {Color color = CustomColor.blueColor}) {
    return TextStyle(fontSize: fontSize, color: color, fontFamily: regular);
  }

  static TextStyle boldBlueColor(double fontSize, {Color color = CustomColor.blueColor}) {
    return TextStyle(fontSize: fontSize, color: color, fontFamily: bold);
  }

  static TextStyle boldBlack(double fontSize) {
    return TextStyle(fontSize: fontSize, color: CustomColor.blackColor, fontFamily: bold);
  }

  static TextStyle boldPrimary(double fontSize) {
    return TextStyle(fontSize: fontSize, color: CustomColor.primaryColor, fontFamily: bold);
  }

  static TextStyle regularPrimary(double fontSize) {
    return TextStyle(fontSize: fontSize, color: CustomColor.primaryColor, fontFamily: regular);
  }

  static TextStyle semiBoldPrimary(double fontSize) {
    return TextStyle(fontSize: fontSize, color: CustomColor.primaryColor, fontFamily: semiBold);
  }

  static TextStyle semiBoldBlack(double fontSize) {
    return TextStyle(fontSize: fontSize, color: CustomColor.blackColor, fontFamily: semiBold);
  }

  static TextStyle semiBoldWithColor(double fontSize, Color color) {
    return TextStyle(fontSize: fontSize, color: color, fontFamily: semiBold);
  }

  static TextStyle regularWhite(double fontSize) {
    return TextStyle(fontSize: fontSize, color: CustomColor.whiteColor, fontFamily: regular);
  }

  static TextStyle boldWhite(double fontSize) {
    return TextStyle(fontSize: fontSize, color: CustomColor.whiteColor, fontFamily: bold);
  }

  static TextStyle semiBoldWhite(double fontSize) {
    return TextStyle(fontSize: fontSize, color: CustomColor.whiteColor, fontFamily: semiBold);
  }

  static TextStyle regularText(double fontSize) {
    return TextStyle(fontSize: fontSize, color: CustomColor.textColor, fontFamily: regular);
  }

  static TextStyle regularTextWithSpacing(double fontSize) {
    return TextStyle(fontSize: fontSize, color: CustomColor.textColor, fontFamily: regular, letterSpacing: 1, wordSpacing: 1);
  }

  static TextStyle boldText(double fontSize) {
    return TextStyle(fontSize: fontSize, color: CustomColor.textColor, fontFamily: bold);
  }

  static TextStyle semiBoldText(double fontSize) {
    return TextStyle(fontSize: fontSize, color: CustomColor.textColor, fontFamily: semiBold);
  }

  static TextStyle semiBoldTextWithSpacing(double fontSize) {
    return TextStyle(fontSize: fontSize, color: CustomColor.textColor, fontFamily: semiBold, letterSpacing: 2);
  }

  static TextStyle regularRed(double fontSize) {
    return TextStyle(fontSize: fontSize, color: CustomColor.redColor, fontFamily: regular);
  }

  static TextStyle semiBoldRed(double fontSize) {
    return TextStyle(fontSize: fontSize, color: CustomColor.redColor, fontFamily: semiBold);
  }

  static TextStyle boldRed(double fontSize) {
    return TextStyle(fontSize: fontSize, color: CustomColor.redColor, fontFamily: bold);
  }

  static TextStyle regularGrey(double fontSize) {
    return TextStyle(fontSize: fontSize, color: CustomColor.greyColor, fontFamily: regular);
  }

  static TextStyle semiBoldDarkBlueColor(double fontSize) {
    return TextStyle(fontSize: fontSize, color: CustomColor.darkBlueColor, fontFamily: semiBold);
  }

  static TextStyle regularDarkBlueColor(double fontSize) {
    return TextStyle(fontSize: fontSize, color: CustomColor.darkBlueColor, fontFamily: regular);
  }

  static TextStyle boldDarkBlueColor(double fontSize) {
    return TextStyle(fontSize: fontSize, color: CustomColor.darkBlueColor, fontFamily: bold);
  }

  static TextStyle boldGrey(double fontSize) {
    return TextStyle(fontSize: fontSize, color: CustomColor.greyColor, fontFamily: bold);
  }

  static TextStyle regularGreen(double fontSize) {
    return TextStyle(fontSize: fontSize, color: CustomColor.greenColor, fontFamily: regular);
  }

  static TextStyle semiBoldGreen(double fontSize) {
    return TextStyle(fontSize: fontSize, color: CustomColor.greenColor, fontFamily: semiBold);
  }

  static TextStyle boldGreen(double fontSize) {
    return TextStyle(fontSize: fontSize, color: CustomColor.greenColor, fontFamily: bold);
  }

  static TextStyle boldYellow(double fontSize) {
    return TextStyle(fontSize: fontSize, color: CustomColor.yellowColor, fontFamily: bold);
  }
}
