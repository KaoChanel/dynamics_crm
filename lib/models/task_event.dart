class TaskEvent {
  TaskEvent({
    required this.isComplete,
    required this.eventCode,
    required this.title,
    required this.message
  });

  bool isComplete;
  int eventCode;
  String title;
  String message;
}