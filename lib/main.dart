import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    Color mainCol = Colors.indigo;

    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Tutorial 2',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: mainCol),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: mainCol, brightness: Brightness.dark),
        ),
        home: const MyHomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MyAppState extends ChangeNotifier{

  List<WordPair> saved = <WordPair>[];

  List<WordPair> words = [WordPair.random()];

  int index = 0;

  void getNext(){
    if(index == words.length - 1){
      words.add(WordPair.random());
    }
    index++;
    notifyListeners();  
  }

  void goBack(){
    if(index == 0){
      return;
    }
    --index;
    notifyListeners();
  }

  void toggleFav(WordPair word){

    if(saved.contains(word)){
      saved.remove(word);
    }
    else{
      saved.add(word);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget{

  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selinx = 0;

  @override
  Widget build(BuildContext context){
    Widget page;

    switch(selinx){
      case 0:
        page = const GeneratePage();
        break;
      case 1:
        page = const FavoritesPage();
        break;
      default:
        throw UnimplementedError("no widget for $selinx"); 
    }

    return Scaffold(
      
      bottomNavigationBar: BottomNavigationBar(
        elevation: 30,

        showSelectedLabels: false,
        showUnselectedLabels: false,

        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.secondary,

        type: BottomNavigationBarType.fixed,
        
        backgroundColor: Theme.of(context).colorScheme.surface,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favorites"
          ),
        ],

        currentIndex: selinx,

        onTap: (value){
          setState(() {
            selinx = value;
          });
        },
      ),
      body: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: page,
      ),
    );
  }
}

class GeneratePage extends StatelessWidget{
  const GeneratePage({super.key});

  @override
  Widget build(BuildContext context){
    MyAppState appState = context.watch<MyAppState>();
    WordPair pair = appState.words[appState.index];
    final themeData = Theme.of(context);
    IconData ico;

    if(appState.saved.contains(pair)){
      ico = Icons.favorite;
    }
    else{
      ico = Icons.favorite_border;
    }

    final butStyle = ButtonStyle(
      backgroundColor: MaterialStateProperty.all(themeData.colorScheme.secondary),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                ),
                
              ),
              iconColor: MaterialStateProperty.all(themeData.colorScheme.surface),
    );

    final buttxt = TextStyle(
                fontSize: 20,
                color: themeData.colorScheme.surface,
              );

    return Center(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          NameCard(pair: pair),
          const SizedBox(height: 30,),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
              style: butStyle,
              onPressed: (){
                appState.goBack();
              }, 
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Text('Back',
                style: buttxt,
                ),
              ),
              ),
    
              const SizedBox(width: 10,),
    
              ElevatedButton(
                style: butStyle,
                onPressed: (){
                  appState.toggleFav(appState.words[appState.index]);
    
                  if(appState.saved.contains(pair)){
                    ico = Icons.favorite;
                  }
                  else{
                    ico = Icons.favorite_border;
                  }
                }, 
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(children: [
                    Icon(ico),
                    const SizedBox(width: 5),
                    Text('Like', style: buttxt,)
                  ]),
                ),
              ),
    
              const SizedBox(width: 10,),
    
              ElevatedButton(
              style: butStyle,
              onPressed: (){
                appState.getNext();
              }, 
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Text('Next',
                style: buttxt,
                ),
              ),
              ),
    
              ],
          ),
        ]),
        );
    
  }
}

class NameCard extends StatelessWidget {
  const NameCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.surface,
      fontSize: 40.0,
    );

    return SizedBox(
      width: 380.0,
      child: Card(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))),
        elevation: 10.0,
        color: theme.colorScheme.primary,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40, 10, 40, 30),
          child: Column(
            children: [
              Text(
                  'Generated Name',
                  style: TextStyle(
                    color: theme.colorScheme.background,
                    fontSize: 15.0,
                    ),
                ),
              
              
              const SizedBox(height: 20.0),
              Text(pair.asLowerCase, style: style,),
            ],
          ),
          
          
        ),
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget{
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context){
    final appState = context.watch<MyAppState>();

    List<WordPair> favs = appState.saved;

    WordPair emp = WordPair("no favorites ", "yet");

    if (favs.isEmpty){
      favs = [emp];
    }  

    return SafeArea(child: ListView(
        padding: const EdgeInsets.all(25),
        children: [
          Text('Favorites',
            style: TextStyle(
              fontSize: 50,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 40,),
          for(WordPair tmp in favs)
            Card(
              color: Theme.of(context).colorScheme.secondary,
              child: Row(
                children: [
                  const SizedBox(width: 10, height: 60,),
                  if(favs[0] != emp)IconButton(
                    onPressed: (){
                      appState.toggleFav(tmp);
                    }, 
                    icon: const Icon(Icons.delete_outline_outlined),
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  const SizedBox(width: 10, height: 60,),
                  Text(
                    tmp.asLowerCase,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.surface,
                      fontSize: 25,
                    ),
                  ),
                ],
            ),
            ),
        ],
      )
    );
  }
}