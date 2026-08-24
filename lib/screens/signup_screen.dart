import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController =
      TextEditingController();

  final TextEditingController _emailController =
      TextEditingController();

  final TextEditingController _passwordController =
      TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;
  bool _isLoading = false;

  String? _selectedDepartment;
  String? _selectedRole;

  final List<String> _departments = [
    'Public Works Department (PWD)',
    'Kerala Water Authority (KWA)',
    'Local Self Government Department (LSGD)',
  ];

  final List<String> _roles = [
    'Department Officer',
    'District Officer',
    'Field Officer',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ============================================================
  // CREATE ACCOUNT
  // ============================================================

  Future<void> _createAccount() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please agree to the terms and conditions.',
          ),
        ),
      );
      return;
    }

setState(() {
  _isLoading = true;
});

try {

  UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: _emailController.text.trim(),
    password: _passwordController.text.trim(),
  );

  await FirebaseFirestore.instance
      .collection('users')
      .doc(userCredential.user!.uid)
      .set({
    'name': _nameController.text.trim(),
    'email': _emailController.text.trim(),
    'department': _selectedDepartment,
    'role': _selectedRole,
    'createdAt': FieldValue.serverTimestamp(),
  });

  setState(() {
    _isLoading = false;
  });

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Account Created Successfully"),
    ),
  );

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => const LoginScreen(),
    ),
  );

} on FirebaseAuthException catch (e) {

  setState(() {
    _isLoading = false;
  });

  String message = "Registration Failed";

  if (e.code == 'email-already-in-use') {
    message = "Email already exists";
  } else if (e.code == 'weak-password') {
    message = "Password is too weak";
  } else if (e.code == 'invalid-email') {
    message = "Invalid email address";
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}
catch (e) {
  setState(() {
    _isLoading = false;
  });

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(e.toString())),
  );
}

// <-- THIS BRACE WAS MISSING
}
  // ============================================================
  // GO TO SIGN IN
  // ============================================================

  void _goToSignIn() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    final double screenWidth = media.size.width;

    // Responsive horizontal padding
    final double horizontalPadding =
        screenWidth < 360 ? 14 : 20;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FC),

      // Prevents the keyboard from covering fields
      resizeToAvoidBottomInset: true,

      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },

          child: SingleChildScrollView(
            keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior.onDrag,

            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              18,
              horizontalPadding,
              20,
            ),

            child: Center(
              child: ConstrainedBox(
                // On mobile this uses almost the entire width.
                // On tablets it stops becoming unnecessarily wide.
                constraints: const BoxConstraints(
                  maxWidth: 500,
                ),

                child: Column(
                  children: [

                    // ==================================================
                    // SIGN UP CARD
                    // ==================================================

                    Container(
                      width: double.infinity,

                      padding: EdgeInsets.symmetric(
                        horizontal:
                            screenWidth < 360 ? 16 : 20,
                        vertical: 22,
                      ),

                      decoration: BoxDecoration(
                        color: Colors.white,

                        borderRadius:
                            BorderRadius.circular(16),

                        border: Border.all(
                          color: const Color(0xFFD8DDE1),
                        ),

                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.black.withOpacity(0.10),
                            blurRadius: 14,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),

                      child: Form(
                        key: _formKey,

                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.stretch,

                          children: [

                            // ==================================================
                            // LOGO
                            // ==================================================

                            Center(
                              child: Image.asset(
                                'lib/assets/ekikrit_logo.png',

                                width: screenWidth < 360
                                    ? 55
                                    : 65,

                                height: screenWidth < 360
                                    ? 55
                                    : 65,

                                fit: BoxFit.contain,
                              ),
                            ),

                            const SizedBox(height: 8),

                            // ==================================================
                            // TITLE
                            // ==================================================

                            const Text(
                              'Create Account',

                              textAlign: TextAlign.center,

                              style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF102033),
                              ),
                            ),

                            const SizedBox(height: 5),

                            const Text(
                              'Register to access the Ekikrit platform',

                              textAlign: TextAlign.center,

                              style: TextStyle(
                                fontSize: 10,
                                color: Color(0xFF626A70),
                              ),
                            ),

                            const SizedBox(height: 22),

                            // ==================================================
                            // FULL NAME
                            // ==================================================

                            _buildLabel('Full Name'),

                            const SizedBox(height: 6),

                            TextFormField(
                              controller: _nameController,

                              textCapitalization:
                                  TextCapitalization.words,

                              textInputAction:
                                  TextInputAction.next,

                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF344054),
                              ),

                              decoration: _inputDecoration(
                                hint: 'Enter your full name',
                                icon:
                                    Icons.person_outline,
                              ),

                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty) {
                                  return 'Please enter your name';
                                }

                                return null;
                              },
                            ),

                            const SizedBox(height: 14),

                            // ==================================================
                            // EMAIL
                            // ==================================================

                            _buildLabel('Email Address'),

                            const SizedBox(height: 6),

                            TextFormField(
                              controller: _emailController,

                              keyboardType:
                                  TextInputType.emailAddress,

                              textInputAction:
                                  TextInputAction.next,

                              autocorrect: false,

                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF344054),
                              ),

                              decoration: _inputDecoration(
                                hint: 'name@gov.in',
                                icon:
                                    Icons.mail_outline,
                              ),

                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty) {
                                  return 'Please enter your email';
                                }

                                if (!RegExp(
                                  r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                                ).hasMatch(
                                  value.trim(),
                                )) {
                                  return 'Enter a valid email address';
                                }

                                return null;
                              },
                            ),

                            const SizedBox(height: 14),

                            // ==================================================
                            // DEPARTMENT
                            // ==================================================

                            _buildLabel('Department'),

                            const SizedBox(height: 6),

                            DropdownButtonFormField<String>(
                              value: _selectedDepartment,

                              isExpanded: true,

                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                size: 20,
                              ),

                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF344054),
                              ),

                              decoration:
                                  _inputDecoration(
                                hint:
                                    'Select your department',
                                icon: Icons
                                    .account_balance_outlined,
                              ),

                              items: _departments.map(
                                (department) {
                                  return DropdownMenuItem<String>(
                                    value: department,
                                    child: Text(
                                      department,
                                      overflow:
                                          TextOverflow.ellipsis,
                                    ),
                                  );
                                },
                              ).toList(),

                              onChanged: (value) {
                                setState(() {
                                  _selectedDepartment =
                                      value;
                                });
                              },

                              validator: (value) {
                                if (value == null) {
                                  return 'Please select your department';
                                }

                                return null;
                              },
                            ),

                            const SizedBox(height: 14),

                            // ==================================================
                            // ROLE
                            // ==================================================

                            _buildLabel('Role'),

                            const SizedBox(height: 6),

                            DropdownButtonFormField<String>(
                              value: _selectedRole,

                              isExpanded: true,

                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                size: 20,
                              ),

                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF344054),
                              ),

                              decoration:
                                  _inputDecoration(
                                hint: 'Select your role',
                                icon:
                                    Icons.badge_outlined,
                              ),

                              items: _roles.map(
                                (role) {
                                  return DropdownMenuItem<String>(
                                    value: role,
                                    child: Text(role),
                                  );
                                },
                              ).toList(),

                              onChanged: (value) {
                                setState(() {
                                  _selectedRole = value;
                                });
                              },

                              validator: (value) {
                                if (value == null) {
                                  return 'Please select your role';
                                }

                                return null;
                              },
                            ),

                            const SizedBox(height: 14),

                            // ==================================================
                            // PASSWORD
                            // ==================================================

                            _buildLabel('Password'),

                            const SizedBox(height: 6),

                            TextFormField(
                              controller:
                                  _passwordController,

                              obscureText:
                                  _obscurePassword,

                              textInputAction:
                                  TextInputAction.next,

                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF344054),
                              ),

                              decoration:
                                  _inputDecoration(
                                hint: 'Create a password',
                                icon:
                                    Icons.lock_outline,

                                suffix: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword =
                                          !_obscurePassword;
                                    });
                                  },

                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons
                                            .visibility_outlined
                                        : Icons
                                            .visibility_off_outlined,

                                    size: 18,

                                    color:
                                        const Color(
                                      0xFF68747C,
                                    ),
                                  ),
                                ),
                              ),

                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty) {
                                  return 'Please enter a password';
                                }

                                if (value.length < 6) {
                                  return 'Password must contain at least 6 characters';
                                }

                                return null;
                              },
                            ),

                            const SizedBox(height: 14),

                            // ==================================================
                            // CONFIRM PASSWORD
                            // ==================================================

                            _buildLabel('Confirm Password'),

                            const SizedBox(height: 6),

                            TextFormField(
                              controller:
                                  _confirmPasswordController,

                              obscureText:
                                  _obscureConfirmPassword,

                              textInputAction:
                                  TextInputAction.done,

                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF344054),
                              ),

                              decoration:
                                  _inputDecoration(
                                hint:
                                    'Re-enter your password',
                                icon:
                                    Icons.lock_outline,

                                suffix: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscureConfirmPassword =
                                          !_obscureConfirmPassword;
                                    });
                                  },

                                  icon: Icon(
                                    _obscureConfirmPassword
                                        ? Icons
                                            .visibility_outlined
                                        : Icons
                                            .visibility_off_outlined,

                                    size: 18,

                                    color:
                                        const Color(
                                      0xFF68747C,
                                    ),
                                  ),
                                ),
                              ),

                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty) {
                                  return 'Please confirm your password';
                                }

                                if (value !=
                                    _passwordController.text) {
                                  return 'Passwords do not match';
                                }

                                return null;
                              },

                              onFieldSubmitted: (_) {
                                _createAccount();
                              },
                            ),

                            const SizedBox(height: 8),

                            // ==================================================
                            // TERMS
                            // ==================================================

                            Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.center,

                              children: [

                                SizedBox(
                                  width: 24,
                                  height: 24,

                                  child: Checkbox(
                                    value: _agreeToTerms,

                                    activeColor:
                                        const Color(0xFF087F78),

                                    side: const BorderSide(
                                      color:
                                          Color(0xFFD0D7DE),
                                    ),

                                    onChanged: (value) {
                                      setState(() {
                                        _agreeToTerms =
                                            value ?? false;
                                      });
                                    },
                                  ),
                                ),

                                const SizedBox(width: 5),

                                const Expanded(
                                  child: Text(
                                    'I agree to the terms and conditions',

                                    style: TextStyle(
                                      fontSize: 10,
                                      color:
                                          Color(0xFF606970),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 18),

                            // ==================================================
                            // CREATE ACCOUNT BUTTON
                            // ==================================================

                            SizedBox(
                              width: double.infinity,
                              height: 46,

                              child: ElevatedButton(
                                onPressed: _isLoading
                                    ? null
                                    : _createAccount,

                                style:
                                    ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color(0xFF087F78),

                                  disabledBackgroundColor:
                                      const Color(0xFF087F78),

                                  foregroundColor:
                                      Colors.white,

                                  elevation: 0,

                                  shape:
                                      RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(
                                      10,
                                    ),
                                  ),
                                ),

                                child: _isLoading
                                    ? const SizedBox(
                                        width: 19,
                                        height: 19,

                                        child:
                                            CircularProgressIndicator(
                                          strokeWidth: 2,

                                          color:
                                              Colors.white,
                                        ),
                                      )
                                    : const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment
                                                .center,

                                        children: [

                                          Text(
                                            'Create Account',

                                            style:
                                                TextStyle(
                                              fontSize: 12,
                                              fontWeight:
                                                  FontWeight
                                                      .w500,
                                            ),
                                          ),

                                          SizedBox(width: 7),

                                          Icon(
                                            Icons.arrow_forward,
                                            size: 17,
                                          ),
                                        ],
                                      ),
                              ),
                            ),

                            const SizedBox(height: 17),

                            // ==================================================
                            // SIGN IN
                            // ==================================================

                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,

                              children: [

                                const Text(
                                  'Already have an account? ',

                                  style: TextStyle(
                                    fontSize: 10,
                                    color:
                                        Color(0xFF737B81),
                                  ),
                                ),

                                GestureDetector(
                                  onTap: _goToSignIn,

                                  child: const Text(
                                    'Sign In',

                                    style: TextStyle(
                                      fontSize: 10,
                                      color:
                                          Color(0xFF087F78),
                                      fontWeight:
                                          FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // ==================================================
                            // SECURITY
                            // ==================================================

                            const Icon(
                              Icons.lock_outline,
                              size: 15,
                              color: Color(0xFF087F78),
                            ),

                            const SizedBox(height: 5),

                            const Text(
                              'Secure Government Platform',

                              textAlign: TextAlign.center,

                              style: TextStyle(
                                fontSize: 9,
                                color: Color(0xFF087F78),
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            const SizedBox(height: 4),

                            const Text(
                              'This service is restricted to authorized\n'
                              'personnel only. All access and activity is\n'
                              'logged and monitored.',

                              textAlign: TextAlign.center,

                              style: TextStyle(
                                fontSize: 7.5,
                                height: 1.35,
                                color: Color(0xFF858C91),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ==================================================
                    // COPYRIGHT
                    // ==================================================

                    const SizedBox(height: 15),

                    const Text(
                      '© 2024 Ekikrit Administrative Infrastructure.\n'
                      'All rights reserved.',

                      textAlign: TextAlign.center,

                      style: TextStyle(
                        fontSize: 8,
                        height: 1.35,
                        color: Color(0xFF4E555A),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // LABEL
  // ============================================================

  Widget _buildLabel(String text) {
    return Text(
      text,

      style: const TextStyle(
        fontSize: 10,
        color: Color(0xFF40484D),
        fontWeight: FontWeight.w400,
      ),
    );
  }

  // ============================================================
  // INPUT DECORATION
  // ============================================================

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,

      hintStyle: const TextStyle(
        fontSize: 12,
        color: Color(0xFF89929A),
      ),

      prefixIcon: Icon(
        icon,
        size: 18,
        color: const Color(0xFF68747C),
      ),

      suffixIcon: suffix,

      filled: true,

      fillColor: const Color(0xFFF7F9FB),

      contentPadding:
          const EdgeInsets.symmetric(
        vertical: 13,
        horizontal: 12,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),

        borderSide: const BorderSide(
          color: Color(0xFFD0D7DE),
        ),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),

        borderSide: const BorderSide(
          color: Color(0xFFD0D7DE),
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),

        borderSide: const BorderSide(
          color: Color(0xFF087F78),
          width: 1.2,
        ),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),

        borderSide: const BorderSide(
          color: Colors.redAccent,
        ),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),

        borderSide: const BorderSide(
          color: Colors.redAccent,
          width: 1.2,
        ),
      ),
    );
  }
}