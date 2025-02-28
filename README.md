# Outpass Management App

## Project Overview
The **Outpass Management App** is a cross-platform mobile application built with Flutter to modernize and automate the outpass process for educational institutions. Designed with students, faculty, and administrators in mind, it replaces cumbersome paper-based systems with a digital solution that ensures efficiency, accountability, and real-time tracking. The app supports a hierarchical approval chain—Class Advisor, Head of Department (HOD), and Principal—streamlining permissions for leaving and returning to campus while maintaining security and oversight.

This app was developed to address common pain points such as delayed approvals, lost requests, and lack of transparency, offering a user-friendly interface and robust backend integration.

## Core Features
- **User Authentication**:  
   - Secure login system with email/password or institutional credentials.  
   - Role-based access control (RBAC) ensures users only see relevant features.  
   - Password recovery and session management included.

- **Role-Based Interfaces**:  
   - **Students**: Request outpasses, view status, and manage profiles.  
   - **Class Advisors**: Review and approve/reject student requests.  
   - **HODs**: Oversee departmental requests and provide secondary approval.  
   - **Principals**: Final approval authority with full visibility into all requests.

- **Outpass Request System**:  
   - Form submission with fields for reason, departure date/time, return date/time, and optional notes.  
   - Validation ensures all required fields are completed before submission.  
   - Option to attach supporting documents (e.g., medical certificates) if needed.

- **Hierarchical Approval Workflow**:  
   - Step 1: Class Advisor reviews and approves/rejects with comments.  
   - Step 2: HOD evaluates advisor-approved requests.  
   - Step 3: Principal gives final approval or denial.  
   - Each level can return requests for clarification or additional details.

- **Real-Time Status Tracking**:  
   - Students receive updates at each approval stage (Pending, Approved, Rejected).  
   - Visual indicators (e.g., progress bars or status badges) for clarity.  
   - History log of past requests accessible to all users.

- **Notification System**:  
   - Push notifications for approvals, rejections, or pending actions.  
   - Email alerts as a fallback for critical updates.  
   - Customizable notification preferences per user.

- **Profile Management**:  
   - Edit personal details like name, contact info, or profile picture.  
   - Role-specific data (e.g., department for HODs, class for students).  
   - Local caching ensures quick access to profile data.

## System Requirements
- **Development Environment**:  
   - Flutter SDK (v3.0 or higher).  
   - Dart (v2.18 or higher).  
   - Android Studio / VS Code with Flutter plugin.  
- **Target Platforms**:  
   - Android (API 21+) and iOS (12.0+).  
- **Dependencies**: Internet connection for Firebase services; local storage for offline profile access.

## Installation Guide
Follow these steps to set up and run the app locally:

1. **Clone the Repository**:  
   ```bash
   git clone https://github.com/munnashaheem96/sscet-outpass-app.git
   ```
   - Ensure Git is installed (`git --version` to check).

2. **Navigate to Project Directory**:  
   ```bash
   cd sscet-outpass-app
   ```
   - This folder contains the app’s source code and configuration files.

3. **Install Dependencies**:  
   ```bash
   flutter pub get
   ```
   - Downloads all required packages listed in `pubspec.yaml` (e.g., Firebase, Provider).  
   - Ensure Flutter is properly configured (`flutter doctor` for diagnostics).

4. **Configure Firebase**:  
   - Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com).  
   - Add Android/iOS apps in Firebase and download configuration files (`google-services.json` for Android, `GoogleService-Info.plist` for iOS).  
   - Place these files in `android/app` and `ios/Runner`, respectively.  
   - Enable Authentication (Email/Password) and Firestore Database in Firebase.

5. **Run the App**:  
   ```bash
   flutter run
   ```
   - Connect a physical device or emulator (Android/iOS simulator).  
   - Use `flutter run --release` for a production-ready build.

## Technical Architecture
- **Frontend**:  
   - **Flutter**: Cross-platform UI framework for consistent Android/iOS experiences.  
   - Widgets organized in a modular structure (e.g., `lib/screens`, `lib/widgets`).  
   - Responsive design adapts to various screen sizes.

- **Backend**:  
   - **Firebase Authentication**: Manages user sign-in and roles.  
   - **Firestore Database**: Stores outpass requests, user profiles, and approval logs.  
     - Collections: `users`, `outpass_requests`, `notifications`.  
     - Real-time listeners for live updates.

- **State Management**:  
   - **Provider**: Lightweight, scalable solution for managing app state (e.g., user data, request status).  
   - ChangeNotifier used for reactive UI updates.

- **Local Storage**:  
   - **Shared Preferences**: Stores non-sensitive data (e.g., user ID, last login) for quick access.  
   - Offline support for profile viewing when network is unavailable.

## Project Structure
```
sscet-outpass-app/
├── android/              # Android-specific files
├── ios/                  # iOS-specific files
├── lib/                  # Main Flutter code
│   ├── models/           # Data models (e.g., User, OutpassRequest)
│   ├── screens/          # UI screens (e.g., Login, Dashboard)
│   ├── services/         # Firebase and API logic
│   ├── providers/        # State management classes
│   └── widgets/          # Reusable UI components
├── pubspec.yaml          # Dependencies and metadata
└── README.md             # Project documentation
```

## Contributing Guidelines
We welcome contributions to enhance the app! Follow these steps:
1. **Fork the Repository**: Click "Fork" on GitHub to create your copy.  
2. **Create a Feature Branch**:  
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. **Commit Changes**: Use clear messages (e.g., "Add outpass rejection reason field").  
   ```bash
   git commit -m "Your message"
   ```
4. **Push to GitHub**:  
   ```bash
   git push origin feature/your-feature-name
   ```
5. **Submit a Pull Request**: Open a PR on the original repo with a description of your changes.  
   - Ensure code follows Flutter best practices (e.g., linted with `flutter analyze`).  
   - Test your feature locally before submitting.

## License
This project is proprietary software developed by Munna Shaheem. It is not open-source, and unauthorized reproduction, distribution, or modification is strictly prohibited.

## Contact Information
For support, bug reports, or feature suggestions, contact:  
- **Email**: [munnashaheemperinchikkal@gmail.com](mailto:munnashaheemperinchikkal@gmail.com)

