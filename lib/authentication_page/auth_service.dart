import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final month=['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
  String userName="";
  Future<String> registerUser(String email, String f_name, String l_name, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      userName=f_name+" "+l_name;
      // Storing user's details without saving the password
      await _firestore.collection("Users").doc(userCredential.user!.uid).set({
        "username": "$f_name $l_name",
        "email": email,
        "password":password,
        'createdAt': DateTime.now(),
        'Id':_auth.currentUser?.uid
      });
      return "Registration successful";
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'weak-password') {
          return "Your password is too weak";
        } else if (e.code == 'email-already-in-use') {
          return "An account already exists with this email";
        } else if (e.code == 'invalid-email') {
          return "The email address is not valid";
        }
      }
      return "Failed to register: ${e.toString()}";
    }
  }

  Future<String> loginUser(String email, String password) async {
    try {
      // First, check if the user exists in Firestore
      bool userExists = await checkUserExists(email);
      if (!userExists) {
        return "No user found with this email"; // If email doesn't exist
      }

      // If the user exists, now check password match
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        // Check if password matches Firestore data
        String? storedPassword = await getPassword(email);
        if (storedPassword != null && storedPassword == password) {
          return "Login successful"; // If password matches
        } else {
          return "Password does not match"; // If password doesn't match
        }
      }
      return "Failed to login";
    } catch (e) {
      if (e is FirebaseAuthException) {
        print("Auth");
        print(e.code);
        if (e.code == 'wrong-password') {
          return "Password does not match"; // If password is incorrect
        } else if (e.code == 'user-not-found') {
          return "No user found with this email"; // If user is not found in FirebaseAuth
        } else if (e.code == 'invalid-email') {
          return "The email address is not valid"; // If email format is invalid
        }
      }
      return "Failed to login: ${e.toString()}"; // Generic error message
    }
  }



  /// Checks if a user exists in Firestore based on their email.
  Future<bool> checkUserExists(String email) async {
    QuerySnapshot userSnapshot = await _firestore.collection("Users").where("email", isEqualTo: email).get();
    return userSnapshot.docs.isNotEmpty;
  }

  /// Retrieves the password for a given email (not recommended to store passwords).
  Future<String?> getPassword(String email) async {
    QuerySnapshot user = await _firestore.collection("Users").where("email", isEqualTo: email).get();
    if (user.docs.isNotEmpty) {
      var doc = user.docs.first;
      var data = doc.data() as Map<String, dynamic>;
      return data["password"]; // Consider removing this method for security reasons.
    }
    return null;
  }

  /// Logs in a user with email and password.
  // Future<bool> loginUser(String email, String password) async {
  //   try {
  //     await _auth.signInWithEmailAndPassword(email: email, password: password);
  //     return true;
  //   } catch (e) {
  //     if (e is FirebaseAuthException) {
  //
  //     } else {
  //
  //     }
  //     return false;
  //   }
  // }
  Stream<QuerySnapshot<Map<String, dynamic>>> fetchUserData() {
    User? user = _auth.currentUser;
    if (user == null) throw Exception("User not authenticated.");
    print(_auth.currentUser?.uid);
    return FirebaseFirestore.instance
        .collection("MediaFileWithLocation")
        .where("userId", isEqualTo: user.uid)
        .orderBy("createdAt", descending: true)
        .snapshots();
  }
  Stream<List<Map<String, dynamic>>> getMediaDataStream() {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception("User not authenticated.");
    }

    return _firestore
        .collection("MediaFileWithLocation").where("userId" ,isEqualTo: user.uid)
        .orderBy("createdAt", descending: true) // Orders by latest created
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  Future<bool> deleteMediaData(String id) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) throw Exception("User not authenticated.");

      // Step 1: Fetch the document by ID from Firestore
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection("MediaFileWithLocation")
          .where("id", isEqualTo: id)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception("Media with ID $id not found in Firestore.");
      }

      // Assuming IDs are unique, take the first document
      DocumentSnapshot<Map<String, dynamic>> doc = querySnapshot.docs.first;

      // Get the download URL for storage reference
      String? downloadURL = doc.data()?['downloadURL'];
      if (downloadURL == null) {
        throw Exception("Download URL not found for the given media.");
      }

      // Step 2: Delete the file from Firebase Storage
      String storagePath = _storage.refFromURL(downloadURL).fullPath;
      await _storage.ref(storagePath).delete();

      // Step 3: Delete the Firestore document
      await _firestore.collection("MediaFileWithLocation").doc(doc.id).delete();

      print("Media with ID $id deleted successfully.");
      return true;
    } catch (e) {
      print("Error deleting media: ${e.toString()}");
      return false;
    }
  }

  Future<String?> getUserName() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return null;

      final doc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get();

      if (doc.exists && doc.data() != null) {
        return doc['name'] as String?;
      }
    } catch (e) {
      print('Error fetching user name: $e');
    }
    return null; // Return null if not found or error
  }
  Future<bool> storeMediaData({
    required File mediaFile,
    required String fileType,
    required double latitude,
    required double longitude,
    required String description,
    required String Id,
    required String faultName
  }) async {
    late DateTime dateTime=DateTime.now();
    try {
      User? user = _auth.currentUser;
      if (user == null) throw Exception("User not authenticated.");

      String filePath = "media/${user.uid}/${DateTime.now().millisecondsSinceEpoch}.${fileType == 'image' ? 'jpg' : 'mp4'}";
      TaskSnapshot uploadTask = await _storage.ref(filePath).putFile(mediaFile);
      String downloadURL = await uploadTask.ref.getDownloadURL();
      String uid=user.uid;
      // final response= await http.get(Uri.parse("https://locationapi-rr40.onrender.com/nearest_location?lat=${latitude}&lon=${longitude}"));
      // if(response.statusCode!=200){
      //   throw Exception("Server busy please try after some time");
      // }
      // Map<String,dynamic> data= jsonDecode(response.body);
      await _firestore.collection("MediaFileWithLocation").add({
        "adminLocationName":"",
        "userId": uid,
        "id":Id,
        "downloadURL": downloadURL,
        "fileType": fileType,
        "latitude": latitude,
        "longitude": longitude,
        "description": description,
        "createdAt": DateTime.now(),
        "date": "${dateTime.day < 10 ? "0${dateTime.day}":dateTime.day} ${month[dateTime.month-1]} ${dateTime.year}",
        "time":"${dateTime.hour < 10 ? "0${dateTime.hour}":dateTime.hour} : ${dateTime.minute < 10 ? "0${dateTime.minute}":dateTime.minute} : ${dateTime.second < 10 ? "0${dateTime.second}":dateTime.second}",
        "statusList":[
          {"message":"Report confirmed","completed":true},
          {"message":"Admin reported to workers","completed":true},
          {"message":"Work has been started on this issue","completed":false},
          {"message":"Issue has been solved","completed":false}
        ],
        "completedURLType":"",
        "completedUrl":"",
        "uploadedAt":"",
        "isCompleted":false,
        'UserName':await getUserName(),
        "faultName":faultName,
        "inProcess":true,
        "completed":false
      });
      return true;
    } catch (e) {
      print("Error ${e.toString()}");
      return false;
    }
  }
}
