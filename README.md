Task Tracker App

A simple Task Tracker application built with Flutter and Go.

Prerequisites

- Flutter SDK
- Go (Golang)

Running the Backend

Before starting the Flutter application, run the backend server:

go build backend.go
./backend

Configure API Endpoint

Open the following file:

lib/src/app/resource/base_api.dart

Update the API host/IP address to match the machine running the backend server.

genymotion emulator use 'http://10.0.3.2:8080';
android studio emulator use 'http://10.0.2.2:8080';
physical device use machine ip (cmd : hostname -I), something like 192.168.x.x

Example:
const baseUrl = 'http://10.0.3.2:8080';

Running the Flutter App

Install dependencies:

flutter pub get

Run the application:

flutter run

Features

- Create tasks
- Update task status
- View task list
- View task when offline
