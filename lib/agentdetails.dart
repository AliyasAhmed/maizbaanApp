import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class AgentDetailsPage extends StatefulWidget {
  @override
  _AgentDetailsPageState createState() => _AgentDetailsPageState();
}

class _AgentDetailsPageState extends State<AgentDetailsPage> {
  bool showPopup = true;
  bool loading = false;
  String selectedAgency = '';
  String searchTerm = '';
  List agencies = [];
  String agentName = '';
  String agentEmail = '';
  String agentPhone = '';

  @override
  void initState() {
    super.initState();
    fetchAgencies();
  }

  Future<void> fetchAgencies() async {
    try {
      final response = await http
          .get(Uri.parse("http://127.0.0.1:8000/api/v1/users/agencies"));
      if (response.statusCode == 200) {
        setState(() {
          agencies = json.decode(response.body);
        });
      } else {
        Fluttertoast.showToast(msg: "Failed to load agencies.");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to fetch agency data!");
    }
  }

  Future<void> submitAgentDetails() async {
    setState(() {
      loading = true;
    });
    try {
      final response = await http.post(
        Uri.parse("http://127.0.0.1:8000/api/v1/users/agencies"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': agentName,
          'email': agentEmail,
          'phonenumber': agentPhone,
        }),
      );
      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: "Agent details submitted successfully!");
        // Redirect logic here
        Navigator.pushNamed(context, '/userConvo');
      } else {
        Fluttertoast.showToast(msg: "Failed to submit agent details.");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong.");
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  void handleSelectAgent() {
    if (selectedAgency.isNotEmpty) {
      // Redirect to the user conversation page
      Navigator.pushNamed(context, '/userConvo');
    } else {
      Fluttertoast.showToast(msg: "Please select an agent.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Agent Details")),
      body: showPopup
          ? Center(
              child: Container(
                color: const Color.fromARGB(255, 90, 90, 90).withOpacity(0.5),
                child: Center(
                  child: Card(
                    color: Color(0xFF06090F),
                    margin: EdgeInsets.all(20),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            "Select Your Profile",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20),
                          TextField(
                            decoration: InputDecoration(
                              hintText: "Search by agency name",
                              filled: true,
                              fillColor: Colors.grey[800],
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              setState(() {
                                searchTerm = value;
                              });
                            },
                          ),
                          SizedBox(height: 20),
                          DropdownButton<String>(
                            hint: Text("Select Your Agency"),
                            value:
                                selectedAgency.isEmpty ? null : selectedAgency,
                            items: agencies
                                .where((agency) => agency['name']
                                    .toLowerCase()
                                    .contains(searchTerm.toLowerCase()))
                                .map((agency) {
                              return DropdownMenuItem<String>(
                                value: agency['id'].toString(),
                                child: Text(agency['name']),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedAgency = value!;
                              });
                            },
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: handleSelectAgent,
                            child: Text("Continue"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                showPopup = false;
                              });
                            },
                            child: Text("Add New Agent"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                color: Color(0xFF06090F),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        "Agent Details",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            agentName = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Agent Name",
                          filled: true,
                          fillColor: Colors.grey[800],
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            agentEmail = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Agent Email",
                          filled: true,
                          fillColor: Colors.grey[800],
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            agentPhone = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Agent Phone Number",
                          filled: true,
                          fillColor: Colors.grey[800],
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: submitAgentDetails,
                        child: Text(loading ? "Submitting..." : "Submit"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
