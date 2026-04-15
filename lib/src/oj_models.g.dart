// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'oj_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TestCase _$TestCaseFromJson(Map<String, dynamic> json) => _TestCase(
  caseId: (json['caseId'] as num).toInt(),
  args: json['args'] as List<dynamic>,
  argTypes: (json['argTypes'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  expectedOutput: json['expectedOutput'],
  expectedOutputType: json['expectedOutputType'] as String,
);

Map<String, dynamic> _$TestCaseToJson(_TestCase instance) => <String, dynamic>{
  'caseId': instance.caseId,
  'args': instance.args,
  'argTypes': instance.argTypes,
  'expectedOutput': instance.expectedOutput,
  'expectedOutputType': instance.expectedOutputType,
};

_ProblemTestCases _$ProblemTestCasesFromJson(Map<String, dynamic> json) =>
    _ProblemTestCases(
      problemId: json['problemId'] as String,
      testCases: (json['testCases'] as List<dynamic>)
          .map((e) => TestCase.fromJson(e as Map<String, dynamic>))
          .toList(),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ProblemTestCasesToJson(_ProblemTestCases instance) =>
    <String, dynamic>{
      'problemId': instance.problemId,
      'testCases': instance.testCases,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_SubmissionTestCase _$SubmissionTestCaseFromJson(Map<String, dynamic> json) =>
    _SubmissionTestCase(
      caseId: (json['caseId'] as num).toInt(),
      status: json['status'] as String,
      timeMs: (json['timeMs'] as num).toDouble(),
      memoryMb: (json['memoryMb'] as num).toDouble(),
      output: json['output'],
      error: json['error'] as String?,
    );

Map<String, dynamic> _$SubmissionTestCaseToJson(_SubmissionTestCase instance) =>
    <String, dynamic>{
      'caseId': instance.caseId,
      'status': instance.status,
      'timeMs': instance.timeMs,
      'memoryMb': instance.memoryMb,
      'output': instance.output,
      'error': instance.error,
    };

_Submission _$SubmissionFromJson(Map<String, dynamic> json) => _Submission(
  submissionId: json['submissionId'] as String,
  submitterId: json['submitterId'] as String,
  submitterPublicCode: json['submitterPublicCode'] as String,
  problemId: json['problemId'] as String,
  language: json['language'] as String,
  code: json['code'] as String,
  status: json['status'] as String,
  testCases: (json['testCases'] as List<dynamic>)
      .map((e) => SubmissionTestCase.fromJson(e as Map<String, dynamic>))
      .toList(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
);

Map<String, dynamic> _$SubmissionToJson(_Submission instance) =>
    <String, dynamic>{
      'submissionId': instance.submissionId,
      'submitterId': instance.submitterId,
      'submitterPublicCode': instance.submitterPublicCode,
      'problemId': instance.problemId,
      'language': instance.language,
      'code': instance.code,
      'status': instance.status,
      'testCases': instance.testCases,
      'createdAt': instance.createdAt.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
    };

_SubmissionOptions _$SubmissionOptionsFromJson(Map<String, dynamic> json) =>
    _SubmissionOptions(realtimeFeedback: json['realtimeFeedback'] as bool);

Map<String, dynamic> _$SubmissionOptionsToJson(_SubmissionOptions instance) =>
    <String, dynamic>{'realtimeFeedback': instance.realtimeFeedback};

_SubmissionCreateRequest _$SubmissionCreateRequestFromJson(
  Map<String, dynamic> json,
) => _SubmissionCreateRequest(
  publicCode: json['publicCode'] as String,
  problemId: json['problemId'] as String,
  language: json['language'] as String,
  code: json['code'] as String,
  options: SubmissionOptions.fromJson(json['options'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SubmissionCreateRequestToJson(
  _SubmissionCreateRequest instance,
) => <String, dynamic>{
  'publicCode': instance.publicCode,
  'problemId': instance.problemId,
  'language': instance.language,
  'code': instance.code,
  'options': instance.options,
};

_SubmissionReceipt _$SubmissionReceiptFromJson(Map<String, dynamic> json) =>
    _SubmissionReceipt(
      submissionId: json['submissionId'] as String,
      streamUrl: json['streamUrl'] as String,
    );

Map<String, dynamic> _$SubmissionReceiptToJson(_SubmissionReceipt instance) =>
    <String, dynamic>{
      'submissionId': instance.submissionId,
      'streamUrl': instance.streamUrl,
    };

_SubmissionCaseResult _$SubmissionCaseResultFromJson(
  Map<String, dynamic> json,
) => _SubmissionCaseResult(
  caseId: (json['caseId'] as num?)?.toInt(),
  status: json['status'] as String?,
  timeMs: (json['timeMs'] as num?)?.toDouble(),
  memoryMb: (json['memoryMb'] as num?)?.toDouble(),
  output: _asNullableString(json['output']),
  error: _asNullableString(json['error']),
);

Map<String, dynamic> _$SubmissionCaseResultToJson(
  _SubmissionCaseResult instance,
) => <String, dynamic>{
  'caseId': instance.caseId,
  'status': instance.status,
  'timeMs': instance.timeMs,
  'memoryMb': instance.memoryMb,
  'output': instance.output,
  'error': instance.error,
};

_SubmissionResultDetail _$SubmissionResultDetailFromJson(
  Map<String, dynamic> json,
) => _SubmissionResultDetail(
  submissionId: json['submissionId'] as String,
  problemId: json['problemId'] as String?,
  language: json['language'] as String?,
  status: json['status'] as String,
  testCases:
      (json['testCases'] as List<dynamic>?)
          ?.map((e) => SubmissionCaseResult.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <SubmissionCaseResult>[],
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
);

Map<String, dynamic> _$SubmissionResultDetailToJson(
  _SubmissionResultDetail instance,
) => <String, dynamic>{
  'submissionId': instance.submissionId,
  'problemId': instance.problemId,
  'language': instance.language,
  'status': instance.status,
  'testCases': instance.testCases,
  'createdAt': instance.createdAt?.toIso8601String(),
  'completedAt': instance.completedAt?.toIso8601String(),
};
