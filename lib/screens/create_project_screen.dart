import 'package:flutter/material.dart';

class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({super.key});

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {

  final TextEditingController projectNameController = TextEditingController();
  final TextEditingController wardController = TextEditingController();
  final TextEditingController contractorController = TextEditingController();

  String? selectedDepartment;
  String? selectedCategory;

  final List<String> departments = [
    "PWD",
    "KWA",
    "LSGD",
  ];

  final List<String> categories = [
    "Road Work",
    "Bridge",
    "Water Supply",
    "Drainage",
    "Building",
    "Street Lighting",
    "Others"
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Row(
                      children: [

                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.teal.withOpacity(.1),
                            borderRadius: BorderRadius.circular(10),
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

                    Container(
                      height: 220,
                      width: double.infinity,

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
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
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.black.withOpacity(.18),
                        ),
                        child: const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [

                              CircleAvatar(
                                radius: 28,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.location_on,
                                  color: Color(0xff0F7C73),
                                  size: 34,
                                ),
                              ),

                              SizedBox(height: 15),

                              Text(
                                "Select Location on Map",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      "Project Description",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText:
                            "Briefly describe project scope,\ngoals, and target outcomes...",
                        filled: true,
                        fillColor: const Color(0xffF7F8FC),

                        contentPadding: const EdgeInsets.all(18),

                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(18),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                        ),

                        enabledBorder: OutlineInputBorder(
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Row(
                      children: [

                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.teal.withOpacity(.1),
                            borderRadius: BorderRadius.circular(10),
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

                    const Text(
                      "Total Budget (₹)",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      keyboardType: TextInputType.number,

                      decoration: InputDecoration(

                        prefixIcon: const Icon(Icons.currency_rupee),

                        hintText: "0.00",

                        filled: true,
                        fillColor: const Color(0xffF7F8FC),

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

                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(18),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

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
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 10),

                              TextField(
                                readOnly: true,

                                decoration: InputDecoration(

                                  hintText: "mm/dd/yyyy",

                                  suffixIcon: const Icon(
                                      Icons.calendar_today),

                                  filled: true,
                                  fillColor:
                                      const Color(0xffF7F8FC),

                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(
                                            18),
                                  ),

                                  enabledBorder:
                                      OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(
                                            18),
                                    borderSide: BorderSide(
                                      color:
                                          Colors.grey.shade300,
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
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 10),

                              TextField(
                                readOnly: true,

                                decoration: InputDecoration(

                                  hintText: "mm/dd/yyyy",

                                  suffixIcon: const Icon(
                                      Icons.calendar_today),

                                  filled: true,
                                  fillColor:
                                      const Color(0xffF7F8FC),

                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(
                                            18),
                                  ),

                                  enabledBorder:
                                      OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(
                                            18),
                                    borderSide: BorderSide(
                                      color:
                                          Colors.grey.shade300,
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
            // UPLOADS & PRIORITY
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
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.assignment_outlined,
                            color: Color(0xff0F7C73),
                          ),
                        ),

                        const SizedBox(width: 12),

                        const Text(
                          "Uploads & Priority",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    const Text(
                      "Priority Level",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 16),

                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 2.8,
                      children: [

                        OutlinedButton(
                          onPressed: () {},
                          child: const Text("Low"),
                        ),

                        OutlinedButton(
                          onPressed: () {},
                          child: const Text("Medium"),
                        ),

                        OutlinedButton(
                          onPressed: () {},
                          child: const Text("High"),
                        ),

                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                          onPressed: () {},
                          child: const Text("Critical"),
                        ),

                      ],
                    ),

                    const SizedBox(height: 28),

                    const Text(
                      "Attachments",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 15),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 18,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: Colors.grey.shade400,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: const Row(
                        children: [

                          Icon(Icons.picture_as_pdf_outlined),

                          SizedBox(width: 14),

                          Expanded(
                            child: Text(
                              "Estimate PDF",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),

                          Icon(Icons.add),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 18,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: Colors.grey.shade400,
                        ),
                      ),
                      child: const Row(
                        children: [

                          Icon(Icons.attach_file),

                          SizedBox(width: 14),

                          Expanded(
                            child: Text(
                              "Supporting Docs",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),

                          Icon(Icons.add),
                        ],
                      ),
                    ),

                    const SizedBox(height: 35),

                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff0F7C73),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  "Project Created Successfully"),
                            ),
                          );

                        },
                        icon: const Icon(Icons.check_circle),
                        label: const Text(
                          "Create Project",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

          ],
        ),
      ),
    );
  }
}