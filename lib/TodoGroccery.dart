import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GroceryListPage extends StatefulWidget {
  @override
  _GroceryListPageState createState() => _GroceryListPageState();
}

class _GroceryListPageState extends State<GroceryListPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<String> groceryItems = [];
  List<String> selectedItems = [];
  String newItem = '';
  bool isLoading = false;

  TextEditingController _textEditingController = TextEditingController();
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _loadGroceryList();
  }

  void _loadGroceryList() async {
    if (_auth.currentUser != null) {
      DocumentSnapshot docSnapshot = await _firestore
          .collection('grocery')
          .doc(_auth.currentUser!.uid)
          .get();

      if (docSnapshot.exists) {
        Map<String, dynamic>? data =
            docSnapshot.data() as Map<String, dynamic>?;

        if (data != null && data.containsKey('items')) {
          List<dynamic> items = data['items'];
          setState(() {
            groceryItems = List<String>.from(items.cast<String>());
          });
        }
      }
    }
  }

  void _saveToFirestore() {
    if (_auth.currentUser != null) {
      _firestore
          .collection('grocery')
          .doc(_auth.currentUser!.uid)
          .set({'items': groceryItems});
    }
  }

  void addItem() {
    setState(() {
      groceryItems.add(newItem);
      newItem = '';
      _textEditingController.clear();
      _saveToFirestore();
    });
  }

  void removeItem(int index) {
    if (index >= 0 && index < groceryItems.length) {
      setState(() {
        String item = groceryItems[index];
        groceryItems.removeAt(index);
        selectedItems.remove(item);
        _saveToFirestore();
      });
    }
  }

  void toggleItemSelection(int index) {
    setState(() {
      String item = groceryItems[index];
      if (selectedItems.contains(item)) {
        selectedItems.remove(item);
      } else {
        selectedItems.add(item);
      }
    });
  }

  void markItemAsDone(int index) {
    setState(() {
      String item = groceryItems[index];
      groceryItems.remove(item);
      _saveToFirestore();
    });
  }

  void markSelectedItemsAsDone() {
    setState(() {
      groceryItems.removeWhere((item) => selectedItems.contains(item));
      selectedItems.clear();
      _saveToFirestore();
    });
  }

  void deleteAllItems() {
    setState(() {
      groceryItems.clear();
      selectedItems.clear();
      _saveToFirestore();
    });
  }

  List<String> _getSuggestions() {
    Set<String> suggestions = {};
    groceryItems.forEach((item) {
      suggestions.add(item.toLowerCase());
    });
    return suggestions.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0), // Adjust the height of the app bar
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.green.shade700, Colors.teal.shade700],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: Offset(0.0, 4.0),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent, // Make app bar transparent
            elevation: 0, // Hide the shadow of the AppBar
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
            title: Text(
              'Grocery List',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
                color: Colors.white, // Text color
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(Icons.add, color: Colors.white,),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white,
                              blurRadius: 10.0,
                              offset: Offset(0.0, 10.0),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Add Item',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87, // Text color
                              ),
                            ),
                            SizedBox(height: 16.0),
                            TextField(
                              controller: _textEditingController,
                              focusNode: _focusNode,
                              onChanged: (value) {
                                setState(() {
                                  newItem = value;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: 'Enter item',
                                border: OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed: () {
                                    _textEditingController.clear();
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 16.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16.0),
                                ElevatedButton(
                                  onPressed: () {
                                    addItem();
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    'Add',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),



      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: groceryItems.length,
                itemBuilder: (context, index) {
                  String item = groceryItems[index];
                  bool isSelected = selectedItems.contains(item);
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.grey[200] : Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: Icon(
                        isSelected ? Icons.done : Icons.radio_button_unchecked,
                        color: isSelected ? Colors.green : Colors.grey,
                      ),
                      title: Text(
                        item,
                        style: TextStyle(
                          color: isSelected ? Colors.grey : null,
                          decoration:
                              isSelected ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.delete),
                            color: Colors.redAccent,
                            onPressed: () => removeItem(index),
                          ),
                          IconButton(
                            icon: Icon(Icons.done),
                            color: Colors.green,
                            onPressed: () {
                              if (isSelected) {
                                markItemAsDone(index);
                              } else {
                                toggleItemSelection(index);
                              }
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        toggleItemSelection(index);
                      },
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20), // Add some spacing
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () {
                  deleteAllItems();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shadowColor: Colors.red,
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Delete All',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
