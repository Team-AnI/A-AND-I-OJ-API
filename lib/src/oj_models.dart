import 'package:freezed_annotation/freezed_annotation.dart';

part 'oj_models.freezed.dart';
part 'oj_models.g.dart';

@freezed
abstract class TestCase with _$TestCase {
  const factory TestCase({
    required int caseId,
    required List<dynamic> args,
    required List<String> argTypes,
    required dynamic expectedOutput,
    required String expectedOutputType,
  }) = _TestCase;

  factory TestCase.fromJson(Map<String, dynamic> json) =>
      _$TestCaseFromJson(json);
}

@freezed
abstract class ProblemTestCases with _$ProblemTestCases {
  const factory ProblemTestCases({
    required String problemId,
    required List<TestCase> testCases,
    required DateTime updatedAt,
  }) = _ProblemTestCases;

  factory ProblemTestCases.fromJson(Map<String, dynamic> json) =>
      _$ProblemTestCasesFromJson(json);
}

@freezed
abstract class SubmissionTestCase with _$SubmissionTestCase {
  const factory SubmissionTestCase({
    required int caseId,
    required String status,
    required double timeMs,
    required double memoryMb,
    required dynamic output,
    required String? error,
  }) = _SubmissionTestCase;

  factory SubmissionTestCase.fromJson(Map<String, dynamic> json) =>
      _$SubmissionTestCaseFromJson(json);
}

@freezed
abstract class Submission with _$Submission {
  const factory Submission({
    required String submissionId,
    required String submitterId,
    required String submitterPublicCode,
    required String problemId,
    required String language,
    required String code,
    required String status,
    required List<SubmissionTestCase> testCases,
    required DateTime createdAt,
    required DateTime? completedAt,
  }) = _Submission;

  factory Submission.fromJson(Map<String, dynamic> json) =>
      _$SubmissionFromJson(json);
}

@freezed
abstract class SubmissionOptions with _$SubmissionOptions {
  const factory SubmissionOptions({required bool realtimeFeedback}) =
      _SubmissionOptions;

  factory SubmissionOptions.fromJson(Map<String, dynamic> json) =>
      _$SubmissionOptionsFromJson(json);
}

@freezed
abstract class SubmissionCreateRequest with _$SubmissionCreateRequest {
  const factory SubmissionCreateRequest({
    required String publicCode,
    required String problemId,
    required String language,
    required String code,
    required SubmissionOptions options,
  }) = _SubmissionCreateRequest;

  factory SubmissionCreateRequest.fromJson(Map<String, dynamic> json) =>
      _$SubmissionCreateRequestFromJson(json);
}

@freezed
abstract class SubmissionReceipt with _$SubmissionReceipt {
  const factory SubmissionReceipt({
    required String submissionId,
    required String streamUrl,
  }) = _SubmissionReceipt;

  factory SubmissionReceipt.fromJson(Map<String, dynamic> json) =>
      _$SubmissionReceiptFromJson(json);
}

@freezed
abstract class SubmissionCaseResult with _$SubmissionCaseResult {
  const factory SubmissionCaseResult({
    int? caseId,
    String? status,
    double? timeMs,
    double? memoryMb,
    @JsonKey(fromJson: _asNullableString) String? output,
    @JsonKey(fromJson: _asNullableString) String? error,
  }) = _SubmissionCaseResult;

  factory SubmissionCaseResult.fromJson(Map<String, dynamic> json) =>
      _$SubmissionCaseResultFromJson(json);
}

@freezed
abstract class SubmissionResultDetail with _$SubmissionResultDetail {
  const factory SubmissionResultDetail({
    required String submissionId,
    String? problemId,
    String? language,
    required String status,
    @Default(<SubmissionCaseResult>[]) List<SubmissionCaseResult> testCases,
    DateTime? createdAt,
    DateTime? completedAt,
  }) = _SubmissionResultDetail;

  factory SubmissionResultDetail.fromJson(Map<String, dynamic> json) =>
      _$SubmissionResultDetailFromJson(json);
}

String? _asNullableString(Object? value) {
  if (value == null) {
    return null;
  }
  final normalized = value.toString();
  return normalized.isEmpty ? null : normalized;
}
