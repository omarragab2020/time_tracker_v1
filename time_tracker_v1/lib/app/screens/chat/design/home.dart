import 'style.dart';
import 'chat.dart';
import 'constant.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  Home({super.key});

  TextEditingController nameL = TextEditingController();
  List<String> name = <String>[
    'Ahmad Mahdawi',
    'Osama',
    'Mohammad',
    'Abdullah'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 23, 25, 54),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            height: 230,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const PrimaryText(
                  text: 'Chat with your friends',
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
                Container(
                  height: 50,
                  margin: const EdgeInsets.only(top: 15),
                  child: RawAutocomplete<String>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text == '') {
                        return name;
                      }
                      return name.where((String option) {
                        return option.contains(textEditingValue.text);
                      });
                    },
                    fieldViewBuilder: (BuildContext context,
                        TextEditingController textEditingController,
                        FocusNode focusNode,
                        VoidCallback onFieldSubmitted) {
                      return TextFormField(
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.right,
                        textInputAction: TextInputAction.next,
                        focusNode: focusNode,
                        onFieldSubmitted: (String value) {
                          onFieldSubmitted();
                        },
                        decoration: const InputDecoration(
                          hintText: 'ابحث هنا',
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          contentPadding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                          fillColor: Colors.white,
                          counter: Offstage(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                          ),
                          suffixIcon: Icon(Icons.search),
                        ),
                      );
                    },
                    optionsViewBuilder: (BuildContext context,
                        AutocompleteOnSelected<String> onSelected,
                        Iterable<String> options) {
                      return Align(
                        alignment: Alignment.topLeft,
                        child: Material(
                          elevation: 4.0,
                          child: SizedBox(
                            height: 250,
                            child: ListView.builder(
                              itemCount: options.length,
                              itemBuilder: (BuildContext context, int index) {
                                String option = options.elementAt(index);
                                return GestureDetector(
                                    onTap: () {
                                      onSelected(option);
                                    },
                                    child: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: ListTile(
                                        title: Text(option),
                                      ),
                                    ));
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: 55,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: avatarList.length,
                    itemBuilder: (context, index) => Avatar(
                        avatarUrl: avatarList[index]['avatar'].toString()),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
            height: MediaQuery.of(context).size.height - 190,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40))),
            child: ListView.builder(
              itemCount: userList.length,
              itemBuilder: (context, index) => chatElement(
                  userList[index]['avatar']!,
                  context,
                  userList[index]['name']!,
                  userList[index]['message']!,
                  userList[index]['time']!),
            ),
          )
        ],
      ),
    );
  }

  Widget chatElement(String avatarUrl, BuildContext context, String name,
      String message, String time) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 15),
      child: ListTile(
        onTap: () => {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ChatScreen()))
        },
        leading: Avatar(avatarUrl: avatarUrl),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PrimaryText(text: name, fontSize: 18),
            PrimaryText(text: time, color: Colors.grey, fontSize: 14),
          ],
        ),
        subtitle: PrimaryText(
            text: message,
            color: Colors.grey,
            fontSize: 14,
            overflow: TextOverflow.ellipsis),
      ),
    );
  }
}
