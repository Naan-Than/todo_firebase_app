import 'dart:math';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../models/userResponse.dart';
import 'custom_color.dart';

class Utility {


  static Color primaryColor = const Color(0xFFbcdefd);
  static Color plColor = const Color(0xFF755fdd);
  // 73ceb2
  static Color greenColor = const Color(0xFF4ddcd6);
  static Color plwColor = const Color(0xFF5618EA);
  static Color blColor = const Color(0xFF9973ec);
  static String uid = "uid";
  static String email = "email";
  static String isLoggedIn = "isLoggedIn";
  static String userName = "userName";
  static String settingText = "Settings";
  static String loginText = "Login";
  static String registerText = "Register";
  static String previousText = "Previous";
  static String nextText = "Next";

  //route
  static String routeLogin = "/login";
  static String routeRegister = "/register";
  static String routeHome = "/home";


  static getHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static getWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static Widget customTextField({
    required TextEditingController controller,
    required String label,
    required IconData prefixIcon,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    required BuildContext context,
  }) {
    return Container(
      width: Utility.getWidth(context) / 1.33,
      child: TextFormField(
        controller: controller,
        validator: validator,
        obscureText: obscureText,
        keyboardType: keyboardType,
        scrollPhysics: const AlwaysScrollableScrollPhysics(),
        decoration: InputDecoration(
          prefixIcon: Icon(
            prefixIcon,
            color: Utility.primaryColor,
          ),
          suffixIcon: suffixIcon,
          hintText: label,
          hintStyle: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w500,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Utility.primaryColor),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
        ),
      ),
    );
  }
  static customButton(onPressed, color, color1, label, fontColor) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Colors.black54,
              blurRadius: 20.0,
              spreadRadius: -20.0,
              offset: Offset(0.0, 20.0),
            ),
          ],
          gradient: LinearGradient(colors: [color, color1]),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(label, style: TextStyle(fontSize: 16, color: fontColor)),
      ),
    );
  }



  static Widget customBuildViewOption({
    required int index,
    required int selectedIndex,
    required Function(int) onTap,
    required IconData icon,
    required String label,
  }) {
    final isSelected = selectedIndex == index;
    final color = isSelected ? const Color(0xFF4D79FF) : Colors.grey[400];
    final bgColor =
        isSelected
            ? const Color(0xFF4D79FF).withOpacity(0.1)
            : Colors.transparent;

    return InkWell(
      onTap: () => onTap(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 5),
            Text(label, style: TextStyle(color: color, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  static Widget customBuildTaskCard({
    required String title,
    required String description,
    required DateTime daysLeft,
    required bool isCompleted,
    required List<String> assignees,
    required Color color,
    bool isHighlighted = false,
    required onPress,
  }) {
    return InkWell(
      onTap: onPress,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: isHighlighted ? const Color(0xFFFFF8E1) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isHighlighted ? Colors.orange[300]! : Colors.grey[200]!,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: Icon(
                isCompleted ? Icons.check : Icons.more_horiz,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 65,
                        child: Text(
                          title,
                          style: const TextStyle(
                            color: Color(0xFF2B3A67),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                        decoration: BoxDecoration(
                          color: isCompleted ? Colors.green.shade50 : Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          isCompleted ? "Completed" : "Open",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isCompleted ? Colors.green.shade700 : Colors.blue.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: Colors.grey[400],
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('yyyy-MM-dd HH:mm').format(daysLeft),
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      // Description (65% width)
                      Expanded(
                        flex: 65,
                        child: Text(
                          description,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const Spacer(flex: 5),
                      // Assignees (30% width)
                      Expanded(
                        flex: 30,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: _buildAssigneeList(assignees),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static List<Widget> _buildAssigneeList(List<String> assignees) {
    List<Widget> assigneeWidgets = [];

    int displayCount = assignees.length > 3 ? 2 : assignees.length;

    for (int i = 0; i < displayCount; i++) {
      assigneeWidgets.add(_buildAssigneeCircle(assignees[i]));
    }

    if (assignees.length > 3) {
      assigneeWidgets.add(_buildMoreAssigneeCircle(assignees.length - 2));
    }

    return assigneeWidgets;
  }

  static Widget _buildAssigneeCircle(String letter) {
    Color getColor() {
      final int hash = letter.codeUnitAt(0);
      final Random random = Random(hash);
      return Color.fromARGB(
        255,
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
      );
    }

    return Container(
      margin: const EdgeInsets.only(left: 4),
      width: 22,
      height: 22,
      decoration: BoxDecoration(color: getColor(), shape: BoxShape.circle),
      child: Center(
        child: Text(
          letter,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  static Widget _buildMoreAssigneeCircle(int remainingCount) {
    return Container(
      margin: const EdgeInsets.only(left: 4),
      width: 22,
      height: 22,
      decoration: const BoxDecoration(
        color: Colors.grey,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '+$remainingCount',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  static Widget multiSelectCommonDropDown(
      {
        required BuildContext context,
        required List<UserResponse> userList,
        required List<UserResponse> selectedItems,
        required String hintText,
        required String errorText,
        required Color fillColor,
        required GlobalKey<DropdownSearchState<UserResponse>> key,
        required ValueChanged<List<UserResponse>> onChanged,
        TextStyle? style,
        bool isEnable = true,
        bool isOutline = true}) {
    return DropdownSearch<UserResponse>.multiSelection(
        key: key,
        selectedItems: selectedItems,
        enabled: isEnable,
        compareFn: (item, item1) => item.id == item1.id,
        validator: (value) {
          if (value == null || value.isEmpty && isEnable) {
            return errorText;
          } else {
            return null;
          }
        },
        popupProps: const PopupPropsMultiSelection.dialog(
          fit: FlexFit.loose,
          showSelectedItems: true,
          showSearchBox: true,
          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
              labelText: "Search",
            ),
          ),
        ),
        items: (filter, infiniteScrollProps) =>userList,
        itemAsString: (item) => item.displayName,
        decoratorProps: DropDownDecoratorProps(
          decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Utility.primaryColor)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,

            contentPadding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
            fillColor: Colors.transparent,
            enabled: isEnable,
            labelText: hintText,
          ),
        ),
        onChanged: onChanged);
  }


  static commonFloating(
    BuildContext context,
    VoidCallback function,
    IconData icon,
  ) {
    return InkWell(
      onTap: function,
      child: CircleAvatar(
        radius: 30,
        backgroundColor: CustomColor.blueColor.withOpacity(.2),
        child: CircleAvatar(
          radius: 26,
          backgroundColor: CustomColor.blueColor.withOpacity(.5),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: CustomColor.blueColor,
            child: Icon(icon, color: CustomColor.whiteColor),
          ),
        ),
      ),
    );
  }
}


