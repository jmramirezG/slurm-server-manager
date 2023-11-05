// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a es locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'es';

  static String m0(path) => "montado en ${path}";

  static String m1(quantity, percent, total) =>
      "${quantity} (${percent}) usado de ${total}";

  static String m2(address) =>
      "el servidor con dirección ${address} no ha sido encontrado en la lista de servidores";

  static String m3(hour, minute) =>
      "el servidor ha estado encendido durante ${hour} h y ${minute} min";

  static String m4(days, hour, minute) =>
      "el servidor ha estado encendido durante ${days} días, ${hour} h y ${minute} min";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "accept": MessageLookupByLibrary.simpleMessage("aceptar"),
        "add_new_server":
            MessageLookupByLibrary.simpleMessage("nueva conexión"),
        "address": MessageLookupByLibrary.simpleMessage("dirección"),
        "architecture": MessageLookupByLibrary.simpleMessage("arquitectura"),
        "auth_failed":
            MessageLookupByLibrary.simpleMessage("fallo de autenticación"),
        "authenticate_face_finger": MessageLookupByLibrary.simpleMessage(
            "por favor, autentica con tu huella o tu cara"),
        "available": MessageLookupByLibrary.simpleMessage("disponible"),
        "cancel": MessageLookupByLibrary.simpleMessage("cancelar"),
        "comfirm_cancel": MessageLookupByLibrary.simpleMessage(
            "quieres cancelar el trabajo seleccionado?"),
        "confirm_authentication_method": MessageLookupByLibrary.simpleMessage(
            "confirma el método de autenticación"),
        "connect": MessageLookupByLibrary.simpleMessage("conectar"),
        "connecting_to_server": MessageLookupByLibrary.simpleMessage(
            "conectando al servidor, por favor espere"),
        "connection_refused":
            MessageLookupByLibrary.simpleMessage("conexión rechazada"),
        "connections": MessageLookupByLibrary.simpleMessage("conexiones"),
        "consumed_power":
            MessageLookupByLibrary.simpleMessage("potencia consumida"),
        "cores": MessageLookupByLibrary.simpleMessage("núcleos"),
        "could_not_authenticate": MessageLookupByLibrary.simpleMessage(
            "no se pudo verificar la identidad"),
        "count_cpu": MessageLookupByLibrary.simpleMessage("número de núcleos"),
        "cpu_load": MessageLookupByLibrary.simpleMessage("carga CPU"),
        "cpu_model": MessageLookupByLibrary.simpleMessage("modelo de CPU"),
        "delete_dir":
            MessageLookupByLibrary.simpleMessage("borrar el directorio?"),
        "delete_file":
            MessageLookupByLibrary.simpleMessage("borrar el archivo?"),
        "directory_name":
            MessageLookupByLibrary.simpleMessage("crear nueva carpeta"),
        "edit_server": MessageLookupByLibrary.simpleMessage("editar conexión"),
        "end_time": MessageLookupByLibrary.simpleMessage("fin"),
        "exit": MessageLookupByLibrary.simpleMessage("salir"),
        "file_selected":
            MessageLookupByLibrary.simpleMessage("archivo seleccionado"),
        "files": MessageLookupByLibrary.simpleMessage("archivos"),
        "filesystem":
            MessageLookupByLibrary.simpleMessage("sistema de archivos"),
        "forget_server":
            MessageLookupByLibrary.simpleMessage("olvidar servidor"),
        "forget_server_long": MessageLookupByLibrary.simpleMessage(
            "estás seguro de que quieres olvidar este servidor?"),
        "free": MessageLookupByLibrary.simpleMessage("libre"),
        "free_ram": MessageLookupByLibrary.simpleMessage("RAM disponible"),
        "gpu_utilization": MessageLookupByLibrary.simpleMessage("uso de gpu"),
        "job": MessageLookupByLibrary.simpleMessage("trabajo"),
        "job_info":
            MessageLookupByLibrary.simpleMessage("información del trabajo"),
        "jobid": MessageLookupByLibrary.simpleMessage("id del trabajo"),
        "keys": MessageLookupByLibrary.simpleMessage("claves"),
        "list_of_jobs":
            MessageLookupByLibrary.simpleMessage("lista de trabajos"),
        "load_avg": MessageLookupByLibrary.simpleMessage("% carga"),
        "load_cpu": MessageLookupByLibrary.simpleMessage("% CPU"),
        "load_ram": MessageLookupByLibrary.simpleMessage("% ram"),
        "memory_utilization":
            MessageLookupByLibrary.simpleMessage("uso de memoria"),
        "menu": MessageLookupByLibrary.simpleMessage("menú"),
        "mounted_in": m0,
        "name": MessageLookupByLibrary.simpleMessage("nombre"),
        "no": MessageLookupByLibrary.simpleMessage("no"),
        "no_internet": MessageLookupByLibrary.simpleMessage(
            "no hay conexión a internet disponible"),
        "no_jobs_available":
            MessageLookupByLibrary.simpleMessage("no hay trabajos disponibles"),
        "nodes": MessageLookupByLibrary.simpleMessage("nodos"),
        "password": MessageLookupByLibrary.simpleMessage("contraseña"),
        "pause": MessageLookupByLibrary.simpleMessage("pausar"),
        "percent_used": m1,
        "port": MessageLookupByLibrary.simpleMessage("puerto"),
        "product_name":
            MessageLookupByLibrary.simpleMessage("nombre de producto"),
        "remember_server":
            MessageLookupByLibrary.simpleMessage("recordar servidor"),
        "resume": MessageLookupByLibrary.simpleMessage("reanudar"),
        "save": MessageLookupByLibrary.simpleMessage("guardar"),
        "select_file":
            MessageLookupByLibrary.simpleMessage("seleccionar archivo"),
        "server_information":
            MessageLookupByLibrary.simpleMessage("info servidor"),
        "server_not_found": m2,
        "server_uptime": m3,
        "server_uptime_with_days": m4,
        "shared": MessageLookupByLibrary.simpleMessage("compartido"),
        "ssh_console": MessageLookupByLibrary.simpleMessage("consola SSH"),
        "start_time": MessageLookupByLibrary.simpleMessage("inicio"),
        "status": MessageLookupByLibrary.simpleMessage("estado"),
        "submit_time": MessageLookupByLibrary.simpleMessage("entrada"),
        "superuser_permissions_required": MessageLookupByLibrary.simpleMessage(
            "permisos de superusuario requeridos"),
        "temperature": MessageLookupByLibrary.simpleMessage("temperatura"),
        "threads": MessageLookupByLibrary.simpleMessage("hilos"),
        "threads_core":
            MessageLookupByLibrary.simpleMessage("hilos por núcleo"),
        "total_memory": MessageLookupByLibrary.simpleMessage("memoria total"),
        "unknown_error":
            MessageLookupByLibrary.simpleMessage("fallo inesperado"),
        "used": MessageLookupByLibrary.simpleMessage("usado"),
        "user": MessageLookupByLibrary.simpleMessage("usuario"),
        "yes": MessageLookupByLibrary.simpleMessage("si")
      };
}
