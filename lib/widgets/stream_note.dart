import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_to_do_list/widgets/task_widgets.dart';

import '../data/firestor.dart';

class Stream_note extends StatelessWidget {
  final bool done;

  // Yapıcı fonksiyon
  Stream_note(this.done, {super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore_Datasource().stream(done),
      builder: (context, snapshot) {
        // Veriler henüz gelmediyse, yükleniyor animasyonu göster
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        // snapshot.data artık QuerySnapshot türünde olduğundan, .data kullanmak yerine direkt snapshot.data'yi geçebilirsiniz.
        final notesList = Firestore_Datasource().getNotes(snapshot.data!);

        return ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final note = notesList[index];
            return Dismissible(
              key: UniqueKey(),
              onDismissed: (direction) {
                Firestore_Datasource().delet_note(note.id);
              },
              child: Task_Widget(note: note, dueDate: note.dueDate), // named parameters kullanılıyor
            );
          },
          itemCount: notesList.length,
        );
      },
    );
  }
}
