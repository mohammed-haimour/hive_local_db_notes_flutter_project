import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_local_db_notes/cubits/add_notes_cubit/add_note_cubit.dart';
import 'package:hive_local_db_notes/cubits/read_notes_cubit/read_notes_cubit.dart';
import 'package:hive_local_db_notes/models/note_models.dart';
import 'package:hive_local_db_notes/views/widgets/custom_text_field.dart';

import 'custom_button.dart';

class AddNoteBottomSheet extends StatelessWidget {
  const AddNoteBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddNoteCubit(),
      child: Padding(
        padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: const SingleChildScrollView(
          child: AddNoteForm(),
        ),
      ),
    );
  }
}

class AddNoteForm extends StatefulWidget {
  const AddNoteForm({
    super.key,
  });

  @override
  State<AddNoteForm> createState() => _AddNoteFormState();
}

class _AddNoteFormState extends State<AddNoteForm> {
  final GlobalKey<FormState> formKey = GlobalKey();

  String? title, subTitle;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddNoteCubit, AddNoteState>(
      listener: (context, state) {
        if (state is AddNoteFailure) {
          // ignore: avoid_print
          print(state.errMsg);
        }
        if (state is AddNoteSuccess) {
          BlocProvider.of<ReadNotesCubit>(context).fetchAllNotes();

          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        if (state is AddNoteLoading) {
          return const SizedBox(
            height: 375,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 32,
                ),
                CustomTextField(
                  onSaved: (value) {
                    title = value;
                  },
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return "This Field Is required";
                    } else {
                      return null;
                    }
                  },
                  hint: const Text('title'),
                ),
                const SizedBox(
                  height: 16,
                ),
                CustomTextField(
                  onSaved: (value) {
                    subTitle = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "This Field Is required";
                    } else {
                      return null;
                    }
                  },
                  hint: const Text("content"),
                  maxLines: 5,
                ),
                const SizedBox(
                  height: 32,
                ),
                CustomButton(
                  onClick: () async {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      NoteModel note = NoteModel(
                          title: title!,
                          subTitle: subTitle!,
                          date: DateTime.now().toString(),
                          color: Colors.red.value);
                      await BlocProvider.of<AddNoteCubit>(context)
                          .addNote(note);
                    } else {}
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
