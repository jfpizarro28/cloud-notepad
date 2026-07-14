# Cloud Notepad & Tasks

Files:
- index.html: cloud-synced task application
- firestore.rules: security rules restricting each account to its own tasks

Replace the firebaseConfig placeholders in index.html with the configuration from Firebase Console.
Publish firestore.rules in Firebase Console > Firestore Database > Rules.

Firestore path: users/{USER_UID}/tasks/{TASK_ID}
