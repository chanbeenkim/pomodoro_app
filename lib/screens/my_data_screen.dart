import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:pomodoro_app/event.dart';

class MyDataScreen extends StatefulWidget {
  const MyDataScreen({
    super.key,
  });

  @override
  State<MyDataScreen> createState() => _MyDataScreenState();
}

class _MyDataScreenState extends State<MyDataScreen> {
  late Map<DateTime, List<Event>> selectedEvents;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  @override
  void initState() {
    selectedEvents = {};
    super.initState();
  }

  final TextEditingController _eventController = TextEditingController();

  List<Event> _getEventsForDay(DateTime day) {
    return selectedEvents[day] ?? [];
  }

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(
        backgroundColor: Colors.green[200],
        elevation: 0,
      ),
      body: Column(
        children: [
          TableCalendar(
            locale: 'ko_KR',
            focusedDay: focusedDay,
            firstDay: DateTime.utc(2023, 12, 1),
            lastDay: DateTime.utc(2023, 12, 31),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                this.selectedDay = selectedDay;
                this.focusedDay = focusedDay;
              });
            },
            selectedDayPredicate: (day) {
              return isSameDay(selectedDay, day);
            },
            calendarStyle: CalendarStyle(
              defaultTextStyle: const TextStyle(
                color: Colors.black,
              ),
              markerSize: 10,
              markerDecoration: const BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
              weekendTextStyle: TextStyle(
                color: Colors.grey.shade500,
              ),
              outsideDaysVisible: false,
              todayDecoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.green.shade600,
                  width: 3,
                ),
              ),
              todayTextStyle: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
            eventLoader: _getEventsForDay,
          ),
          ..._getEventsForDay(selectedDay).map(
            ((Event event) => ListTile(title: Text(event.title))),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton.extended(
                backgroundColor: Colors.green,
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Add Event'),
                    content: TextFormField(
                      controller: _eventController,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Cancel",
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          if (_eventController.text.isEmpty) {
                            // Navigator.pop(context);
                            // return;
                          } else {
                            if (selectedEvents[selectedDay] != null) {
                              selectedEvents[selectedDay]!.add(
                                Event(title: _eventController.text),
                              );
                            } else {
                              selectedEvents[selectedDay] = [
                                Event(title: _eventController.text)
                              ];
                            }
                            Navigator.pop(context);
                            _eventController.clear();
                            setState(() {});
                            return;
                          }
                        },
                        child: const Text(
                          "OK",
                        ),
                      ),
                    ],
                  ),
                ),
                label: const Text("Add Event"),
                icon: const Icon(Icons.add),
              )
            ],
          ),
        ],
      ),
    );
  }
}
