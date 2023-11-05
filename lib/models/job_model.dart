// ignore_for_file: constant_identifier_names

enum JobStatus {
  BOOT_FAIL,
  CANCELLED,
  COMPLETED,
  CONFIGURING,
  COMPLETING,
  DEADLINE,
  FAILED,
  NODE_FAIL,
  OUT_OF_MEMORY,
  PENDING,
  PREEMPTED,
  RUNNING,
  RESV_DEL_HOLD,
  REQUEUE_FED,
  REQUEUE_HOLD,
  REQUEUED,
  RESIZING,
  REVOKED,
  SIGNALING,
  SPECIAL_EXIT,
  STAGE_OUT,
  STOPPED,
  SUSPENDED,
  TIMEOUT,
  UNKNOWN
}

class JobStatusExtension {
  static JobStatus fromString(String value) {
    for (JobStatus thisJobStatus in JobStatus.values) {
      if (thisJobStatus.name == value) {
        return thisJobStatus;
      }
    }
    return JobStatus.UNKNOWN;
  }
}

class Job {
  int id;

  String name;

  String userId;

  DateTime submitTime;

  DateTime startTime;

  DateTime endTime;

  JobStatus status;

  Job(
    this.id,
    this.name,
    this.userId,
    this.submitTime,
    this.startTime,
    this.endTime,
    this.status,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Job && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  static Job fromMap(Map<String, dynamic> serverdata) => Job(
        serverdata["id"],
        serverdata["name"],
        serverdata["userId"],
        serverdata["submitTime"],
        serverdata["startTime"],
        serverdata["endTime"],
        serverdata["status"],
      );
}
