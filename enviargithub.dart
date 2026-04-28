import 'dart:io';

void main() async {
  print('==================================================');
  print('🚀 Agente Interactivo para Enviar a GitHub');
  print('==================================================\n');

  // 1. Preguntar por el link del nuevo repositorio
  stdout.write('🔗 1. Introduce el link del repositorio de GitHub (ej. https://github.com/usuario/repo.git):\n> ');
  String? repoUrl = stdin.readLineSync()?.trim();

  if (repoUrl == null || repoUrl.isEmpty) {
    print('❌ Error: El link del repositorio es obligatorio para continuar.');
    return;
  }

  // 2. Preguntar por el mensaje del commit
  stdout.write('\n📝 2. Introduce el mensaje del commit:\n> ');
  String? commitMessage = stdin.readLineSync()?.trim();

  if (commitMessage == null || commitMessage.isEmpty) {
    commitMessage = 'Actualización del proyecto';
    print('⚠️ No se introdujo mensaje de commit. Se usará "$commitMessage" por defecto.');
  }

  // 3. Preguntar por la rama (default: main)
  stdout.write('\n🌿 3. Introduce el nombre de la rama (presiona Enter para usar "main" por defecto):\n> ');
  String? branchNameInput = stdin.readLineSync()?.trim();
  String branchName = (branchNameInput != null && branchNameInput.isNotEmpty) ? branchNameInput : 'main';

  print('\n--------------------------------------------------');
  print('📋 Resumen de Acción:');
  print('   - Repositorio : $repoUrl');
  print('   - Commit      : "$commitMessage"');
  print('   - Rama        : $branchName');
  print('--------------------------------------------------\n');

  stdout.write('¿Deseas proceder con estos datos? (s/n): ');
  String? confirm = stdin.readLineSync()?.trim().toLowerCase();
  
  if (confirm != 's' && confirm != 'si') {
    print('Operación cancelada por el usuario.');
    return;
  }

  print('\n⚙️ Ejecutando comandos...\n');

  // Inicializar git si el directorio .git no existe
  bool gitInitialized = await Directory('.git').exists();
  if (!gitInitialized) {
    await runCommand('git', ['init']);
  }

  // Agregar los archivos al área de preparación
  await runCommand('git', ['add', '.']);

  // Realizar el commit
  await runCommand('git', ['commit', '-m', commitMessage]);

  // Renombrar/cambiar a la rama indicada
  await runCommand('git', ['branch', '-M', branchName]);

  // Verificar si ya existe 'origin' para agregar o actualizar la URL
  var checkRemote = await Process.run('git', ['remote']);
  if (checkRemote.stdout.toString().contains('origin')) {
    await runCommand('git', ['remote', 'set-url', 'origin', repoUrl]);
  } else {
    await runCommand('git', ['remote', 'add', 'origin', repoUrl]);
  }

  // Realizar el push a la rama
  print('\n📤 Enviando archivos a GitHub...');
  var pushResult = await runCommand('git', ['push', '-u', 'origin', branchName]);
  
  if (pushResult == 0) {
    print('\n✅ ¡Repositorio enviado a GitHub con éxito!');
  } else {
    print('\n❌ Hubo un error al enviar el repositorio a GitHub o no hay cambios nuevos para subir.');
  }
}

/// Función de ayuda para ejecutar comandos y mostrar la salida en tiempo real.
Future<int> runCommand(String executable, List<String> arguments) async {
  print('> \$ $executable ${arguments.join(' ')}');
  var process = await Process.start(executable, arguments, runInShell: true);
  
  // Conectar las secuencias de salida estándar y de error para verlas en consola
  stdout.addStream(process.stdout);
  stderr.addStream(process.stderr);
  
  return await process.exitCode;
}
