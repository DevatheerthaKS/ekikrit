import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscure = true;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xffEEF3F8),

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(14),
            child: Container(
              width: 380,
              padding: const EdgeInsets.symmetric(
                horizontal: 22,
                vertical: 24,
              ),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(.18),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  )
                ],
              ),

              child: Column(
                children: [

                  /// Logo
                  Image.asset(
                    "lib/assets/ekikrit_logo.png",
                    height: 55,
                  ),

                  const SizedBox(height: 14),

                  const Text(
                    "Sign In",
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Enter your credentials to access the\nplatform",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 32),

                  /// Email
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Email Address",
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(

                      hintText: "name@gov.in",

                      prefixIcon: const Icon(Icons.mail_outline),

                      filled: true,
                      fillColor: const Color(0xffF7F8FB),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  /// Password Row

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Text(
                        "Password",
                        style: TextStyle(
                          color: Colors.grey.shade800,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      TextButton(
                        onPressed: () {},

                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: Color(0xff0F7C73),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  TextField(
                    controller: passwordController,

                    obscureText: obscure,

                    decoration: InputDecoration(

                      prefixIcon:
                          const Icon(Icons.lock_outline),

                      suffixIcon: IconButton(
                        icon: Icon(
                          obscure
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () {
                          setState(() {
                            obscure = !obscure;
                          });
                        },
                      ),

                      filled: true,
                      fillColor: const Color(0xffF7F8FB),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// Login Button

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(

                      onPressed: () async {

  if (emailController.text.trim().isEmpty ||
      passwordController.text.trim().isEmpty) {

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Please enter email and password"),
      ),
    );
    return;
  }

  try {

    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const DashboardScreen(),
      ),
    );

  } on FirebaseAuthException catch (e) {

    String message = "Login Failed";

    switch (e.code) {

      case 'user-not-found':
        message = "No user found with this email";
        break;

      case 'wrong-password':
        message = "Incorrect password";
        break;

      case 'invalid-email':
        message = "Invalid email address";
        break;

      case 'invalid-credential':
        message = "Invalid email or password";
        break;

      case 'user-disabled':
        message = "This account has been disabled";
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );

  } catch (e) {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString())),
    );

  }

},

                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor:
                            const Color(0xff0F7C73),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(15),
                        ),
                      ),

                      child: const Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [

                          Text(
                            "Login to Dashboard",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),

                          SizedBox(width: 10),

                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  /// OR

                  Row(
                    children: [

                      Expanded(
                        child: Divider(
                          color: Colors.grey.shade400,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12),
                        child: Text(
                          "OR",
                          style: TextStyle(
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),

                      Expanded(
                        child: Divider(
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

const SizedBox(height: 20),

Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [

    Text(
      "Don't have an account? ",
      style: TextStyle(
        color: Colors.grey.shade700,
        fontSize: 14,
      ),
    ),

    GestureDetector(
      onTap: () {

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const SignupScreen(),
          ),
        );

      },
      child: const Text(
        "Sign Up",
        style: TextStyle(
          color: Color(0xff0F7C73),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    ),

  ],
),

const SizedBox(height: 28),

                  const SizedBox(height: 28),

                  Divider(color: Colors.grey.shade300),

                  const SizedBox(height: 18),

                  Icon(
                    Icons.lock,
                    color: Colors.green.shade700,
                    size: 22,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Secure Government Platform",
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "This system is restricted to authorized\npersonnel only. All access and activity is\nlogged and monitored.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 26),

                  Text(
                    "© 2026 Ekikrit Administrative Infrastructure.\nAll rights reserved.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}