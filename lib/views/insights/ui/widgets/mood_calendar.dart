import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kiara_app_test/core/functions/color_extension.dart';
// Giả định AppColors được định nghĩa ở đây hoặc import từ file của bạn
// import 'package:kiara_app_test/core/theme/app_colors.dart';

class MoodCalendar extends StatefulWidget {
  final Set<DateTime> moodDates;

  const MoodCalendar({super.key, required this.moodDates});

  @override
  State<MoodCalendar> createState() => _MoodCalendarState();
}

class _MoodCalendarState extends State<MoodCalendar> {
  late DateTime _focusedMonth;

  @override
  void initState() {
    super.initState();
    _focusedMonth = DateTime.now();
  }

  // --- Logic Helpers ---
  void _updateMonth(int offset) {
    setState(() {
      _focusedMonth = DateTime(
        _focusedMonth.year,
        _focusedMonth.month + offset,
      );
    });
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // --- UI Components ---
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.textColor.withOpacity(0.1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          _buildWeekDayLabels(),
          const SizedBox(height: 12),
          _buildCalendarGrid(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          DateFormat('MMMM yyyy').format(_focusedMonth),
          style: TextStyle(
            color: AppColors.textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            _MonthNavButton(
              icon: Icons.chevron_left,
              onPressed: () => _updateMonth(-1),
            ),
            _MonthNavButton(
              icon: Icons.chevron_right,
              onPressed: () => _updateMonth(1),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeekDayLabels() {
    const weekDays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    return Row(
      children: weekDays
          .map(
            (day) => Expanded(
              child: Center(
                child: Text(
                  day,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildCalendarGrid() {
    final int daysInMonth = DateUtils.getDaysInMonth(
      _focusedMonth.year,
      _focusedMonth.month,
    );
    final int firstWeekday =
        DateTime(_focusedMonth.year, _focusedMonth.month, 1).weekday % 7;
    final DateTime today = DateTime.now();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: daysInMonth + firstWeekday,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        if (index < firstWeekday) return const SizedBox.shrink();

        final int dayNumber = index - firstWeekday + 1;
        final DateTime date = DateTime(
          _focusedMonth.year,
          _focusedMonth.month,
          dayNumber,
        );

        // Kiểm tra logic bằng Set.any để đạt hiệu năng O(n) hoặc chuyển sang dùng format string để check O(1)
        final bool hasMood = widget.moodDates.any((d) => _isSameDay(d, date));
        final bool isToday = _isSameDay(date, today);

        return _CalendarDayTile(
          day: dayNumber,
          hasMood: hasMood,
          isToday: isToday,
        );
      },
    );
  }
}

// --- Sub-widgets để code gọn hơn ---

class _MonthNavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _MonthNavButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, size: 24),
      color: Colors.white.withOpacity(0.7),
      visualDensity: VisualDensity.compact,
    );
  }
}

class _CalendarDayTile extends StatelessWidget {
  final int day;
  final bool hasMood;
  final bool isToday;

  const _CalendarDayTile({
    required this.day,
    required this.hasMood,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    final Color bgColor = hasMood
        ? AppColors.primaryGreen.withOpacity(0.2)
        : Colors.grey.withOpacity(0.3);
    final Color textColor = hasMood
        ? AppColors.primaryGreen
        : Colors.white.withOpacity(0.3);

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: isToday ? Border.all(color: Colors.green, width: 2) : null,
      ),
      child: Center(
        child: Text(
          '$day',
          style: TextStyle(
            color: textColor,
            fontSize: 12,
            fontWeight: hasMood ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
