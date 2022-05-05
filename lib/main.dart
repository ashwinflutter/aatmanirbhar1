import 'dart:convert';
import 'package:aatmanirbhar1/models/companymodel.dart';
import 'package:aatmanirbhar1/models/product_model.dart';
import 'package:aatmanirbhar1/viewpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum data { product, company }


Future<CompanyModel> comdata() async {
  final response = await http
      .get(Uri.parse('https://bbe.ezl.mybluehost.me/anb/companySearch.php'));

  if (response.statusCode == 200) {
    return CompanyModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}

Future<ProductModel> prodata() async {
  final response = await http
      .get(Uri.parse('https://bbe.ezl.mybluehost.me/anb/productSearch.php'));

  if (response.statusCode == 200) {
    return ProductModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}



void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: firstpage(),
  ));
}

class firstpage extends StatefulWidget {
  const firstpage({Key? key}) : super(key: key);

  @override
  State<firstpage> createState() => _firstpageState();
}

class _firstpageState extends State<firstpage> {

  TextEditingController tname = TextEditingController();
  int _selectedIndex = 0;
  data _vall = data.company;
  bool status = false;
  List<CompanyData> searchResult  = [];
  List<CompanyData> userDetails   = [];
  List<ProductData> searchResult1 = [];
  List<ProductData> userDetails1  = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    comdata().then((value) {
      print("##${value.data}");

      setState(() {
        userDetails = value.data!;
      });
      print("##${userDetails.length}");
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.green.shade300,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.add_to_photos_outlined),
            label: 'SORT',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.filter_list_alt),
            label: 'FILTER',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        selectedFontSize: 17,
        onTap: _onItemTapped,
      ),
      // backgroundColor: Colors.lime.shade100,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("image/greeee.jpg"), fit: BoxFit.fill)),
        child: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            Container(
                width: 320,
                child: TextFormField(
                  controller: tname,
                  onChanged: (value) {
                    onSearchTextChanged(value);
                    onSearchTextChanged1(value);
                  },
                  decoration: InputDecoration(
                    prefixIcon: IconButton(
                        onPressed: () {
                          tname.clear();
                          onSearchTextChanged('');
                        },
                        icon: Icon(
                          Icons.search,
                          size: 35,
                        )),
                    labelText: "Search",
                    fillColor: Colors.green,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.green, width: 2.0),
                      borderRadius: BorderRadius.circular(17.0),
                    ),
                  ),
                )
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.green.shade400,
                      ),
                      alignment: Alignment.center,
                      height: 55,
                      width: 100,
                      child: Text(
                        "Search By:",
                        style: TextStyle(fontSize: 21, color: Colors.black),
                      ),
                    ),
                  ],
                ),
                Radio<data>(
                  value: data.product,
                  groupValue: _vall,
                  onChanged: (data? value) {
                    setState(() {
                      _vall = value!;
                      prodata().then((value) {
                        print("##${value.data}");

                        setState(() {
                          userDetails1 = value.data!;
                          // searchResult1.addAll(value.data!);
                        });
                        print("##${userDetails1.length}");
                      });
                    });
                  },
                ),
                Text(
                  'product',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
                Radio<data>(
                  value: data.company,
                  groupValue: _vall,
                  onChanged: (data? value) {
                    setState(() {
                      _vall = value!;
                      comdata().then((value) {
                        print("##${value.data}");
                        userDetails = value.data!;
                        // searchResult=value.data!;
                        // setState(() {
                        //
                        // });
                        print("##${userDetails.length}");
                      });
                    });
                  },
                ),
                Text(
                  'company',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ],
            ),
            SizedBox(
              height: 9,
            ),
            _vall == data.product ?
            userDetails1.isNotEmpty ?
            Expanded(
                        child:
                            searchResult1.length != 0 || tname.text.isNotEmpty
                                ? ListView.builder(
                                    padding: const EdgeInsets.all(6),
                                    shrinkWrap: true,
                                    itemCount: searchResult1.length,
                                    itemBuilder: (context, i) {
                                      return Card(
                                        color: Colors.green.shade200,
                                        child: Text(
                                          searchResult1[i].productName ?? "",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      );
                                    },
                                  )
                                : ListView.builder(
                                    padding: const EdgeInsets.all(6),
                                    shrinkWrap: true,
                                    itemCount: userDetails1.length,
                                    itemBuilder: (context, index) {
                                      return Card(
                                        color: Colors.green.shade200,
                                        child: Text(
                                          userDetails1[index].productName ?? "",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      );
                                    },
                                  ))
                    : Center(child: Text("Data not Found"))
                : userDetails.isNotEmpty
                    ? Expanded(
                        child: searchResult.length != 0 || tname.text.isNotEmpty
                            ? ListView.builder(
                                padding: const EdgeInsets.all(6),
                                shrinkWrap: true,
                                itemCount: searchResult.length,
                                itemBuilder: (context, i) {
                                  return Card(
                                    color: Colors.green.shade200,
                                    child: Text(
                                      searchResult[i].companyName ?? "",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  );
                                },
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.all(6),
                                shrinkWrap: true,
                                itemCount: userDetails.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    color: Colors.green.shade200,
                                    child: Text(
                                      userDetails[index].companyName ?? "",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  );
                                },
                              ))
                    : Center(child: Text("Data not Found"))
          ],
        ),
      ),
    );
  }

  onSearchTextChanged(String text) async {
    searchResult.clear();

    if (text.isEmpty) {
      setState(() {});
      return;
    }

    userDetails.forEach((userDetails) {
      if (userDetails.companyName!.toLowerCase().contains(text.toLowerCase()) ||
          userDetails.companyName!.contains(text))
        searchResult.add(userDetails);
    });

    setState(() {});
  }

  onSearchTextChanged1(String text) async {
    searchResult1.clear();

    if (text.isEmpty) {
      setState(() {});
      return;
    }

    userDetails1.forEach((userDetails1) {
      if (userDetails1.productName!
              .toLowerCase()
              .contains(text.toLowerCase()) ||
          userDetails1.productName!.contains(text))
        searchResult1.add(userDetails1);
    });

    setState(() {});
  }
}
