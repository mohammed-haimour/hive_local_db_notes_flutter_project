// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_local_db_notes/constants.dart';

import 'package:hive_local_db_notes/models/note_models.dart';

part 'read_notes_state.dart';

class ReadNotesCubit extends Cubit<ReadNotesState> {
  ReadNotesCubit() : super(ReadNotesInitial());

  List<NoteModel>? notes;

  Future<void> fetchAllNotes() async {
    try {
      var notesBox = Hive.box<NoteModel>(KNotesBox);
      notes = notesBox.values.toList();

      emit(ReadNotesSuccess());
    } catch (e) {
      emit(ReadNotesFailuer(e.toString()));
    }
  }
}
