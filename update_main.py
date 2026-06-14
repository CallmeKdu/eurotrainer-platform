import re

with open('lib/main.dart', 'r') as f:
    content = f.read()

# Add import
imports = """import 'presentation/viewmodels/notes_viewmodel.dart';
"""
content = re.sub(r"(import 'presentation/viewmodels/auth_viewmodel.dart';)", r"\1\n" + imports, content)

# Add provider
provider = "          ChangeNotifierProvider(create: (_) => di.sl<NotesViewModel>()),"
content = re.sub(r"(ChangeNotifierProvider\(create: \(\_\) => di\.sl<AuthViewModel>\(\)\),)", r"\1\n" + provider, content)

with open('lib/main.dart', 'w') as f:
    f.write(content)
