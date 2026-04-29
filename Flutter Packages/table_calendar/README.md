To integrate a **calendar view** displaying milk subscription orders, you can use the [`table_calendar`](https://pub.dev/packages/table_calendar) package in Flutter. This allows you to show **order dates** in a calendar format while clicking on a date reveals the corresponding subscription details.  

---

### **Steps to Implement:**  
1. **Install `table_calendar` package**  
   Run the following command in your terminal:
   ```sh
   flutter pub add table_calendar
   ```

2. **Modify `OrderScreen` to include a Calendar View**  
   - Display orders on a calendar.  
   - When a date is selected, show the corresponding orders.  

---

### **Updated `OrderScreen` with Calendar View**
```dart
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class OrderScreen extends StatefulWidget {
  final String title;

  const OrderScreen({super.key, required this.title});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final Map<DateTime, List<Map<String, String>>> _ordersByDate = {
    DateTime(2025, 3, 15): [
      {"id": "#1234", "status": "Delivered", "date": "Mar 15, 2025"},
    ],
    DateTime(2025, 3, 16): [
      {"id": "#5678", "status": "Processing", "date": "Mar 16, 2025"},
    ],
    DateTime(2025, 3, 14): [
      {"id": "#9101", "status": "Cancelled", "date": "Mar 14, 2025"},
    ],
  };

  List<Map<String, String>> _getOrdersForDay(DateTime day) {
    return _ordersByDate[DateTime(day.year, day.month, day.day)] ?? [];
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Delivered":
        return Colors.green;
      case "Processing":
        return Colors.orange;
      case "Cancelled":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TableCalendar(
              firstDay: DateTime(2025, 1, 1),
              lastDay: DateTime(2025, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              calendarFormat: CalendarFormat.month,
              headerStyle: const HeaderStyle(formatButtonVisible: false),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: _selectedDay == null
                  ? const Center(child: Text("Select a date to view orders"))
                  : ListView.builder(
                      itemCount: _getOrdersForDay(_selectedDay!).length,
                      itemBuilder: (context, index) {
                        final order = _getOrdersForDay(_selectedDay!)[index];
                        return Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12),
                            leading: Icon(Icons.shopping_bag, color: _getStatusColor(order["status"]!)),
                            title: Text(order["id"]!, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(order["date"]!),
                            trailing: Text(
                              order["status"]!,
                              style: TextStyle(color: _getStatusColor(order["status"]!), fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
```

---

### **✨ Features of this UI/UX:**
✅ **Calendar View for Subscription Orders**  
✅ **Click a Date to See Orders**  
✅ **Colored Status Indicators**  
✅ **User-Friendly UI with Minimal Design**  

Would you like to add **recurring subscriptions** or a **payment status indicator** next? 🚀


```dart
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class SchoolCalendarScreen extends StatefulWidget {
  final String title;
  const SchoolCalendarScreen({super.key, required this.title});

  @override
  State<SchoolCalendarScreen> createState() => _SchoolCalendarScreenState();
}

class _SchoolCalendarScreenState extends State<SchoolCalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  /// SCHOOL EVENTS DATA
  final Map<DateTime, List<Map<String, String>>> _schoolDataByDate = {
    DateTime(2025, 3, 14): [
      {"type": "Exam", "title": "Math Semester Test", "desc": "Class 8A - 9:00 AM"},
    ],
    DateTime(2025, 3, 15): [
      {"type": "Holiday", "title": "Public Holiday", "desc": "Festival Celebration"},
    ],
    DateTime(2025, 3, 16): [
      {"type": "Homework", "title": "Science Project", "desc": "Submit before Mar 20"},
      {"type": "Attendance", "title": "Present", "desc": "Classes attended"},
    ],
    DateTime(2025, 3, 17): [
      {"type": "Fees Due", "title": "Term Fees", "desc": "Last date Mar 25"},
    ],
    DateTime(2025, 3, 18): [
      {"type": "Event", "title": "Sports Day", "desc": "Bring sports uniform"},
    ],
  };

  /// fetch events for selected day
  List<Map<String, String>> _getDayData(DateTime day) {
    return _schoolDataByDate[DateTime(day.year, day.month, day.day)] ?? [];
  }

  /// color mapping for event type
  Color _getEventColor(String type) {
    switch (type) {
      case "Exam":
        return Colors.blue;
      case "Holiday":
        return Colors.red;
      case "Homework":
        return Colors.orange;
      case "Attendance":
        return Colors.green;
      case "Fees Due":
        return Colors.purple;
      case "Event":
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  /// event icon based on type
  IconData _getEventIcon(String type) {
    switch (type) {
      case "Exam":
        return Icons.edit_note;
      case "Holiday":
        return Icons.beach_access;
      case "Homework":
        return Icons.assignment;
      case "Attendance":
        return Icons.check_circle;
      case "Fees Due":
        return Icons.account_balance_wallet;
      case "Event":
        return Icons.emoji_events;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        children: [
          /// CALENDAR UI
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TableCalendar(
              firstDay: DateTime(2025, 1, 1),
              lastDay: DateTime(2025, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              calendarFormat: CalendarFormat.month,
              headerStyle: const HeaderStyle(formatButtonVisible: false),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
            ),
          ),

          /// SELECTED DATE DATA UI
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: _selectedDay == null
                  ? const Center(
                      child: Text("Select a date to view school activities",
                          style: TextStyle(fontSize: 16)))
                  : _getDayData(_selectedDay!).isEmpty
                      ? const Center(child: Text("No activities for this day"))
                      : ListView.builder(
                          itemCount: _getDayData(_selectedDay!).length,
                          itemBuilder: (context, index) {
                            final item = _getDayData(_selectedDay!)[index];
                            return Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(12),
                                leading: Icon(
                                  _getEventIcon(item["type"]!),
                                  color: _getEventColor(item["type"]!),
                                  size: 32,
                                ),
                                title: Text(
                                  item["title"]!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(item["desc"]!),
                                trailing: Text(
                                  item["type"]!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _getEventColor(item["type"]!),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ),
        ],
      ),
    );
  }
}
```
