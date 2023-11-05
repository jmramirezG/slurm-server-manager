// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `connections`
  String get connections {
    return Intl.message(
      'connections',
      name: 'connections',
      desc: '',
      args: [],
    );
  }

  /// `files`
  String get files {
    return Intl.message(
      'files',
      name: 'files',
      desc: '',
      args: [],
    );
  }

  /// `nodes`
  String get nodes {
    return Intl.message(
      'nodes',
      name: 'nodes',
      desc: '',
      args: [],
    );
  }

  /// `server info`
  String get server_information {
    return Intl.message(
      'server info',
      name: 'server_information',
      desc: '',
      args: [],
    );
  }

  /// `new connection`
  String get add_new_server {
    return Intl.message(
      'new connection',
      name: 'add_new_server',
      desc: '',
      args: [],
    );
  }

  /// `cancel`
  String get cancel {
    return Intl.message(
      'cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `connect`
  String get connect {
    return Intl.message(
      'connect',
      name: 'connect',
      desc: '',
      args: [],
    );
  }

  /// `address`
  String get address {
    return Intl.message(
      'address',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  /// `port`
  String get port {
    return Intl.message(
      'port',
      name: 'port',
      desc: '',
      args: [],
    );
  }

  /// `user`
  String get user {
    return Intl.message(
      'user',
      name: 'user',
      desc: '',
      args: [],
    );
  }

  /// `password`
  String get password {
    return Intl.message(
      'password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `keys`
  String get keys {
    return Intl.message(
      'keys',
      name: 'keys',
      desc: '',
      args: [],
    );
  }

  /// `select file`
  String get select_file {
    return Intl.message(
      'select file',
      name: 'select_file',
      desc: '',
      args: [],
    );
  }

  /// `file selected`
  String get file_selected {
    return Intl.message(
      'file selected',
      name: 'file_selected',
      desc: '',
      args: [],
    );
  }

  /// `please, verify with your face or your finger`
  String get authenticate_face_finger {
    return Intl.message(
      'please, verify with your face or your finger',
      name: 'authenticate_face_finger',
      desc: '',
      args: [],
    );
  }

  /// `could not authenticate`
  String get could_not_authenticate {
    return Intl.message(
      'could not authenticate',
      name: 'could_not_authenticate',
      desc: '',
      args: [],
    );
  }

  /// `confirm authentication method`
  String get confirm_authentication_method {
    return Intl.message(
      'confirm authentication method',
      name: 'confirm_authentication_method',
      desc: '',
      args: [],
    );
  }

  /// `remember server`
  String get remember_server {
    return Intl.message(
      'remember server',
      name: 'remember_server',
      desc: '',
      args: [],
    );
  }

  /// `connecting to the server, please wait`
  String get connecting_to_server {
    return Intl.message(
      'connecting to the server, please wait',
      name: 'connecting_to_server',
      desc: '',
      args: [],
    );
  }

  /// `save`
  String get save {
    return Intl.message(
      'save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `forget server`
  String get forget_server {
    return Intl.message(
      'forget server',
      name: 'forget_server',
      desc: '',
      args: [],
    );
  }

  /// `are you sure you want to forget this server?`
  String get forget_server_long {
    return Intl.message(
      'are you sure you want to forget this server?',
      name: 'forget_server_long',
      desc: '',
      args: [],
    );
  }

  /// `edit connection`
  String get edit_server {
    return Intl.message(
      'edit connection',
      name: 'edit_server',
      desc: '',
      args: [],
    );
  }

  /// `server with address {address} not found in server list`
  String server_not_found(String address) {
    return Intl.message(
      'server with address $address not found in server list',
      name: 'server_not_found',
      desc: 'Specifies the server has not been found in known servers.',
      args: [address],
    );
  }

  /// `menu`
  String get menu {
    return Intl.message(
      'menu',
      name: 'menu',
      desc: '',
      args: [],
    );
  }

  /// `SSH console`
  String get ssh_console {
    return Intl.message(
      'SSH console',
      name: 'ssh_console',
      desc: '',
      args: [],
    );
  }

  /// `load %`
  String get load_avg {
    return Intl.message(
      'load %',
      name: 'load_avg',
      desc: '',
      args: [],
    );
  }

  /// `ram %`
  String get load_ram {
    return Intl.message(
      'ram %',
      name: 'load_ram',
      desc: '',
      args: [],
    );
  }

  /// `CPU %`
  String get load_cpu {
    return Intl.message(
      'CPU %',
      name: 'load_cpu',
      desc: '',
      args: [],
    );
  }

  /// `server has been on for {hour} h and {minute} min`
  String server_uptime(String hour, String minute) {
    return Intl.message(
      'server has been on for $hour h and $minute min',
      name: 'server_uptime',
      desc: 'Specifies the server uptime.',
      args: [hour, minute],
    );
  }

  /// `server has been on for {days} days, {hour} h and {minute} min`
  String server_uptime_with_days(String days, String hour, String minute) {
    return Intl.message(
      'server has been on for $days days, $hour h and $minute min',
      name: 'server_uptime_with_days',
      desc: 'Specifies the server uptime with days.',
      args: [days, hour, minute],
    );
  }

  /// `job info`
  String get job_info {
    return Intl.message(
      'job info',
      name: 'job_info',
      desc: '',
      args: [],
    );
  }

  /// `pause`
  String get pause {
    return Intl.message(
      'pause',
      name: 'pause',
      desc: '',
      args: [],
    );
  }

  /// `resume`
  String get resume {
    return Intl.message(
      'resume',
      name: 'resume',
      desc: '',
      args: [],
    );
  }

  /// `connection refused`
  String get connection_refused {
    return Intl.message(
      'connection refused',
      name: 'connection_refused',
      desc: '',
      args: [],
    );
  }

  /// `accept`
  String get accept {
    return Intl.message(
      'accept',
      name: 'accept',
      desc: '',
      args: [],
    );
  }

  /// `authentication failed`
  String get auth_failed {
    return Intl.message(
      'authentication failed',
      name: 'auth_failed',
      desc: '',
      args: [],
    );
  }

  /// `unexpected error`
  String get unknown_error {
    return Intl.message(
      'unexpected error',
      name: 'unknown_error',
      desc: '',
      args: [],
    );
  }

  /// `list of jobs`
  String get list_of_jobs {
    return Intl.message(
      'list of jobs',
      name: 'list_of_jobs',
      desc: '',
      args: [],
    );
  }

  /// `no jobs available`
  String get no_jobs_available {
    return Intl.message(
      'no jobs available',
      name: 'no_jobs_available',
      desc: '',
      args: [],
    );
  }

  /// `job`
  String get job {
    return Intl.message(
      'job',
      name: 'job',
      desc: '',
      args: [],
    );
  }

  /// `name`
  String get name {
    return Intl.message(
      'name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `job id`
  String get jobid {
    return Intl.message(
      'job id',
      name: 'jobid',
      desc: '',
      args: [],
    );
  }

  /// `exit`
  String get exit {
    return Intl.message(
      'exit',
      name: 'exit',
      desc: '',
      args: [],
    );
  }

  /// `status`
  String get status {
    return Intl.message(
      'status',
      name: 'status',
      desc: '',
      args: [],
    );
  }

  /// `submit`
  String get submit_time {
    return Intl.message(
      'submit',
      name: 'submit_time',
      desc: '',
      args: [],
    );
  }

  /// `start`
  String get start_time {
    return Intl.message(
      'start',
      name: 'start_time',
      desc: '',
      args: [],
    );
  }

  /// `end`
  String get end_time {
    return Intl.message(
      'end',
      name: 'end_time',
      desc: '',
      args: [],
    );
  }

  /// `do you really want to cancel the selected job?`
  String get comfirm_cancel {
    return Intl.message(
      'do you really want to cancel the selected job?',
      name: 'comfirm_cancel',
      desc: '',
      args: [],
    );
  }

  /// `yes`
  String get yes {
    return Intl.message(
      'yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `no`
  String get no {
    return Intl.message(
      'no',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `create new directory`
  String get directory_name {
    return Intl.message(
      'create new directory',
      name: 'directory_name',
      desc: '',
      args: [],
    );
  }

  /// `delete the directory?`
  String get delete_dir {
    return Intl.message(
      'delete the directory?',
      name: 'delete_dir',
      desc: '',
      args: [],
    );
  }

  /// `delete the file?`
  String get delete_file {
    return Intl.message(
      'delete the file?',
      name: 'delete_file',
      desc: '',
      args: [],
    );
  }

  /// `core count`
  String get count_cpu {
    return Intl.message(
      'core count',
      name: 'count_cpu',
      desc: '',
      args: [],
    );
  }

  /// `CPU model`
  String get cpu_model {
    return Intl.message(
      'CPU model',
      name: 'cpu_model',
      desc: '',
      args: [],
    );
  }

  /// `file system`
  String get filesystem {
    return Intl.message(
      'file system',
      name: 'filesystem',
      desc: '',
      args: [],
    );
  }

  /// `architecture`
  String get architecture {
    return Intl.message(
      'architecture',
      name: 'architecture',
      desc: '',
      args: [],
    );
  }

  /// `threads per core`
  String get threads_core {
    return Intl.message(
      'threads per core',
      name: 'threads_core',
      desc: '',
      args: [],
    );
  }

  /// `threads`
  String get threads {
    return Intl.message(
      'threads',
      name: 'threads',
      desc: '',
      args: [],
    );
  }

  /// `cores`
  String get cores {
    return Intl.message(
      'cores',
      name: 'cores',
      desc: '',
      args: [],
    );
  }

  /// `free RAM`
  String get free_ram {
    return Intl.message(
      'free RAM',
      name: 'free_ram',
      desc: '',
      args: [],
    );
  }

  /// `used`
  String get used {
    return Intl.message(
      'used',
      name: 'used',
      desc: '',
      args: [],
    );
  }

  /// `free`
  String get free {
    return Intl.message(
      'free',
      name: 'free',
      desc: '',
      args: [],
    );
  }

  /// `shared`
  String get shared {
    return Intl.message(
      'shared',
      name: 'shared',
      desc: '',
      args: [],
    );
  }

  /// `available`
  String get available {
    return Intl.message(
      'available',
      name: 'available',
      desc: '',
      args: [],
    );
  }

  /// `CPU load`
  String get cpu_load {
    return Intl.message(
      'CPU load',
      name: 'cpu_load',
      desc: '',
      args: [],
    );
  }

  /// `product name`
  String get product_name {
    return Intl.message(
      'product name',
      name: 'product_name',
      desc: '',
      args: [],
    );
  }

  /// `total memory`
  String get total_memory {
    return Intl.message(
      'total memory',
      name: 'total_memory',
      desc: '',
      args: [],
    );
  }

  /// `gpu usage`
  String get gpu_utilization {
    return Intl.message(
      'gpu usage',
      name: 'gpu_utilization',
      desc: '',
      args: [],
    );
  }

  /// `memory usage`
  String get memory_utilization {
    return Intl.message(
      'memory usage',
      name: 'memory_utilization',
      desc: '',
      args: [],
    );
  }

  /// `temperature`
  String get temperature {
    return Intl.message(
      'temperature',
      name: 'temperature',
      desc: '',
      args: [],
    );
  }

  /// `consumed power`
  String get consumed_power {
    return Intl.message(
      'consumed power',
      name: 'consumed_power',
      desc: '',
      args: [],
    );
  }

  /// `no internet connection available`
  String get no_internet {
    return Intl.message(
      'no internet connection available',
      name: 'no_internet',
      desc: '',
      args: [],
    );
  }

  /// `superuser permissions required`
  String get superuser_permissions_required {
    return Intl.message(
      'superuser permissions required',
      name: 'superuser_permissions_required',
      desc: '',
      args: [],
    );
  }

  /// `mounted in {path}`
  String mounted_in(String path) {
    return Intl.message(
      'mounted in $path',
      name: 'mounted_in',
      desc: 'Specifies where a filesystem is mounted.',
      args: [path],
    );
  }

  /// `{quantity} ({percent}) used of {total}`
  String percent_used(String quantity, String percent, String total) {
    return Intl.message(
      '$quantity ($percent) used of $total',
      name: 'percent_used',
      desc: 'Specifies the amount of used memory of a filesystem.',
      args: [quantity, percent, total],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'es'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
