import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:csv/csv.dart';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'DnD_Namer_App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme:
              ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 255, 38, 0)),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var currentHuman = 'Click Next';
  var currentDwarf = 'Click Next';
  var currentElf = 'Click Next';

  List<dynamic> humanNames = [];
  List<dynamic> humanNamesFinal = [];

  List<dynamic> dwarfNames = [];
  List<dynamic> dwarfNamesFinal = [];

  List<dynamic> elfNames = [];
  List<dynamic> elfNamesFinal = [];

  dynamic getRandomElement(List<dynamic> list) {
    final random = Random();
    final index = random.nextInt(list.length);
    return list[index];
  }

  void getNextHuman() async {
    final _rawData = await rootBundle.loadString("assets/human_names.csv");
    List<dynamic> _listData = const CsvToListConverter().convert(_rawData);

    humanNames = _listData;
    var humanNamesFinal = [for (var list in humanNames) ...list];

    currentHuman = getRandomElement(humanNamesFinal);
    notifyListeners();
  }

  void getNextDwarf() async {
    final _rawData = await rootBundle.loadString("assets/dwarf_names.csv");
    List<dynamic> _listData = const CsvToListConverter().convert(_rawData);

    dwarfNames = _listData;
    var dwarfNamesFinal = [for (var list in dwarfNames) ...list];

    currentDwarf = getRandomElement(dwarfNamesFinal);
    notifyListeners();
  }

  void getNextElf() async {
    final _rawData = await rootBundle.loadString("assets/elf_names.csv");
    List<dynamic> _listData = const CsvToListConverter().convert(_rawData);

    elfNames = _listData;
    var elfNamesFinal = [for (var list in elfNames) ...list];

    currentElf = getRandomElement(elfNamesFinal);
    notifyListeners();
  }

  var favorites = [];

  void toggleFavoriteHuman() {
    if (favorites.contains(currentHuman)) {
      favorites.remove(currentHuman);
    } else {
      favorites.add(currentHuman);
    }
    notifyListeners();
  }

  void toggleFavoriteDwarf() {
    if (favorites.contains(currentDwarf)) {
      favorites.remove(currentDwarf);
    } else {
      favorites.add(currentDwarf);
    }
    notifyListeners();
  }

  void toggleFavoriteElf() {
    if (favorites.contains(currentElf)) {
      favorites.remove(currentElf);
    } else {
      favorites.add(currentElf);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = Human();
        break;
      case 1:
        page = Achive();
        break;
      case 2:
        page = Human();
        break;
      case 3:
        page = Dwarf();
        break;
      case 4:
        page = Elf();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return Scaffold(
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              extended: false,
              destinations: [
                NavigationRailDestination(
                  icon: Image.asset('assets/dnd.png'),
                  label: Text('Logo'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.favorite),
                  label: Text('Favorites'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.face),
                  label: Text('Human'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.paid),
                  label: Text('Dwarf'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.forest),
                  label: Text('Elf'),
                ),
              ],
              selectedIndex: selectedIndex,
              onDestinationSelected: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
            ),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: page,
            ),
          ),
        ],
      ),
    );
  }
}

class Achive extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var Human = appState.currentHuman;
    var Dwarf = appState.currentDwarf;
    var Elf = appState.currentElf;

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            'You have ' '${appState.favorites.length} favorites:',
            style: TextStyle(
                color: Color.fromARGB(255, 171, 4, 4),
                fontWeight: FontWeight.bold),
          ),
        ),
        for (var Human in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(Human),
          ),
      ],
    );
  }
}

class Human extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.currentHuman;
    var theme = Theme.of(context);
    var style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(40),
            child: Text(
              'Human',
              style: TextStyle(
                  fontFamily: 'IBM Plex Sans',
                  fontSize: 70,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 107, 2, 2)),
            ),
          ),
          BigCard(
            pair: pair,
            style: style,
          ),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavoriteHuman();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNextHuman();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Dwarf extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.currentDwarf;
    var theme = Theme.of(context);
    var style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.all(40),
              child: Text(
                'Dwarf',
                style: TextStyle(
                    fontFamily: 'IBM Plex Sans',
                    fontSize: 70,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 107, 2, 2)),
              )),
          BigCard(pair: pair, style: style),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavoriteDwarf();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNextDwarf();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Elf extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.currentElf;
    var theme = Theme.of(context);
    var style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.all(40),
              child: Text(
                'Elf',
                style: TextStyle(
                    fontFamily: 'IBM Plex Sans',
                    fontSize: 70,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 107, 2, 2)),
              )),
          BigCard(
            pair: pair,
            style: style,
          ),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavoriteElf();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNextElf();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
    required this.style,
  });

  final String pair;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          pair,
          style: style,
        ),
      ),
    );
  }
}
