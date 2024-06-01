import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pakbazzar/minor_screen/product_details.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchInput = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade300,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
          color: Colors.black,
        ),
        title: CupertinoSearchTextField(
          onChanged: (value) {
            setState(() {
              searchInput = value;
            });
          },
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("products").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final result = snapshot.data!.docs
                .where((element) => element["prod_name".toLowerCase()]
                    .contains(searchInput.toLowerCase()))
                .toList();
            // return ListView(
            //   children: result.map((e) => Image.network(e["prod_name"])).toList(),
            // );

            return searchInput != ''
                ? ListView.builder(
                    itemCount: result.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => ProductDetailsScreen(
                                      products: result[index]))));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
                          child: ListTile(
                            tileColor: Colors.white,
                            leading:
                                Image.network(result[index]["prod_images"][0]),
                            title: Text(
                              result[index]["prod_name"],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              result[index]["prod_desc"],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.search),
                          Text("Search Anything"),
                        ],
                      ),
                    ),
                  );
          }),
    );
  }
}
