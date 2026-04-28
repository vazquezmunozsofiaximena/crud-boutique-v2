import 'dart:io';

void main() async {
  print('=============================================');
  print('    Agente para Enviar a GitHub (Dart)       ');
  print('=============================================');

  // 1. Preguntar por el link del nuevo repositorio
  stdout.write('1. Ingresa el enlace (URL) del repositorio de GitHub: ');
  String? repoLink = stdin.readLineSync()?.trim();

  if (repoLink == null || repoLink.isEmpty) {
    print('Error: El enlace del repositorio no puede estar vacío.');
    return;
  }

  // 2. Preguntar por el mensaje del commit
  stdout.write('2. Ingresa el mensaje de commit (Ej. "Primer commit"): ');
  String? commitMessage = stdin.readLineSync()?.trim();

  if (commitMessage == null || commitMessage.isEmpty) {
    commitMessage = "Primer commit";
    print('-> Usando mensaje de commit por defecto: "$commitMessage"');
  }

  // 3. Preguntar por el nombre de la rama (por defecto 'main')
  stdout.write('3. Ingresa el nombre de la rama (presiona Enter para usar "main"): ');
  String? branchName = stdin.readLineSync()?.trim();

  if (branchName == null || branchName.isEmpty) {
    branchName = "main";
  }
  
  print('\n---------------------------------------------');
  print('Resumen de la operación a realizar:');
  print('URL Repositorio : $repoLink');
  print('Mensaje Commit  : "$commitMessage"');
  print('Rama a subir    : $branchName');
  print('---------------------------------------------');
  
  stdout.write('\n¿Deseas continuar con estos datos? (s/n): ');
  String? confirm = stdin.readLineSync()?.trim().toLowerCase();
  
  if (confirm != 's' && confirm != 'si' && confirm != 'y' && confirm != 'yes') {
    print('Operación cancelada por el usuario.');
    return;
  }

  print('\nIniciando secuencia Git para subir a GitHub...');

  // Función de ayuda para ejecutar comandos Git en la terminal
  Future<void> runGitCommand(List<String> arguments, {bool ignoreError = false}) async {
    print('> \$ git ${arguments.join(' ')}');
    var result = await Process.run('git', arguments, runInShell: true);
    
    if (result.stdout.toString().trim().isNotEmpty) {
      print(result.stdout);
    }
    
    if (result.stderr.toString().trim().isNotEmpty && !ignoreError) {
      // Git a veces envía advertencias y mensajes de éxito al stderr (ej. git push y git add)
      // Lo imprimimos pero no necesariamente detenemos el programa a menos que falle.
      print(result.stderr);
    }
  }

  try {
    // 1. Inicializar repositorio (seguro de correr múltiples veces)
    await runGitCommand(['init']);

    // 2. Agregar todos los archivos
    await runGitCommand(['add', '.']);

    // 3. Crear commit
    await runGitCommand(['commit', '-m', commitMessage], ignoreError: true); // Ignore error in case "nothing to commit"

    // 4. Cambiar a la rama indicada
    await runGitCommand(['branch', '-M', branchName]);

    // 5. Configurar o actualizar el origen remoto
    // Primero intentamos remover cualquier origen previo (ignorado al dar error si no existe)
    await runGitCommand(['remote', 'remove', 'origin'], ignoreError: true);
    // Luego agregamos el nuevo
    await runGitCommand(['remote', 'add', 'origin', repoLink]);

    // 6. Push a GitHub
    await runGitCommand(['push', '-u', 'origin', branchName]);

    print('\n=============================================');
    print('    ¡Proyecto enviado a GitHub exitosamente! ');
    print('=============================================');
  } catch (e) {
    print('\n[X] Ocurrió un error inesperado al ejecutar comandos Git: $e');
    print('Por favor, asegúrate de tener Git instalado y de contar con los permisos necesarios.');
  }
}