
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

class NotifService {
  NotifService._();
  static final NotifService instance = NotifService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const String _channelId = 'deadline_channel';
  static const String _channelName = 'Deadline Reminder';

  static const int _reminderHour = 15;
  static const int _reminderMinute = 59;

  Future<void> init() async {
    tzdata.initializeTimeZones();

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);

    await _plugin.initialize(initSettings);

    const channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: 'Notifikasi pengingat deadline note',
      importance: Importance.high,
    );

    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidPlugin?.createNotificationChannel(channel);

    await androidPlugin?.requestNotificationsPermission();

    await androidPlugin?.requestExactAlarmsPermission();
  }

  Future<void> scheduleForNote({
    required String noteId,
    required String title,
    required DateTime? deadlineDateOnly,
  }) async {
    await cancelForNote(noteId);
    if (deadlineDateOnly == null) return;

    final dl = DateTime(
      deadlineDateOnly.year,
      deadlineDateOnly.month,
      deadlineDateOnly.day,
    );

    final hMinus1 = dl.subtract(const Duration(days: 1));

    final tHMinus1Raw = DateTime(
      hMinus1.year,
      hMinus1.month,
      hMinus1.day,
      _reminderHour,
      _reminderMinute,
    );

    final tHRaw = DateTime(
      dl.year,
      dl.month,
      dl.day,
      _reminderHour,
      _reminderMinute,
    );

    final tHMinus1 = _nextValidTime(tHMinus1Raw);
    final tH = _nextValidTime(tHRaw);

    await _scheduleAt(
      id: _notifId(noteId, 1),
      when: tHMinus1,
      title: 'Deadline mendekat',
      body: '$title (H-1)',
    );

    await _scheduleAt(
      id: _notifId(noteId, 2),
      when: tH,
      title: 'Deadline hari ini',
      body: title,
    );
  }

  Future<void> cancelForNote(String noteId) async {
    await _plugin.cancel(_notifId(noteId, 1));
    await _plugin.cancel(_notifId(noteId, 2));
  }

  Future<void> showNow({required String title, required String body}) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: 'Notifikasi pengingat deadline note',
        importance: Importance.high,
        priority: Priority.high,
      ),
    );

    await _plugin.show(9999, title, body, details);
  }

  // ====== PRIVATE ======

  int _notifId(String noteId, int variant) =>
      noteId.hashCode ^ (variant * 1000003);

  DateTime _nextValidTime(DateTime target) {
    final now = DateTime.now();
    if (target.isAfter(now)) return target;
    return now.add(const Duration(minutes: 1));
  }

  Future<void> _scheduleAt({
    required int id,
    required DateTime when,
    required String title,
    required String body,
  }) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: 'Notifikasi pengingat deadline note',
        importance: Importance.high,
        priority: Priority.high,
      ),
    );

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(when, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: null,
    );
  }
}