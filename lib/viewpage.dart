import 'dart:convert';

import 'package:aatmanirbhar1/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'models/companymodel.dart';
import 'models/product_model.dart';

enum data { product, company }

class viewpage extends StatefulWidget {
  const viewpage({Key? key}) : super(key: key);

  @override
  State<viewpage> createState() => _viewpageState();
}

class _viewpageState extends State<viewpage> {
  TextEditingController tname = TextEditingController();

  int _selectedIndex = 0;
  data? _vall = data.product;

  List<CompanyData> searchResult = [];
  List<CompanyData> userDetails = [];

  bool search = false;

  // viewresponce? ll;
  CompanyModel? ll;
  ProductModel? vv;
  bool status = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getdata();
  }
                                                              // adhuru work che  main page j complite che
  Future<void> getdata() async {
    var url = Uri.parse('https://bbe.ezl.mybluehost.me/anb/companySearch.php');
    var response =
        await http.post(url, body: {'searchKeyword': 'india', 'pageNo': '1'});
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    var rr = jsonDecode(response.body);
    ll = CompanyModel.fromJson(rr);

    // userDetails.addAll(ll!.data);
    setState(() {
      status = true;
      print("siiiii${userDetails.length}");
    });
  }

  Future<void> prodata() async {
    var url = Uri.parse('https://bbe.ezl.mybluehost.me/anb/productSearch.php');
    var response =
        await http.post(url, body: {'searchKeyword': 'india', 'pageNo': '1'});
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    var pp = jsonDecode(response.body);
    vv = ProductModel.fromJson(pp);

    setState(() {
      status = true;
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
        backgroundColor: Colors.black26,
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
      backgroundColor: Colors.blue.shade100,
      body: Column(
        children: [
          SizedBox(
            height: 40,
          ),
          TextField(
            // autofocus: true,
            controller: tname,
            onChanged: (value) {
              // onSearchTextChanged;
            },
            decoration: InputDecoration(
                prefixIcon: IconButton(
                    onPressed: () {
                      tname.clear();
                      // onSearchTextChanged('');
                    },
                    icon: Icon(Icons.search)),
                labelText: "Search",
                fillColor: Colors.white54,
                filled: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15))),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.brown.shade200,
                    ),
                    alignment: Alignment.center,
                    height: 55,
                    width: 100,
                    child: Text(
                      "Search By:",
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                ],
              ),
              Radio<data>(
                value: data.product,
                groupValue: _vall,
                onChanged: (data? value) {
                  setState(() {
                    _vall = value;
                    prodata();
                  });
                },
              ),
              Text(
                'product',
                style: TextStyle(fontSize: 20),
              ),
              Radio<data>(
                value: data.company,
                groupValue: _vall,
                onChanged: (data? value) {
                  setState(() {
                    _vall = value;
                    getdata();
                  });
                },
              ),
              Text(
                'company',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          ll?.data == null
              ? Center(child: Text("Data not Found"))
              : Expanded(
                  child: searchResult.length != 0 || tname.text.isNotEmpty
                      ? ListView.builder(
                          itemCount: searchResult.length,
                          itemBuilder: (context, i) {
                            return Card(
                              child: ListTile(
                                tileColor: Colors.lightGreen.shade100,
                                title: Text("",
                                  style: TextStyle(fontSize: 20),
                                ),
                                leading: Expanded(
                                  child: ClipRect(child: Text("")),
                                ),
                              ),
                            );
                          },
                        )
                      : ListView.builder(
                          itemCount: userDetails.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                tileColor: Colors.lightGreen.shade100,
                                title: Text(
                                  "${userDetails[index].companyName}",
                                  style: TextStyle(fontSize: 20),
                                ),
                                leading: Expanded(
                                  child: ClipRect(child: Text("")),
                                ),
                              ),
                            );
                          },
                        )),
        ],
      ),
    );
  }

  // onSearchTextChanged(String text) async {
  //   searchResult.clear();
  //   if (text.isEmpty) {
  //     setState(() {});
  //     return;
  //   }
  //
  //   userDetails.forEach((userDetails) {
  //     if (userDetails.contains(text) || userDetails.lastName.contains(text))
  //       searchResult.add(userDetails);
  //   });
  //
  //   setState(() {});
  // }
}
