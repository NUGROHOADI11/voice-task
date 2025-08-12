import 'package:get/get.dart';
import '../../../utils/services/notification_service.dart';
import '../../note/sub_features/add_note/models/note_model.dart';
import '../../task/models/task_model.dart';
import '../../task/repositories/task_repository.dart';
import '../../note/repositories/note_repository.dart';

class DashboardController extends GetxController {
  static DashboardController get to => Get.find();

  final isSearching = false.obs;
  final searchQuery = ''.obs;

  final selectedDateIndex = RxnInt();
  final selectedDate = Rxn<DateTime>();

  final activeTasks = <Task>[].obs;
  final allNotes = <Note>[].obs;

  final isLoading = true.obs;
  final errorMessage = ''.obs;

  final TaskRepository _taskRepo = TaskRepository();
  final NoteRepository _noteRepo = NoteRepository();

  final searchFilter = 'All'.obs; // 'All', 'Tasks', or 'Notes'


  @override
  void onInit() {
    super.onInit();
    _loadTasks();
    _loadNotes();
  }

  void toggleSearch() {
    isSearching.value = !isSearching.value;
    if (!isSearching.value) {
      searchQuery.value = '';
    }
  }

  void selectDate(int index, DateTime date) {
    if (selectedDateIndex.value == index) {
      clearSelectedDate();
    } else {
      selectedDateIndex.value = index;
      selectedDate.value = date;
    }
  }

  void clearSelectedDate() {
    selectedDateIndex.value = null;
    selectedDate.value = null;
  }

  List<Task> get filteredTasks {
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) return activeTasks;
    return activeTasks.where((task) {
      final title = task.title.toLowerCase();
      final desc = task.description.toLowerCase();
      return title.contains(query) || desc.contains(query);
    }).toList();
  }

  List<Note> get filteredNotes {
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) return allNotes;
    return allNotes.where((note) {
      final title = note.title.toLowerCase();
      final content = note.content.toLowerCase();
      return title.contains(query) || content.contains(query);
    }).toList();
  }

  void _loadTasks() {
    try {
      final allTasks = _taskRepo.getAllTasks();
      activeTasks.assignAll(allTasks);
      isLoading.value = false;
      _setNotification(allTasks);
    } catch (e) {
      errorMessage.value = 'Failed to load tasks: $e';
      isLoading.value = false;
    }
  }

  void _loadNotes() {
    try {
      final allNotes = _noteRepo.getAllNotes();
      this.allNotes.assignAll(allNotes);
      isLoading.value = false;
    } catch (e) {
      errorMessage.value = 'Failed to load notes: $e';
      isLoading.value = false;
    }
  }

  void _setNotification(List<Task> allTasks) {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    final tasksForTomorrow = allTasks.where((task) {
      final start = task.startDate;
      if (start == null) return false;
      return start.year == tomorrow.year &&
          start.month == tomorrow.month &&
          start.day == tomorrow.day;
    }).toList();

    if (tasksForTomorrow.isNotEmpty) {
      NotificationService().scheduleNotification(
        id: 99,
        title: 'Upcoming Tasks Reminder'.tr,
        body:
            'You have ${tasksForTomorrow.length} task(s) scheduled for tomorrow.'
                .tr,
        scheduledTime: DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 9),
      );
    }
  }
}
