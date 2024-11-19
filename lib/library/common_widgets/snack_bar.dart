import 'package:flutter/material.dart';

void showCustomFailedSnackBar({
  required BuildContext context,
  required String content,
  Color backgroundColor = const Color.fromARGB(255, 255, 19, 19),
  Duration duration = const Duration(seconds: 5),
  SnackBarAction? action,
}) {
  final snackBar = SnackBar(
    content: Container(
      height: 75,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: backgroundColor,
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Oups 🥺!!!',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  //textAlign: TextAlign.center,
                ),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 11,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          )
        ],
      ),
    ),
    elevation: 0,
    action: action,
    duration: duration,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showCustomSuccessSnackBar({
  required BuildContext context,
  required String content,
  Color backgroundColor = const Color.fromARGB(255, 2, 167, 46),
  Duration duration = const Duration(seconds: 5),
  SnackBarAction? action,
}) {
  final snackBar = SnackBar(
    content: Container(
      height: 70,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: backgroundColor,
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 30,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Succès 🥳!!!',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          )
        ],
      ),
    ),
    elevation: 0,
    action: action,
    duration: duration,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
