import re

with open('lib/core/injection.dart', 'r') as f:
    content = f.read()

# Add imports
imports = """import '../data/repositories/note_repository.dart';
import '../data/services/firestore_note_service.dart';
import '../presentation/viewmodels/notes_viewmodel.dart';
"""
content = re.sub(r"(import '../data/services/firestore_user_service.dart';)", r"\1\n" + imports, content)

# Add service
service = "  sl.registerLazySingleton<FirestoreNoteService>(() => FirestoreNoteService());"
content = re.sub(r"(sl.registerLazySingleton<FirestoreUserService>\(\(\) => FirestoreUserService\(\)\);)", r"\1\n" + service, content)

# Add repository
repo = "  sl.registerLazySingleton<NoteRepository>(() => NoteRepository(sl()));"
content = re.sub(r"(sl.registerLazySingleton<AuthRepository>\(\(\) => AuthRepository\(sl\(\), sl\(\)\)\);)", r"\1\n" + repo, content)

# Add viewmodel
vm = "  sl.registerFactory<NotesViewModel>(() => NotesViewModel(sl(), sl()));"
content = re.sub(r"(sl.registerFactory<CoursePlayerViewModel>\(\(\) => CoursePlayerViewModel\(\)\);)", r"\1\n" + vm, content)

with open('lib/core/injection.dart', 'w') as f:
    f.write(content)
