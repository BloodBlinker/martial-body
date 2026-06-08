import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();
    try {
      final info = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(info.toString()));
    } catch (_) {
      // Default fallback
    }

    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings();
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
    );
  }

  Future<void> requestPermissions() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static const _details = NotificationDetails(
    android: AndroidNotificationDetails(
      'workout_reminder_channel',
      'Workout Reminders',
      channelDescription: 'Reminders for your next workout',
      importance: Importance.high,
      priority: Priority.high,
    ),
  );

  /// Rotating encouragement so the reminder never feels like the same canned
  /// nag twice in a row. Index is derived from the day so it varies over time.
  static const _encouragements = [
    'Your next session is waiting. Keep the momentum going.',
    "Consistency builds the fighter. Let's get a session in.",
    'Small reps, big results. Time to train.',
    'Your future self will thank you for today. Train now.',
    'The work compounds. One more session forward.',
  ];

  /// Schedule the single re-engagement reminder (id 0), tailored to where the
  /// user is. [missCount] of 1 means this week is one missed day from resetting,
  /// so we nudge sooner and harder; otherwise a gentler 48h encouragement.
  /// [programComplete] cancels reminders entirely.
  Future<void> scheduleSmartReminder({
    required int weekNumber,
    required int missCount,
    required bool programComplete,
  }) async {
    await flutterLocalNotificationsPlugin.cancel(id: 0);
    if (programComplete) return;

    final now = tz.TZDateTime.now(tz.local);
    final String title;
    final String body;
    final tz.TZDateTime when;

    if (missCount >= 1) {
      // Streak-recovery: warn before the week resets.
      title = "Don't lose Week $weekNumber";
      body =
          "You've missed a workout this week. Train today to keep your progress — "
          'miss one more and the week resets.';
      when = now.add(const Duration(hours: 16));
    } else {
      final i = now.day % _encouragements.length;
      title = 'Ready to train?';
      body = _encouragements[i];
      when = now.add(const Duration(hours: 48));
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id: 0,
      title: title,
      body: body,
      scheduledDate: when,
      notificationDetails: _details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  /// Backwards-compatible entry point (gentle 48h reminder).
  Future<void> scheduleWorkoutReminder() => scheduleSmartReminder(
        weekNumber: 1,
        missCount: 0,
        programComplete: false,
      );

  /// Immediate celebratory notification — used for milestones the user reaches
  /// while away (or just backgrounded).
  Future<void> showCelebration(String title, String body) async {
    await flutterLocalNotificationsPlugin.show(
      id: 1,
      title: title,
      body: body,
      notificationDetails: _details,
    );
  }
}

