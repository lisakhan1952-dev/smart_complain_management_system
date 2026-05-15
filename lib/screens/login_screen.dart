import 'package:flutter/material.dart';
import 'package:smart_complain_management_system/screens/dashboard_screen.dart';
import 'package:smart_complain_management_system/screens/signup_screen.dart';
import 'package:smart_complain_management_system/services/mongodb_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isObscured = true;
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeIn));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showAwesomeAlert(String title, String message, bool isSuccess) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: (isSuccess ? Colors.green : Colors.red).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isSuccess ? Icons.verified_user_rounded : Icons.gpp_bad_rounded,
                color: isSuccess ? Colors.green : Colors.red,
                size: 50,
              ),
            ),
            const SizedBox(height: 20),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 22, color: Color(0xFF1A1F36))),
          ],
        ),
        content: Text(message, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade600)),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A1F36),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text("Understood", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    var user = await MongoDatabase.login(email, password);
    setState(() => _isLoading = false);

    if (user != null) {
      _showAwesomeAlert("Auth Success", "Establishing secure connection to BAUST CMS...", true);
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashboardPage()));
        }
      });
    } else {
      _showAwesomeAlert("Access Denied", "The credentials provided do not match our records.", false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1A1F36);
    const Color accentColor = Color(0xFF6366F1);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Aesthetic
          Positioned(
            top: -100, right: -100,
            child: CircleAvatar(radius: 150, backgroundColor: accentColor.withOpacity(0.05)),
          ),
          Positioned(
            bottom: -50, left: -50,
            child: CircleAvatar(radius: 100, backgroundColor: accentColor.withOpacity(0.03)),
          ),
          
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Hero(
                          tag: 'logo',
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(35),
                              boxShadow: [BoxShadow(color: primaryColor.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
                            ),
                            child: const Icon(Icons.shield_moon_rounded, size: 60, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 40),
                        const Text("Terminal Login", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: primaryColor, letterSpacing: -1)),
                        const SizedBox(height: 8),
                        Text("Authorized Personnel Only", style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.w600, fontSize: 14)),
                        const SizedBox(height: 50),

                        _buildTextField(
                          controller: _emailController,
                          label: "University Email",
                          icon: Icons.alternate_email_rounded,
                          validator: (v) => (v == null || !v.contains("@")) ? "Invalid credentials" : null,
                        ),
                        const SizedBox(height: 20),

                        _buildTextField(
                          controller: _passwordController,
                          label: "Secret Key",
                          icon: Icons.vpn_key_rounded,
                          isPassword: true,
                          obscureText: _isObscured,
                          onToggle: () => setState(() => _isObscured = !_isObscured),
                          validator: (v) => (v == null || v.length < 4) ? "Incomplete key" : null,
                        ),
                        
                        const SizedBox(height: 40),

                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              elevation: 0,
                            ),
                            child: _isLoading 
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text("Authenticate", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                          ),
                        ),
                        
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("New to the system?", style: TextStyle(color: Colors.grey.shade600)),
                            TextButton(
                              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupPage())),
                              child: const Text("Request Access", style: TextStyle(color: accentColor, fontWeight: FontWeight.w900)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggle,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey.shade400, size: 20),
        suffixIcon: isPassword ? IconButton(
          icon: Icon(obscureText ? Icons.visibility_off_rounded : Icons.visibility_rounded, color: Colors.grey.shade400, size: 20),
          onPressed: onToggle,
        ) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: Colors.grey.shade200)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: Colors.grey.shade100)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2)),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }
}
