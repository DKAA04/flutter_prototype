# WeekPlanner Pro

**WeekPlanner Pro** is a professional productivity app built with Flutter, Hive, and Riverpod.  
It offers a clean, expandable weekly planner interface inspired by physical task planners and is optimized for mobile workflow.

---

## Features

- Expandable Weekly Planner View  
  Tap a weekday to expand and view associated tasks within the same screen.

- Task Management  
  Add, edit, and delete tasks for any day of the week. Toggle task completion with checkboxes.

- Persistent Storage  
  All data is stored locally using Hive for offline support.

- Riverpod State Management  
  Efficient state handling using Riverpod for reactive UI updates.

- Day Detail Pages  
  Navigate to a dedicated page to manage tasks for a specific day.

- Modular Clean Architecture  
  Features and business logic are organized by domain, application, and presentation layers.

---

## Known Issues & Troubleshooting

This project is currently under active development. The following issues are known and are being addressed:

### Notes System
- Editing notes may not persist changes consistently.
- Note state management and UI update flow are under review.

### Weekday Expansion Bug
- Expanding a weekday card to view its tasks does not always behave as expected.
- This is likely related to widget state updates or layout behavior inside the `GridView`.

As a temporary solution, ensure the `PlannerPage` is rendered directly from `main.dart` to isolate and test the layout.

---

## Installation

1. Clone the repository:

```bash
git clone https://github.com/YOUR_USERNAME/weekplanner_pro.git
cd weekplanner_pro
