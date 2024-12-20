import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_to_do_list/model/notes_model.dart';
import 'package:uuid/uuid.dart';

class Firestore_Datasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create a user document in Firestore
  Future<bool> CreateUser(String email) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .set({"id": _auth.currentUser!.uid, "email": email});
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  // Add a new note with the dueDate
  Future<bool> AddNote(String subtitle, String title, int image, DateTime dueDate) async {
    try {
      var uuid = Uuid().v4();
      DateTime data = DateTime.now();
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('notes')
          .doc(uuid)
          .set({
        'id': uuid,
        'subtitle': subtitle,
        'isDon': false,
        'image': image,
        'time': '${data.hour}:${data.minute}',
        'title': title,
        'dueDate': Timestamp.fromDate(dueDate), // Store dueDate as Timestamp
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  // Get all notes from Firestore, including dueDate
  List<Note> getNotes(QuerySnapshot snapshot) {
    try {
      final notesList = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Note(
          id: data['id'],
          subtitle: data['subtitle'],
          time: data['time'],
          image: data['image'],
          title: data['title'],
          isDon: data['isDon'],
          dueDate: (data['dueDate'] as Timestamp).toDate(), // Convert Timestamp to DateTime
        );
      }).toList();
      return notesList;
    } catch (e) {
      print(e);
      return [];
    }
  }

  // Stream notes based on completion status (isDone)
  Stream<QuerySnapshot> stream(bool isDone) {
    return _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('notes')
        .where('isDon', isEqualTo: isDone)
        .snapshots();
  }

  // Update the completion status of a note
  Future<bool> isdone(String uuid, bool isDon) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('notes')
          .doc(uuid)
          .update({'isDon': isDon});
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  // Update a note (including subtitle, title, image, and dueDate)
  Future<bool> Update_Note(
      String uuid, int image, String title, String subtitle, DateTime dueDate) async {
    try {
      DateTime data = DateTime.now();
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('notes')
          .doc(uuid)
          .update({
        'time': '${data.hour}:${data.minute}',
        'subtitle': subtitle,
        'title': title,
        'image': image,
        'dueDate': Timestamp.fromDate(dueDate), // Update dueDate as Timestamp
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  // Delete a note
  Future<bool> delet_note(String uuid) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('notes')
          .doc(uuid)
          .delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
