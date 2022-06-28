import 'package:flutter/material.dart';

/* -------------- Import Imports */
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
/*---------------- Ends here */

/* -------------------- Prerequisites before continuing */

/*  
    1. Install Flutter local notification inside your pubspec.yaml file.
       
       @link: https://pub.dev/packages/flutter_local_notifications
  
    2. Make Sure you added the app icon inside your mipmap file.
       
       Path ->  \android\app\src\main\res\mipmap-hdpi\ic_launcher.png
  
   */

/* ----------------------------------------------------- */

class SendNot extends StatefulWidget {
  const SendNot({Key? key}) : super(key: key);

  @override
  State<SendNot> createState() => _SendNotState();
}

class _SendNotState extends State<SendNot> {
  /* 1.  Create a initial dateTime instance */
  DateTime dateTime = DateTime.now();

  /* 2. Create TextEditing Controller*/
  final TextEditingController _date = TextEditingController();
  final TextEditingController _time = TextEditingController();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _desc = TextEditingController();

  /* 3. Initialize FlutterLocalNotPlugin */
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();

    /* 4. Provide the AndroidInitialization setting, class consit of icon you need to display while the notification is visible */

    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("@mipmap/ic_launcher");

    /* 5. Provide the IOSInitializationSettings setting */
    const IOSInitializationSettings iosInitializationSettings =
        IOSInitializationSettings();

    /* 6. Create the Instance of InitializationSettings this class help to show notification 
          with the settings given above in different Platform  */

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
      macOS: null,
      linux: null,
    );

    /* 8. call initialize() function using the instance created in step 3 
          and pass the initialization settings. */
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (dataYouNeedToUseWhenNotificationIsClicked) {},
    );
  }

  /* 9. Create a scheduleNotification Function. */
  scheduleNotification() async {
    if (_title.text.isEmpty || _desc.text.isEmpty) {
      return;
    }
    /* 10. Provide the AndroidNotification Details. These details will appear inside 
         the app info section of the smartphone. */
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      "ScheduleNotification001",
      "Notify Me",
      importance: Importance.high,
    );

/* 11. Provide the IOS Notification details provide the details below. */
    const IOSNotificationDetails iosNotificationDetails =
        IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    /* 11.  Provide the Notification details to the plugin */
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
      macOS: null,
      linux: null,
    );

    // flutterLocalNotificationsPlugin.show(01, "This is notification",
    //     "This notification is schedueled at ", notificationDetails);

    /* 12. Initialize the time and provide the scheduled time. */
    tz.initializeTimeZones();
    final tz.TZDateTime scheduledAt = tz.TZDateTime.from(dateTime, tz.local);

    debugPrint("Scheduled At -> ${dateTime.toString()}");
    //debugPrint("In Seconds ${dateTime.}");
    debugPrint(
        "${scheduledAt.year}/${scheduledAt.month}/${scheduledAt.day} - ${scheduledAt.hour}:${scheduledAt.minute} ");

    /* 13. Then call the function to schedule time and show notification. */
    flutterLocalNotificationsPlugin.zonedSchedule(
        01, _title.text, _desc.text, scheduledAt, notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.wallClockTime,
        androidAllowWhileIdle: true);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("You will get notification at ${dateTime.toString()}"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _title,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  label: Text("Notification Title"),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _desc,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  label: Text("Notification Description"),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _date,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    suffixIcon: InkWell(
                      child: Icon(Icons.date_range),
                      onTap: () async {
                        final DateTime? newlySelectedDate =
                            await showDatePicker(
                          context: context,
                          initialDate: dateTime,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2095),
                        );

                        if (newlySelectedDate == null) {
                          return;
                        }

                        setState(() {
                          dateTime = newlySelectedDate;
                          _date.text =
                              "${dateTime.year}/${dateTime.month}/${dateTime.day}";
                        });
                      },
                    ),
                    label: Text("Date")),
              ),
              const SizedBox(
                height: 16.0,
              ),
              TextField(
                controller: _time,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    suffixIcon: InkWell(
                      child: const Icon(
                        Icons.timer_outlined,
                      ),
                      onTap: () async {
                        final TimeOfDay? slectedTime = await showTimePicker(
                            context: context, initialTime: TimeOfDay.now());

                        if (slectedTime == null) {
                          return;
                        }

                        _time.text =
                            "${slectedTime.hour}:${slectedTime.minute}:${slectedTime.period.toString()}";

                        DateTime newDT = DateTime(
                          dateTime.year,
                          dateTime.month,
                          dateTime.day,
                          slectedTime.hour,
                          slectedTime.minute,
                        );
                        setState(() {
                          dateTime = newDT;
                        });
                      },
                    ),
                    label: Text("Time")),
              ),
              const SizedBox(
                height: 24.0,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 55),
                  ),
                  onPressed: scheduleNotification,
                  child: Text("Notify me at ${dateTime.toLocal().toString()}")),
            ],
          ),
        ),
      ),
    );
  }
}
