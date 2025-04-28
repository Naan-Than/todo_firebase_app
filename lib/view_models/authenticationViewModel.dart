import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/models/userResponse.dart';
import 'package:todo/utils/utility.dart';


class AuthenticationViewModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  List<UserResponse> _users = [];
  List<UserResponse> get users => _users;
  List<UserResponse> _allUsers = [];
  List<UserResponse> get allUsers => _allUsers;
  List<UserResponse> _allWithUsers = [];
  List<UserResponse> get allWithUsers => _allWithUsers;



  bool _isLoading = false;
  bool _isHiddenPassword = true;
  bool _isShowIcon = false;
  bool _isFetchingUsers = false;


  bool get isLoading => _isLoading;
  bool get isHiddenPassword => _isHiddenPassword;
  bool get isShowIcon => _isShowIcon;
  bool get isFetchingUsers => _isFetchingUsers;

  void togglePasswordVisibility() {
    _isHiddenPassword = !_isHiddenPassword;
    notifyListeners();
  }

  void toggleShowIcon() {
    _isShowIcon = !_isShowIcon;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
  void setLoadUsers(bool value) {
    _isFetchingUsers = value;
    notifyListeners();
  }

  Future<void> register(BuildContext context) async {
    setLoading(true);
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final name = nameController.text.trim();

    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final User? user = userCredential.user;

      if (user != null) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(Utility.uid, user.uid);
        await prefs.setString(Utility.email, user.email ?? '');
        await prefs.setString(Utility.userName, name ?? '');
        await prefs.setBool(Utility.isLoggedIn, true);

        final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
        await userDoc.set({
          'id': user.uid,
          'email': user.email,
          'displayName': name,
          'createdAt': FieldValue.serverTimestamp(),
        });

        print('User registered and document created');
        Navigator.pushReplacementNamed(context, Utility.routeHome);
      }
    } on FirebaseAuthException catch (e) {
      print('Register error: ${e.message}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Registration failed")),
      );
    } catch (e) {
      print('Register error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Something went wrong")),
      );
    } finally {
      setLoading(false);
    }
  }

  Future<void> login(BuildContext context) async {
    setLoading(true);
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      final User? user = userCredential.user;

      if (user != null) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        print('user........$user');
        print('user........${user.displayName}');

        await prefs.setString(Utility.uid, user.uid);
        await prefs.setString(Utility.email, user.email ?? '');
        await prefs.setString(Utility.userName, user.displayName ?? '');
        await prefs.setBool(Utility.isLoggedIn, true);
        Navigator.pushReplacementNamed(context, '/home');
      }

      print('Login successful');
    } on FirebaseAuthException catch (e) {
      print('Login error: ${e.message}');
      if (email.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Enter Valid email and password")),
        );
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Login failed")),
      );
    } catch (e) {
      print('Login error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Something went wrong")),
      );
    } finally {
      setLoading(false);
    }
  }

  Future<void> logout(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(Utility.isLoggedIn, false);
    await prefs.setString(Utility.uid, '');
    await prefs.setString(Utility.email, '');
    await prefs.setString(Utility.userName, '');
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, Utility.routeLogin);
  }


  Future<void> fetchUsers() async {
    try {
      final userCollection = FirebaseFirestore.instance.collection('users');
      final querySnapshot = await userCollection.get();

      _users = querySnapshot.docs.map((doc) {
        return UserResponse.fromFirestore(doc.data(), doc.id);
      }).toList();

      print('Fetched Users: $_users');
      _users.forEach((user) {
        print(user);
      });

      notifyListeners();
    } catch (e) {
      print("Error fetching users: $e");
    }
  }

  Future<void> getAllUsersExceptCurrent(String currentUid) async {
    setLoadUsers(true);
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where(FieldPath.documentId, isNotEqualTo: currentUid)
          .get();

      _allUsers = snapshot.docs.map((doc) {
        return UserResponse.fromFirestore(doc.data(), doc.id);
      }).toList();

      print('Fetched All Users Except Current: $_allUsers');
      notifyListeners();
    } catch (e) {
      print('Error fetching all users except current: $e');
    }
    finally{
      setLoadUsers(false);
    }
  }

  Future<void> getAllUsersIncludingCurrent() async {
    setLoadUsers(true);
    try {
      final snapshot = await FirebaseFirestore.instance.collection('users').get();

      _allWithUsers = snapshot.docs.map((doc) {
        return UserResponse.fromFirestore(doc.data(), doc.id);
      }).toList();

      print('Fetched All Users (Including Current): $_allWithUsers');
      notifyListeners();
    } catch (e) {
      print('Error fetching all users (including current): $e');
    } finally {
      setLoadUsers(false);
    }
  }
  void disposeControllers() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
  }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }
}
