part of 'read_notes_cubit.dart';

abstract class ReadNotesState {}

class ReadNotesInitial extends ReadNotesState {}

class ReadNotesSuccess extends ReadNotesState {
}


class ReadNotesFailuer extends ReadNotesState {
  final String err;
  ReadNotesFailuer(this.err);
}
