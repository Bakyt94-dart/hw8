import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  final VoidCallback onToggleLanguage;

  CalendarPage({required this.onToggleLanguage});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {

  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  final Map<DateTime, List<String>> _events = {};

  List<String> _getEventsForDay(DateTime day) {
    final key = DateTime(day.year, day.month, day.day);
    return _events[key] ?? [];
  }

  
  void _addEvent() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Новое событие'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Название события',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                final key = DateTime(
                  _selectedDay.year,
                  _selectedDay.month,
                  _selectedDay.day,
                );

                setState(() {
                  _events.putIfAbsent(key, () => []);
                  _events[key]!.add(controller.text);
                });
              }
              Navigator.pop(context);
            },
            child: Text('Добавить'),
          ),
        ],
      ),
    );
  }

  
  void _deleteEvent(int index) {
    final key = DateTime(
      _selectedDay.year,
      _selectedDay.month,
      _selectedDay.day,
    );

    setState(() {
      _events[key]!.removeAt(index);
    });
  }

  
  void _editEvent(int index) {
    final controller = TextEditingController(
      text: _getEventsForDay(_selectedDay)[index],
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Редактировать'),
        content: TextField(
          controller: controller,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              final key = DateTime(
                _selectedDay.year,
                _selectedDay.month,
                _selectedDay.day,
              );

              setState(() {
                _events[key]![index] = controller.text;
              });

              Navigator.pop(context);
            },
            child: Text('Сохранить'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final events = _getEventsForDay(_selectedDay);
    final isRu = Localizations.localeOf(context).languageCode == 'ru';

    return Scaffold(
      appBar: AppBar(
        title: Text('Календарь'),
        backgroundColor: Colors.red,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.language),
            onPressed: widget.onToggleLanguage,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEvent,
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [

          
          TableCalendar(
            locale: Localizations.localeOf(context).languageCode,
            firstDay: DateTime.utc(2020),
            lastDay: DateTime.utc(2030),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              return isSameDay(day, _selectedDay);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            eventLoader: _getEventsForDay,
          ),

          SizedBox(height: 12),

          
          Text(
            isRu
                ? 'Выбрано: ${_selectedDay.day}.${_selectedDay.month}.${_selectedDay.year}'
                : 'Selected: ${_selectedDay.month}/${_selectedDay.day}/${_selectedDay.year}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 12),

          
          Expanded(
            child: events.isEmpty
                ? Center(
                    child: Text(
                      isRu ? 'Событий нет' : 'No events',
                    ),
                  ): 
                  ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (_, index) {
                      return Card(
                        child: ListTile(
                          leading: Icon(Icons.event),
                          title: Text(events[index]),

                          
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () => _editEvent(index),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => _deleteEvent(index),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}