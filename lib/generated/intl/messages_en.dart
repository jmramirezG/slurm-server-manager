// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(path) => "mounted in ${path}";

  static String m1(quantity, percent, total) =>
      "${quantity} (${percent}) used of ${total}";

  static String m2(address) =>
      "server with address ${address} not found in server list";

  static String m3(hour, minute) =>
      "server has been on for ${hour} h and ${minute} min";

  static String m4(days, hour, minute) =>
      "server has been on for ${days} days, ${hour} h and ${minute} min";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "accept": MessageLookupByLibrary.simpleMessage("accept"),
        "add_new_server":
            MessageLookupByLibrary.simpleMessage("new connection"),
        "address": MessageLookupByLibrary.simpleMessage("address"),
        "architecture": MessageLookupByLibrary.simpleMessage("architecture"),
        "auth_failed":
            MessageLookupByLibrary.simpleMessage("authentication failed"),
        "authenticate_face_finger": MessageLookupByLibrary.simpleMessage(
            "please, verify with your face or your finger"),
        "available": MessageLookupByLibrary.simpleMessage("available"),
        "cancel": MessageLookupByLibrary.simpleMessage("cancel"),
        "comfirm_cancel": MessageLookupByLibrary.simpleMessage(
            "do you really want to cancel the selected job?"),
        "confirm_authentication_method": MessageLookupByLibrary.simpleMessage(
            "confirm authentication method"),
        "connect": MessageLookupByLibrary.simpleMessage("connect"),
        "connecting_to_server": MessageLookupByLibrary.simpleMessage(
            "connecting to the server, please wait"),
        "connection_refused":
            MessageLookupByLibrary.simpleMessage("connection refused"),
        "connections": MessageLookupByLibrary.simpleMessage("connections"),
        "consumed_power":
            MessageLookupByLibrary.simpleMessage("consumed power"),
        "cores": MessageLookupByLibrary.simpleMessage("cores"),
        "could_not_authenticate":
            MessageLookupByLibrary.simpleMessage("could not authenticate"),
        "count_cpu": MessageLookupByLibrary.simpleMessage("core count"),
        "cpu_load": MessageLookupByLibrary.simpleMessage("CPU load"),
        "cpu_model": MessageLookupByLibrary.simpleMessage("CPU model"),
        "delete_dir":
            MessageLookupByLibrary.simpleMessage("delete the directory?"),
        "delete_file": MessageLookupByLibrary.simpleMessage("delete the file?"),
        "directory_name":
            MessageLookupByLibrary.simpleMessage("create new directory"),
        "edit_server": MessageLookupByLibrary.simpleMessage("edit connection"),
        "end_time": MessageLookupByLibrary.simpleMessage("end"),
        "exit": MessageLookupByLibrary.simpleMessage("exit"),
        "file_selected": MessageLookupByLibrary.simpleMessage("file selected"),
        "files": MessageLookupByLibrary.simpleMessage("files"),
        "filesystem": MessageLookupByLibrary.simpleMessage("file system"),
        "forget_server": MessageLookupByLibrary.simpleMessage("forget server"),
        "forget_server_long": MessageLookupByLibrary.simpleMessage(
            "are you sure you want to forget this server?"),
        "free": MessageLookupByLibrary.simpleMessage("free"),
        "free_ram": MessageLookupByLibrary.simpleMessage("free RAM"),
        "gpu_utilization": MessageLookupByLibrary.simpleMessage("gpu usage"),
        "job": MessageLookupByLibrary.simpleMessage("job"),
        "job_info": MessageLookupByLibrary.simpleMessage("job info"),
        "jobid": MessageLookupByLibrary.simpleMessage("job id"),
        "keys": MessageLookupByLibrary.simpleMessage("keys"),
        "list_of_jobs": MessageLookupByLibrary.simpleMessage("list of jobs"),
        "load_avg": MessageLookupByLibrary.simpleMessage("load %"),
        "load_cpu": MessageLookupByLibrary.simpleMessage("CPU %"),
        "load_ram": MessageLookupByLibrary.simpleMessage("ram %"),
        "memory_utilization":
            MessageLookupByLibrary.simpleMessage("memory usage"),
        "menu": MessageLookupByLibrary.simpleMessage("menu"),
        "mounted_in": m0,
        "name": MessageLookupByLibrary.simpleMessage("name"),
        "no": MessageLookupByLibrary.simpleMessage("no"),
        "no_internet": MessageLookupByLibrary.simpleMessage(
            "no internet connection available"),
        "no_jobs_available":
            MessageLookupByLibrary.simpleMessage("no jobs available"),
        "nodes": MessageLookupByLibrary.simpleMessage("nodes"),
        "password": MessageLookupByLibrary.simpleMessage("password"),
        "pause": MessageLookupByLibrary.simpleMessage("pause"),
        "percent_used": m1,
        "port": MessageLookupByLibrary.simpleMessage("port"),
        "product_name": MessageLookupByLibrary.simpleMessage("product name"),
        "remember_server":
            MessageLookupByLibrary.simpleMessage("remember server"),
        "resume": MessageLookupByLibrary.simpleMessage("resume"),
        "save": MessageLookupByLibrary.simpleMessage("save"),
        "select_file": MessageLookupByLibrary.simpleMessage("select file"),
        "server_information":
            MessageLookupByLibrary.simpleMessage("server info"),
        "server_not_found": m2,
        "server_uptime": m3,
        "server_uptime_with_days": m4,
        "shared": MessageLookupByLibrary.simpleMessage("shared"),
        "ssh_console": MessageLookupByLibrary.simpleMessage("SSH console"),
        "start_time": MessageLookupByLibrary.simpleMessage("start"),
        "status": MessageLookupByLibrary.simpleMessage("status"),
        "submit_time": MessageLookupByLibrary.simpleMessage("submit"),
        "superuser_permissions_required": MessageLookupByLibrary.simpleMessage(
            "superuser permissions required"),
        "temperature": MessageLookupByLibrary.simpleMessage("temperature"),
        "threads": MessageLookupByLibrary.simpleMessage("threads"),
        "threads_core":
            MessageLookupByLibrary.simpleMessage("threads per core"),
        "total_memory": MessageLookupByLibrary.simpleMessage("total memory"),
        "unknown_error":
            MessageLookupByLibrary.simpleMessage("unexpected error"),
        "used": MessageLookupByLibrary.simpleMessage("used"),
        "user": MessageLookupByLibrary.simpleMessage("user"),
        "yes": MessageLookupByLibrary.simpleMessage("yes")
      };
}
