import 'package:flutter/material.dart';

void showDateRangePickerDialog(BuildContext context) {
  DateTime? startTime;
  DateTime? endTime;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Select Date Range'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(
                      'Start Date: ${startTime != null ? startTime!.toLocal().toString().split(' ')[0] : 'Not selected'}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: startTime ?? DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          startTime = pickedDate;
                        });
                      }
                    },
                  ),
                ),
                ListTile(
                  title: Text(
                      'End Date: ${endTime != null ? endTime!.toLocal().toString().split(' ')[0] : 'Not selected'}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: endTime ?? (startTime ?? DateTime.now()),
                        firstDate: startTime ?? DateTime(1900),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          endTime = pickedDate;
                        });
                      }
                    },
                  ),
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (startTime != null && endTime != null) {
                //  Call Function
              }
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
