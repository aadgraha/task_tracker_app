# Task Tracker App

A simple Task Tracker application built with Flutter and Go.

## Running the Project

### Running the backend
Before starting the Flutter application, run the backend server:

go build backend.go
./backend

### Configure API Endpoint

Open the following file:

lib/src/app/resource/base_api.dart

Update the API host/IP address to match the machine running the backend server.

genymotion emulator use 'http://10.0.3.2:8080'

android studio emulator use 'http://10.0.2.2:8080'

physical device use machine ip (cmd : hostname -I), something like 192.168.x.x

Example:
const baseUrl = 'http://10.0.3.2:8080';

### Running the Flutter App

#### Install dependencies:

flutter pub get

#### Run the application:

flutter run

####  Features

- Create tasks
- Update task status
- View task list
- View task when offline

## Architecture Explanation

lib  
│  
├── model  
│   └── task.dart  
│  
├── repository  
│   ├── base_api.dart  
│   └── task_repository.dart  
│  
├── bloc  
│   ├── task_fetch  
│   ├── task_create  
│   └── task_status  
│  
└── view  
    ├── page  
    └── widget  

### model layer  
layer yang berfungsi untuk merepresentasikan response api, data stucture, serialisasi dan deserialisasi object.  
contoh:  
Task.fromJson(json)  

### resource layer
layer yang berfungsi untuk menyimpan konfigurasi api, network logic/ berkomunikasi dengan backend, parsing response.

### state management layer
layer yang berfungsi untuk menjembatani resource layer dan view layer, bussiness logic, handle network state (initial, loading, success, failure).  
bussiness logic front-end juga berada disini.

### view layer
sebagai presentasi ui, semua yang dilihat oleh user, listen ke state management.  
reusable komponen ada di folder view/widget

## State management explanation
State management adalah proses memanage data yang berefek ke ui. ketika state berubah ui juga berubah.  
contoh di aplikasi ada state sukses, failure, loading. ui akan berubah sesuai dengan state yang didapat.  
mengapa menggunakan Bloc? bloc kependekan dari bussiness logic komponen. idenya adalah ui menghadle presentasi dan bloc menghandle logic. jadi tidak mencampurkan logic kedalam ui/ widget.
### kelebihan Bloc
- separation  of concern. UI, Bloc, Repository masing masing hanya memiliki satu tanggung jawab  
- mudah di test menggunakan bloc test  
- scalable, daripada state manajemen yang lain bloc lebih scalable meskipun terkadang banyak boilerplate, bisa diminimalkan menggunakan freezed annotation.  
- Data flow yang mudah di prediksi. ui trigger event, bloc handle event dari ui, dan memproses statenya untuk dikembalikan ke ui.  
- Shared state. state dapat di gunakan untuk ui yang lain selagi masih dalam satu context.  

## Alasan memilih approach tertentu
Memisahkan blocs per fitur (TaskCreateBloc, TaskStatusBloc, TaskFetchBloc). daripada membuat satu bloc besar, saya memisahakan blocs sesuai use case, alasannya :  
- Single responsibility
- Lebih mudah di maintenace.
- Lebih mudah di test.
- Files lebih kecil.  

Menggunakan model layer daripada raw map/json dari response. alasanya :  
- Strong typing, meminimalisir bug dynamic.
- lebih mudah mengkonversi json, bisa dimanipulasi langsung ke enum (task status).
- data struktur yang lebih tersentral.