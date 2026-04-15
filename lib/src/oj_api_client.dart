import 'dart:convert';

import 'package:aandi_api_endpoints/aandi_api_endpoints.dart';
import 'package:aandi_api_protocol/aandi_api_protocol.dart';
import 'package:dio/dio.dart';

import 'oj_api_exceptions.dart';
import 'oj_models.dart';

/// 제출 접수 응답 모델이다.
final class OjSubmissionReceipt {
  const OjSubmissionReceipt({
    required this.submissionId,
    required this.streamUrl,
  });

  factory OjSubmissionReceipt.fromJson(Map<String, dynamic> json) {
    return OjSubmissionReceipt(
      submissionId: json['submissionId']?.toString() ?? '',
      streamUrl: json['streamUrl']?.toString() ?? '',
    );
  }

  /// JSON 형태로 변환한다.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'submissionId': submissionId,
      'streamUrl': streamUrl,
    };
  }

  final String submissionId;
  final String streamUrl;
}

class OjApiClient {
  OjApiClient({required this.baseUrl, Dio? dio}) : dio = dio ?? Dio() {
    ensureAandiProtocolInterceptor(this.dio);
  }

  final String baseUrl;
  final Dio dio;

  Future<List<ProblemTestCases>> getTestCases({
    required String accessToken,
  }) async {
    try {
      final response = await dio.get<dynamic>(
        AandiApiUrlResolver.resolve(
          baseUrl,
          AandiApiEndpointTemplate.adminTestCasesV2,
        ),
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Accept': 'application/json',
          },
        ),
      );

      final data = response.data;

      // Handle both direct list and wrapped data as seen in other modules
      if (data is List) {
        return data
            .map((e) => ProblemTestCases.fromJson(e as Map<String, dynamic>))
            .toList();
      } else if (data is Map<String, dynamic> && data['data'] is List) {
        return (data['data'] as List)
            .map((e) => ProblemTestCases.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      throw OjApiException('Unexpected response format for test cases');
    } on DioException catch (e) {
      final error = _extractError(e.response?.data);
      throw OjApiException(
        error?.message ??
            e.message ??
            'An error occurred while fetching test cases',
        statusCode: e.response?.statusCode,
        code: error?.code,
        alert: error?.alert,
      );
    } catch (e) {
      throw OjApiException(e.toString());
    }
  }

  Future<List<Submission>> getSubmissions({required String accessToken}) async {
    try {
      final response = await dio.get<dynamic>(
        AandiApiUrlResolver.resolve(
          baseUrl,
          AandiApiEndpointTemplate.adminSubmissionsV2,
        ),
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Accept': 'application/json',
          },
        ),
      );

      final data = response.data;

      // Handle both direct list and wrapped data as seen in other modules
      if (data is List) {
        return data
            .map((e) => Submission.fromJson(e as Map<String, dynamic>))
            .toList();
      } else if (data is Map<String, dynamic> && data['data'] is List) {
        return (data['data'] as List)
            .map((e) => Submission.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      throw OjApiException('Unexpected response format for submissions');
    } on DioException catch (e) {
      final error = _extractError(e.response?.data);
      throw OjApiException(
        error?.message ??
            e.message ??
            'An error occurred while fetching submissions',
        statusCode: e.response?.statusCode,
        code: error?.code,
        alert: error?.alert,
      );
    } catch (e) {
      throw OjApiException(e.toString());
    }
  }

  /// 코드를 제출하고 접수 정보를 반환한다.
  Future<OjSubmissionReceipt> createSubmission({
    required String accessToken,
    required Map<String, dynamic> request,
  }) async {
    final response = await dio.requestUri<dynamic>(
      Uri.parse(
        AandiApiUrlResolver.resolve(
            baseUrl, AandiApiEndpointTemplate.submissions),
      ),
      data: request,
      options: Options(
        method: 'POST',
        headers: <String, String>{
          'Authorization': 'Bearer $accessToken',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        responseType: ResponseType.plain,
        validateStatus: (_) => true,
      ),
    );

    final payload = _extractMapPayload(
      response.data,
      statusCode: response.statusCode ?? 0,
    );
    return OjSubmissionReceipt.fromJson(payload);
  }

  /// 제출 최종 결과를 조회한다.
  Future<Submission> getSubmissionResult({
    required String accessToken,
    required String submissionId,
  }) async {
    final response = await dio.requestUri<dynamic>(
      Uri.parse(
        AandiApiUrlResolver.resolve(
          baseUrl,
          AandiApiEndpointPath.submissionById(submissionId),
        ),
      ),
      options: Options(
        method: 'GET',
        headers: <String, String>{
          'Authorization': 'Bearer $accessToken',
          'Accept': 'application/json',
        },
        responseType: ResponseType.plain,
        validateStatus: (_) => true,
      ),
    );

    final payload = _extractMapPayload(
      response.data,
      statusCode: response.statusCode ?? 0,
    );
    return Submission.fromJson(payload);
  }

  /// 특정 문제에 대한 내 제출 이력을 조회한다.
  Future<List<Submission>> getMyProblemSubmissions({
    required String accessToken,
    required String problemId,
  }) async {
    final response = await dio.requestUri<dynamic>(
      Uri.parse(
        AandiApiUrlResolver.resolve(
          baseUrl,
          AandiApiEndpointPath.myProblemSubmissions(problemId),
        ),
      ),
      options: Options(
        method: 'GET',
        headers: <String, String>{
          'Authorization': 'Bearer $accessToken',
          'Accept': 'application/json',
        },
        responseType: ResponseType.plain,
        validateStatus: (_) => true,
      ),
    );

    final payload = _extractListPayload(
      response.data,
      statusCode: response.statusCode ?? 0,
    );
    return payload.map(Submission.fromJson).toList(growable: false);
  }

  _ApiError? _extractError(dynamic responseData) {
    if (responseData is! Map) {
      return null;
    }

    final error = responseData['error'];
    if (error is Map) {
      return _ApiError(
        message: error['message']?.toString(),
        code: error['code']?.toString(),
        alert: error['alert']?.toString(),
      );
    }

    return _ApiError(
      message: responseData['message']?.toString(),
      code: responseData['code']?.toString(),
      alert: responseData['alert']?.toString(),
    );
  }
}

final class _ApiError {
  const _ApiError({this.message, this.code, this.alert});

  final String? message;
  final String? code;
  final String? alert;
}

Map<String, dynamic> _extractMapPayload(
  dynamic responseData, {
  required int statusCode,
}) {
  final decoded = _decodeResponseValue(responseData, statusCode: statusCode);
  if (decoded is! Map<String, dynamic>) {
    throw OjApiException('Invalid response shape', statusCode: statusCode);
  }

  _throwIfRequestFailed(decoded: decoded, statusCode: statusCode);

  final directData = decoded['data'];
  if (directData is Map<String, dynamic>) {
    return directData;
  }
  if (directData is Map) {
    return directData.map((key, value) => MapEntry(key.toString(), value));
  }

  if (_looksLikeSubmissionPayload(decoded) ||
      _looksLikeReceiptPayload(decoded)) {
    return decoded;
  }

  final nestedCandidates = <Object?>[
    decoded['submission'],
    decoded['result'],
    decoded['item'],
  ];

  for (final candidate in nestedCandidates) {
    if (candidate is Map<String, dynamic>) {
      return candidate;
    }
    if (candidate is Map) {
      return candidate.map((key, value) => MapEntry(key.toString(), value));
    }
  }

  throw OjApiException(
    'Invalid response shape',
    statusCode: statusCode,
  );
}

List<Map<String, dynamic>> _extractListPayload(
  dynamic responseData, {
  required int statusCode,
}) {
  final decoded = _decodeResponseValue(responseData, statusCode: statusCode);
  if (decoded is List) {
    return _extractList(decoded);
  }
  if (decoded is! Map<String, dynamic>) {
    throw OjApiException('Invalid response shape', statusCode: statusCode);
  }

  _throwIfRequestFailed(decoded: decoded, statusCode: statusCode);

  final candidates = <Object?>[
    decoded['data'],
    decoded['submissions'],
    decoded['items'],
    decoded['results'],
  ];

  for (final candidate in candidates) {
    final extracted = _extractListOrNull(candidate);
    if (extracted != null) {
      return extracted;
    }
  }

  final data = decoded['data'];
  if (data is Map<String, dynamic>) {
    for (final candidate in <Object?>[
      data['submissions'],
      data['items'],
      data['results'],
      data['content'],
    ]) {
      final extracted = _extractListOrNull(candidate);
      if (extracted != null) {
        return extracted;
      }
    }
  }

  throw OjApiException(
    'Invalid response shape',
    statusCode: statusCode,
  );
}

List<Map<String, dynamic>> _extractList(Object? raw) {
  if (raw is! List) {
    return const <Map<String, dynamic>>[];
  }

  return raw
      .whereType<Map>()
      .map((item) => item.map((key, value) => MapEntry(key.toString(), value)))
      .toList(growable: false);
}

List<Map<String, dynamic>>? _extractListOrNull(Object? raw) {
  if (raw is! List) {
    return null;
  }

  return _extractList(raw);
}

Object _decodeResponseValue(dynamic responseData, {required int statusCode}) {
  if (responseData is Map<String, dynamic>) {
    return responseData;
  }

  if (responseData is Map) {
    return responseData.map((key, value) => MapEntry(key.toString(), value));
  }

  if (responseData is List) {
    return responseData;
  }

  if (responseData is String) {
    try {
      if (responseData.trim().isEmpty) {
        throw OjApiException('Invalid response shape', statusCode: statusCode);
      }

      return _decodeJsonString(responseData, statusCode: statusCode);
    } on OjApiException {
      rethrow;
    } catch (_) {
      throw OjApiException('Invalid response shape', statusCode: statusCode);
    }
  }

  throw OjApiException('Invalid response shape', statusCode: statusCode);
}

Object _decodeJsonString(String value, {required int statusCode}) {
  final dynamic json = jsonDecode(value);
  if (json is Map<String, dynamic>) {
    return json;
  }
  if (json is Map) {
    return json.map((key, value) => MapEntry(key.toString(), value));
  }
  if (json is List) {
    return json;
  }
  throw OjApiException('Invalid response shape', statusCode: statusCode);
}

void _throwIfRequestFailed({
  required Map<String, dynamic> decoded,
  required int statusCode,
}) {
  final success = decoded['success'];
  if (success == true && statusCode >= 200 && statusCode < 300) {
    return;
  }

  if (success == null && statusCode >= 200 && statusCode < 300) {
    return;
  }

  final error = decoded['error'];
  final message = error is Map<String, dynamic>
      ? error['message']?.toString() ?? '요청에 실패했습니다.'
      : decoded['message']?.toString() ?? '요청에 실패했습니다.';
  final code = error is Map<String, dynamic>
      ? error['code']?.toString()
      : decoded['code']?.toString();
  final alert = error is Map<String, dynamic>
      ? error['alert']?.toString()
      : decoded['alert']?.toString();

  throw OjApiException(
    message,
    statusCode: statusCode,
    code: code,
    alert: alert,
  );
}

bool _looksLikeSubmissionPayload(Map<String, dynamic> json) {
  final submissionId = json['submissionId']?.toString().trim();
  final status = json['status']?.toString().trim();
  return submissionId != null &&
      submissionId.isNotEmpty &&
      status != null &&
      status.isNotEmpty;
}

bool _looksLikeReceiptPayload(Map<String, dynamic> json) {
  final submissionId = json['submissionId']?.toString().trim();
  final streamUrl = json['streamUrl']?.toString().trim();
  return submissionId != null &&
      submissionId.isNotEmpty &&
      streamUrl != null &&
      streamUrl.isNotEmpty;
}
