import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: ApiProvider(
      api: Api(),
      child: const HomePage(),
    ),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ValueKey _textKey = const ValueKey<String?>(null);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final api = ApiProvider.of(context).api;
        final dateAndTime = await api.getDateAndTime();
        setState(() {
          //remove the line below app still working, i don't know why @@
          _textKey = ValueKey(dateAndTime);
        });
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(ApiProvider.of(context).api.dateAndTime ?? ''),
          centerTitle: true,
        ),
        body: DateTimeWidget(key: _textKey),
      ),
    );
  }
}

class DateTimeWidget extends StatelessWidget {
  const DateTimeWidget({required super.key});

  @override
  Widget build(BuildContext context) {
    final dateAndTime = ApiProvider.of(context).api.dateAndTime;
    return SizedBox.expand(
      child: Text(dateAndTime ?? 'Tap on screen'),
    );
  }
}

class ApiProvider extends InheritedWidget {
  final Api api;
  final String id;

  ApiProvider({
    super.key,
    required this.api,
    required super.child,
  }) : id = const Uuid().v4();

  @override
  bool updateShouldNotify(covariant ApiProvider oldWidget) {
    return id != oldWidget.id;
  }

  static ApiProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ApiProvider>()!;
  }
}

class Api {
  String? dateAndTime;
  Future<String> getDateAndTime() {
    return Future.delayed(
      const Duration(seconds: 1),
      () => DateTime.now().toIso8601String(),
    ).then((value) {
      dateAndTime = value;
      return value;
    });
  }
}
