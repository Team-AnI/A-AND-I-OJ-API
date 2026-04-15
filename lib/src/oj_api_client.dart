import 'dart:convert';

import 'package:aandi_api_protocol/aandi_api_protocol.dart';
import 'package:dio/dio.dart';

import 'oj_api_exceptions.dart';
import 'oj_models.dart';

class OjApiClient {
  OjApiClient({required this.baseUrl, Dio? dio}) : dio = dio ?? Dio() {
    ensureAandiProtocolInterceptor(this.dio);
  }

  static const _testCasesPath = '/v2/admin/testcases';
  static const _adminSubmissionsPath = '/v2/admin/submissions';
  static const _submissionsPath = '/v2/submissions';
  static const _problemsPath = '/v2/problems';

  final String baseUrl;
  final Dio dio;

  Future<SubmissionReceipt> createSubmissionV2({
    required String accessToken,
    required SubmissionCreateRequest request,
  }) async {
    final response = await _requestJson(
      method: 'POST',
      accessToken: accessToken,
      path: _submissionsPath,
      data: request.toJson(),
    );

    final mapData = _readMapData(
      response.body,
      statusCode: response.statusCode,
    );
    return SubmissionReceipt.fromJson(mapData);
  }

  Future<SubmissionResultDetail> getSubmissionResultV2({
    required String accessToken,
    required String submissionId,
  }) async {
    final response = await _requestJson(
      method: 'GET',
      accessToken: accessToken,
      path: '$_submissionsPath/$submissionId',
    );

    final mapData = _readMapData(
      response.body,
      statusCode: response.statusCode,
    );
    return SubmissionResultDetail.fromJson(mapData);
  }

  Future<List<SubmissionResultDetail>> getMyProblemSubmissionsV2({
    required String accessToken,
    required String problemId,
  }) async {
    final response = await _requestJson(
      method: 'GET',
      accessToken: accessToken,
      path: '$_problemsPath/$problemId/submissions/me',
    );

    final listData = _readListData(
      response.body,
      statusCode: response.statusCode,
    );
    return listData
        .whereType<Map<String, dynamic>>()
        .map(SubmissionResultDetail.fromJson)
        .toList();
  }

  Future<List<ProblemTestCases>> getTestCases({
    required String accessToken,
  }) async {
    final response = await _requestJson(
      method: 'GET',
      accessToken: accessToken,
      path: _testCasesPath,
    );

    final listData = _readListData(
      response.body,
      statusCode: response.statusCode,
    );
    return listData
        .whereType<Map<String, dynamic>>()
        .map(ProblemTestCases.fromJson)
        .toList();
  }

  Future<List<Submission>> getSubmissions({required String accessToken}) async {
    final response = await _requestJson(
      method: 'GET',
      accessToken: accessToken,
      path: _adminSubmissionsPath,
    );

    final listData = _readListData(
      response.body,
      statusCode: response.statusCode,
    );
    return listData
        .whereType<Map<String, dynamic>>()
        .map(Submission.fromJson)
        .toList();
  }

  Future<({int statusCode, Map<String, dynamic> body})> _requestJson({
    required String method,
    required String accessToken,
    required String path,
    Object? data,
    bool allowEmptySuccessBody = false,
  }) async {
    final response = await dio.requestUri<dynamic>(
      Uri.parse('$baseUrl$path'),
      data: data,
      options: Options(
        method: method,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Accept': 'application/json',
          if (data != null) 'Content-Type': 'application/json',
        },
        responseType: ResponseType.plain,
        validateStatus: (_) => true,
      ),
    );

    final statusCode = response.statusCode ?? 0;
    final decoded = _decodeResponseMap(
      response.data,
      statusCode: statusCode,
      allowEmptySuccessBody: allowEmptySuccessBody,
    );
    if (decoded == null) {
      return (statusCode: statusCode, body: const <String, dynamic>{});
    }

    _throwIfRequestFailed(statusCode: statusCode, decoded: decoded);
    return (statusCode: statusCode, body: decoded);
  }

  List _readListData(Map<String, dynamic> decoded, {required int statusCode}) {
    final data = decoded['data'];
    if (data is! List) {
      throw OjApiException(
        'Response data is missing',
        statusCode: statusCode,
      );
    }
    return data;
  }

  Map<String, dynamic> _readMapData(
    Map<String, dynamic> decoded, {
    required int statusCode,
  }) {
    final data = decoded['data'];
    if (data is! Map<String, dynamic>) {
      throw OjApiException(
        'Response data is missing',
        statusCode: statusCode,
      );
    }
    return data;
  }

  Map<String, dynamic>? _decodeResponseMap(
    dynamic responseData, {
    required int statusCode,
    required bool allowEmptySuccessBody,
  }) {
    if (_isEmptyBody(responseData)) {
      if (allowEmptySuccessBody && _isSuccessfulStatus(statusCode)) {
        return null;
      }
      throw OjApiException('요청에 실패했습니다.', statusCode: statusCode);
    }

    final decoded = switch (responseData) {
      Map<String, dynamic> value => value,
      Map value => value.map((key, value) => MapEntry(key.toString(), value)),
      String value => _decodeJsonString(value, statusCode: statusCode),
      _ => throw OjApiException(
        'Invalid response shape',
        statusCode: statusCode,
      ),
    };

    return decoded;
  }

  Map<String, dynamic> _decodeJsonString(
    String value, {
    required int statusCode,
  }) {
    try {
      final decoded = jsonDecode(value);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) {
        return decoded.map((key, value) => MapEntry(key.toString(), value));
      }
      throw OjApiException(
        'Invalid response shape',
        statusCode: statusCode,
      );
    } on FormatException {
      throw OjApiException(
        'Invalid response shape',
        statusCode: statusCode,
      );
    }
  }

  bool _isEmptyBody(dynamic responseData) {
    return responseData == null ||
        (responseData is String && responseData.trim().isEmpty);
  }

  bool _isSuccessfulStatus(int statusCode) {
    return statusCode >= 200 && statusCode < 300;
  }

  void _throwIfRequestFailed({
    required int statusCode,
    required Map<String, dynamic> decoded,
  }) {
    final success = decoded['success'] == true;
    final error = decoded['error'];
    if (_isSuccessfulStatus(statusCode) && success) {
      return;
    }

    final message = error is Map<String, dynamic>
        ? (error['message']?.toString() ?? '요청에 실패했습니다.')
        : '요청에 실패했습니다.';
    final code = error is Map<String, dynamic>
        ? error['code']?.toString()
        : null;
    final alert = error is Map<String, dynamic>
        ? error['alert']?.toString()
        : null;
    throw OjApiException(
      message,
      statusCode: statusCode,
      code: code,
      alert: alert,
    );
  }
}
