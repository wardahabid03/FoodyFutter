import 'package:flutter/material.dart';
import 'package:foody_flutter/api_service.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RecipeRumble',
      theme: ThemeData(
        primaryColor: Colors.orange[800]!,
        hintColor: Colors.orange[600]!,
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          displayLarge: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.orange[800]!),
          bodyLarge: TextStyle(fontSize: 15.0, color: Colors.black87),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.orange[800]!),
          ),
          filled: true,
          fillColor: Colors.orange[50],
          labelStyle: TextStyle(color: Colors.orange[800]!),
        ),
      ),
      home: RecipeFinder(),
    );
  }
}

class RecipeFinder extends StatefulWidget {
  @override
  _RecipeFinderState createState() => _RecipeFinderState();
}

class _RecipeFinderState extends State<RecipeFinder> {
  final _ingredientsController = TextEditingController();
  final _apiService = ApiService();
  List<String> _recipeNames = [];
  List<String> _recipeUrls = [];
  bool _isLoading = false;

  void _fetchRecipes() async {
    FocusScope.of(context).unfocus(); // Dismiss the keyboard

    setState(() {
      _isLoading = true;
      _recipeNames = [];
      _recipeUrls = [];
    });

    try {
      final result = await _apiService.fetchRecipes(_ingredientsController.text);
      setState(() {
        _recipeNames = List<String>.from(result['recipe_name']);
        _recipeUrls = List<String>.from(result['recipe_url']);
      });
    } catch (e) {
      // Handle error appropriately in a real app
      print(e);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        print('Could not launch $url');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Could not launch $url'),
        ));
      }
    } catch (e) {
      print('Error launching URL: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error launching URL: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
  elevation: 4.0, // Adds a shadow for depth
  title: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(
        Icons.restaurant_menu,
        color: Colors.white,
      ),
      SizedBox(width: 8.0),
      Text(
        'RecipeRumble',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    ],
  ),
  centerTitle: true,
  backgroundColor: Colors.orange[800]!,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(
      bottom: Radius.circular(15),
    ),
  ),
),

      body: Padding(
        padding: EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15.0),
            TextField(
              controller: _ingredientsController,
              decoration: InputDecoration(
                labelText: 'Enter ingredients (comma separated)',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search, color: Colors.orange[800]!),
                  onPressed: _fetchRecipes,
                ),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black), // Border color when focused or hovered
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black), // Border color when enabled but not focused
                  borderRadius: BorderRadius.circular(8.0), // Optional: add border radius
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black), // Border color when focused
                  borderRadius: BorderRadius.circular(8.0), // Optional: add border radius
                ),
                filled: true,
                fillColor: Colors.white, // Keep the fill color unchanged
                labelStyle: TextStyle(color: const Color.fromARGB(255, 161, 74, 3)!), // Placeholder text color
              ),
              style: TextStyle(color: Colors.black), // Text color inside TextField
            ),
            const SizedBox(height: 20.0),
            // Center(
            //   child: ElevatedButton(
            //     onPressed: _fetchRecipes,
            //     style: ElevatedButton.styleFrom(
            //       foregroundColor: Colors.white, backgroundColor: Colors.orange[800]!,
            //       padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            //       textStyle: TextStyle(fontSize: 16),
            //     ),
            //     child: Text('Find Recipes'),
            //   ),
            // ),
            // SizedBox(height: 16.0),
            _recipeNames.isNotEmpty && !_isLoading
                ? 
               
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Recipes with your ingredients:',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[800],
                        ),
                      ),
                    )
                 
                : Container(),
            Expanded(
              child: _isLoading
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 120.0), // Adjust the padding value as needed
                        child: FractionallySizedBox(
                          widthFactor: 0.6, // Adjust the width as needed
                          child: AspectRatio(
                            aspectRatio: 1, // Adjust the aspect ratio as per your animation
                            child: Lottie.asset(
                              'assets/pot.json',
                              fit: BoxFit.cover, // Adjust the fit as per your animation
                            ),
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _recipeNames.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: Color.fromARGB(255, 248, 234, 192),
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text(
                              _recipeNames[index],
                              style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
                            ),
                            trailing: Icon(Icons.arrow_forward, color: Colors.orange[800]!),
                            onTap: () => _launchUrl(_recipeUrls[index]),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
