import 'package:flutter/material.dart';
import 'projects_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({super.key});

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {

  final TextEditingController projectNameController =
      TextEditingController();

  final TextEditingController wardController =
      TextEditingController();

  final TextEditingController contractorController =
      TextEditingController();

  final TextEditingController budgetController =
      TextEditingController();

  final TextEditingController descriptionController =
      TextEditingController();

  final TextEditingController startDateController =
      TextEditingController();

  final TextEditingController endDateController =
      TextEditingController();

  String? selectedDepartment;
  String? selectedCategory;

  @override
  void dispose() {
    projectNameController.dispose();
    wardController.dispose();
    contractorController.dispose();
    budgetController.dispose();
    descriptionController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      controller.text =
          "${picked.day}/${picked.month}/${picked.year}";
    }
  }

  final List<String> departments = [
    "PWD",
    "KWA",
    "LSGD",
  ];

  final List<String> categories = [
    "Roads",
    "Water Supply",
    "Drainage",
    "Buildings",
    "Street Lighting",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: const Color(0xffF4F7FB),

      appBar: AppBar(
        title: const Text(
          "Create Project",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xff0F7C73),
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            //----------------------------------------------------
            // BASIC INFORMATION
            //----------------------------------------------------

            Card(
              elevation: 2,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),

              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    Row(
                      children: [

                        Container(
                          padding: const EdgeInsets.all(8),

                          decoration: BoxDecoration(
                            color: Colors.teal.withOpacity(.1),
                            borderRadius:
                                BorderRadius.circular(10),
                          ),

                          child: const Icon(
                            Icons.info_outline,
                            color: Color(0xff0F7C73),
                          ),
                        ),

                        const SizedBox(width: 12),

                        const Text(
                          "Basic Information",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    //------------------------------------------------
                    // Project Name
                    //------------------------------------------------

                    const Text(
                      "Project Name",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      controller: projectNameController,

                      decoration: InputDecoration(
                        hintText:
                            "Enter formal project title",

                        filled: true,

                        fillColor:
                            const Color(0xffF7F8FC),

                        contentPadding:
                            const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 18,
                        ),

                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(18),

                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                        ),

                        enabledBorder:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(18),

                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    //------------------------------------------------
                    // Department
                    //------------------------------------------------

                    const Text(
                      "Department",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 10),

                    DropdownButtonFormField<String>(
                      value: selectedDepartment,

                      decoration: InputDecoration(
                        filled: true,

                        fillColor:
                            const Color(0xffF7F8FC),

                        contentPadding:
                            const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 18,
                        ),

                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(18),

                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                        ),

                        enabledBorder:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(18),

                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                        ),
                      ),

                      hint:
                          const Text("Select Department"),

                      items: departments.map((e) {
                        return DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        );
                      }).toList(),

                      onChanged: (value) {
                        setState(() {
                          selectedDepartment = value;
                        });
                      },
                    ),

                    const SizedBox(height: 22),

                    //------------------------------------------------
                    // Category
                    //------------------------------------------------

                    const Text(
                      "Category",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 10),

                    DropdownButtonFormField<String>(
                      value: selectedCategory,

                      decoration: InputDecoration(
                        filled: true,

                        fillColor:
                            const Color(0xffF7F8FC),

                        contentPadding:
                            const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 18,
                        ),

                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(18),

                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                        ),

                        enabledBorder:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(18),

                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                        ),
                      ),

                      hint:
                          const Text("Select Category"),

                      items: categories.map((e) {
                        return DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        );
                      }).toList(),

                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value;
                        });
                      },
                    ),

                    const SizedBox(height: 22),

                    //------------------------------------------------
                    // Ward Number
                    //------------------------------------------------

                    const Text(
                      "Ward Number",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      controller: wardController,
                      keyboardType: TextInputType.number,

                      decoration: InputDecoration(
                        hintText: "e.g. 12",

                        filled: true,

                        fillColor:
                            const Color(0xffF7F8FC),

                        contentPadding:
                            const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 18,
                        ),

                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(18),

                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                        ),

                        enabledBorder:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(18),

                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    //------------------------------------------------
                    // Contractor
                    //------------------------------------------------

                    const Text(
                      "Contractor Name",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      controller: contractorController,

                      decoration: InputDecoration(
                        hintText:
                            "Assigned contractor firm",

                        filled: true,

                        fillColor:
                            const Color(0xffF7F8FC),

                        contentPadding:
                            const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 18,
                        ),

                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(18),

                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                        ),

                        enabledBorder:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(18),

                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            //----------------------------------------------------
            // LOCATION & DETAILS
            //----------------------------------------------------

            Card(
              elevation: 2,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),

              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Row(
                      children: [

                        Container(
                          padding: const EdgeInsets.all(8),

                          decoration: BoxDecoration(
                            color: Colors.teal.withOpacity(.1),
                            borderRadius:
                                BorderRadius.circular(10),
                          ),

                          child: const Icon(
                            Icons.location_on_outlined,
                            color: Color(0xff0F7C73),
                          ),
                        ),

                        const SizedBox(width: 12),

                        const Text(
                          "Location & Details",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    //------------------------------------------------
                    // Map
                    //------------------------------------------------

                    Container(
                      height: 220,
                      width: double.infinity,

                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(20),

                        color: Colors.grey.shade300,

                        image: const DecorationImage(
                          image: NetworkImage(
                            "https://maps.gstatic.com/tactile/basepage/pegman_sherlock.png",
                          ),

                          fit: BoxFit.cover,
                          opacity: .25,
                        ),
                      ),

                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(20),

                          color:
                              Colors.black.withOpacity(.18),
                        ),

                        child: const Center(
                          child: Column(
                            mainAxisSize:
                                MainAxisSize.min,

                            children: [

                              CircleAvatar(
                                radius: 28,

                                backgroundColor:
                                    Colors.white,

                                child: Icon(
                                  Icons.location_on,
                                  color:
                                      Color(0xff0F7C73),
                                  size: 34,
                                ),
                              ),

                              SizedBox(height: 15),

                              Text(
                                "Select Location on Map",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    //------------------------------------------------
                    // Project Description
                    //------------------------------------------------

                    const Text(
                      "Project Description",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      controller:
                          descriptionController,

                      maxLines: 5,

                      decoration: InputDecoration(
                        hintText:
                            "Briefly describe project scope,\ngoals, and target outcomes...",

                        filled: true,

                        fillColor:
                            const Color(0xffF7F8FC),

                        contentPadding:
                            const EdgeInsets.all(18),

                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(18),

                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                        ),

                        enabledBorder:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(18),

                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            //----------------------------------------------------
            // TIMELINE & BUDGET
            //----------------------------------------------------

            Card(
              elevation: 2,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),

              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Row(
                      children: [

                        Container(
                          padding: const EdgeInsets.all(8),

                          decoration: BoxDecoration(
                            color: Colors.teal.withOpacity(.1),
                            borderRadius:
                                BorderRadius.circular(10),
                          ),

                          child: const Icon(
                            Icons.account_balance_wallet_outlined,
                            color: Color(0xff0F7C73),
                          ),
                        ),

                        const SizedBox(width: 12),

                        const Text(
                          "Timeline & Budget",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    //------------------------------------------------
                    // Budget
                    //------------------------------------------------

                    const Text(
                      "Total Budget (₹)",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      controller: budgetController,
                      keyboardType:
                          TextInputType.number,

                      decoration: InputDecoration(
                        prefixIcon:
                            const Icon(
                                Icons.currency_rupee),

                        hintText: "0.00",

                        filled: true,

                        fillColor:
                            const Color(0xffF7F8FC),

                        contentPadding:
                            const EdgeInsets.symmetric(
                          vertical: 18,
                        ),

                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(18),

                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                        ),

                        enabledBorder:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(18),

                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    //------------------------------------------------
                    // Start Date & End Date
                    //------------------------------------------------

                    Row(
                      children: [

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,

                            children: [

                              const Text(
                                "Start Date",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                      FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 10),

                              TextField(
                                controller:
                                    startDateController,

                                readOnly: true,

                                onTap: () =>
                                    _selectDate(
                                        startDateController),

                                decoration:
                                    InputDecoration(

                                  hintText:
                                      "mm/dd/yyyy",

                                  suffixIcon:
                                      const Icon(
                                          Icons.calendar_today),

                                  filled: true,

                                  fillColor:
                                      const Color(
                                          0xffF7F8FC),

                                  border:
                                      OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius
                                            .circular(18),
                                  ),

                                  enabledBorder:
                                      OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius
                                            .circular(18),

                                    borderSide:
                                        BorderSide(
                                      color: Colors
                                          .grey.shade300,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 16),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,

                            children: [

                              const Text(
                                "End Date",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                      FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 10),

                              TextField(
                                controller:
                                    endDateController,

                                readOnly: true,

                                onTap: () =>
                                    _selectDate(
                                        endDateController),

                                decoration:
                                    InputDecoration(

                                  hintText:
                                      "mm/dd/yyyy",

                                  suffixIcon:
                                      const Icon(
                                          Icons.calendar_today),

                                  filled: true,

                                  fillColor:
                                      const Color(
                                          0xffF7F8FC),

                                  border:
                                      OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius
                                            .circular(18),
                                  ),

                                  enabledBorder:
                                      OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius
                                            .circular(18),

                                    borderSide:
                                        BorderSide(
                                      color: Colors
                                          .grey.shade300,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            //----------------------------------------------------
            // CREATE PROJECT BUTTON
            //----------------------------------------------------

            SizedBox(
              width: double.infinity,
              height: 58,

              child: ElevatedButton.icon(

                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xff0F7C73),

                  foregroundColor:
                      Colors.white,

                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(16),
                  ),
                ),

                onPressed: () async {

                  if (projectNameController.text.isEmpty ||
                      selectedDepartment == null ||
                      selectedCategory == null ||
                      wardController.text.isEmpty ||
                      budgetController.text.isEmpty) {

                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Please fill all required fields",
                        ),
                      ),
                    );

                    return;
                  }

                  await FirebaseFirestore.instance
                      .collection("projects")
                      .add({

                    "title":
                        projectNameController.text,

                    "department":
                        selectedDepartment,

                    "category":
                        selectedCategory,

                    "status":
                        "Ongoing",

                    "budget":
                        "₹${budgetController.text}",

                    "location":
                        "Ward ${wardController.text}",

                    "startDate":
                        startDateController.text,
                  });

                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Project Created Successfully",
                      ),
                    ),
                  );

                  Navigator.pop(context);
                },

                icon: const Icon(
                  Icons.check_circle,
                ),

                label: const Text(
                  "Create Project",

                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}