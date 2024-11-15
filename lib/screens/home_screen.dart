import 'package:change_color_app/screens/privacy_policy_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../utils/constants/contants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Color> _selectedColors = [];
  Color? _combinedColor;
  Color _currentColor = Colors.blue;

  void _chooseColor() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Pick a Color',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: _currentColor,
              onColorChanged: (Color color) {
                setState(() {
                  _currentColor = color;
                });
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedColors.add(_currentColor);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Add Color'),
            ),
          ],
        );
      },
    );
  }

  void _resetColors() {
    setState(() {
      _selectedColors.clear();
      _combinedColor = null;
    });
  }

  void _combineColors() {
    if (_selectedColors.length >= 2) {
      setState(() {
        _combinedColor = Color.alphaBlend(
          _selectedColors[0].withOpacity(0.5),
          _selectedColors[1].withOpacity(0.5),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white10, Colors.deepPurple.shade200],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isSmallScreen = constraints.maxWidth < 600;
            return Padding(
              padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
              child: Column(
                children: [
                  _buildColorGrid(isSmallScreen),
                  SizedBox(height: isSmallScreen ? 20 : 40),
                  _buildActionButtons(isSmallScreen),
                  if (_combinedColor != null)
                    _buildCombinedColorDisplay(isSmallScreen),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: _buildPrivacyPolicyButton(),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        '${Contants.appName}',
        style: Theme.of(context).appBarTheme.titleTextStyle,
      ),
    );
  }

  Widget _buildColorGrid(bool isSmallScreen) {
    return Expanded(
      child: _selectedColors.isNotEmpty
          ? GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isSmallScreen ? 2 : 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _selectedColors.length,
              itemBuilder: (context, index) {
                return Card(
                  color: _selectedColors[index],
                );
              },
            )
          : Center(
              child: Text(
                "No colors added yet. Press 'Choose Color' to start!",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
    );
  }

  Widget _buildActionButtons(bool isSmallScreen) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildButton(
                "Choose Color", _chooseColor, Colors.blueAccent, isSmallScreen),
            _buildButton(
                "Combine Colors", _combineColors, Colors.green, isSmallScreen),
            _buildButton("Reset", _resetColors, Colors.red, isSmallScreen),
          ],
        ),
      ],
    );
  }

  Widget _buildCombinedColorDisplay(bool isSmallScreen) {
    return Column(
      children: [
        SizedBox(height: isSmallScreen ? 20 : 40),
        Text(
          "Combined Color",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: 10),
        Container(
          height: isSmallScreen ? 100 : 150,
          width: double.infinity,
          decoration: BoxDecoration(
            color: _combinedColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButton(
      String label, VoidCallback onPressed, Color color, bool isSmallScreen) {
    return Flexible(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ),
    );
  }

  Widget _buildPrivacyPolicyButton() {
    return BottomAppBar(
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PrivacyPolicyScreen(),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Center(
            child: Text(
              "Privacy Policy",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    decoration: TextDecoration.underline,
                    color: Colors.deepPurple,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
