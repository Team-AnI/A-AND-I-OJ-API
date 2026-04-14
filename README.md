# aandi_oj_api

**A&I 관리 서비스의 온라인 저지(OJ) API 클라이언트 패키지입니다.**

## 개요

`aandi_oj_api`는 온라인 저지(Online Judge) 관련 문제, 제출, 채점 등의 API를 제공하는 클라이언트 패키지입니다. `aandi_api_protocol` 기반으로 구현되어 일관된 에러 처리 및 응답 형식을 제공합니다.

- **패키지명**: aandi_oj_api
- **런타임**: Dart 3.10.4
- **주요 의존성**:
  - aandi_api_protocol: 공통 프로토콜 및 에러 처리
  - aandi_auth: 인증 관련 유틸리티
  - dio: HTTP 통신
  - freezed: 불변 데이터 클래스 생성
  - json_serializable: JSON 직렬화/역직렬화

## 주요 의존성

| 패키지 | 용도 |
|--------|------|
| aandi_api_protocol | 공통 응답 형식, 에러 처리 |
| aandi_auth | 인증 토큰 관리 |
| dio | HTTP 클라이언트 |
| freezed | 불변 데이터 클래스 생성 |
| json_serializable | JSON 직렬화/역직렬화 |

## 공개 진입점

```dart
import 'package:aandi_oj_api/aandi_oj_api.dart';
```

## 빠른 시작

### 1. OJ API 클라이언트 초기화

```dart
import 'package:aandi_oj_api/aandi_oj_api.dart';

final ojClient = OjApiClient(
  baseUrl: 'https://api.example.com',
  accessToken: accessToken,
);
```

### 2. 문제 조회

```dart
try {
  final problems = await ojClient.getProblems();
  final problem = await ojClient.getProblem(problemId: 'PROB-001');
  
  print('문제 수: ${problems.length}');
  print('첫 문제: ${problems.first.title}');
} on ApiException catch (e) {
  print('문제 조회 실패: ${e.message}');
}
```

### 3. 코드 제출

```dart
try {
  final submission = await ojClient.submitCode(
    problemId: 'PROB-001',
    language: 'python3',
    code: 'print("Hello")',
  );
  
  print('제출 완료 - ID: ${submission.id}');
  print('채점 상태: ${submission.status}');
} on ApiException catch (e) {
  print('제출 실패: ${e.message}');
}
```

### 4. 채점 결과 확인

```dart
try {
  final result = await ojClient.getSubmissionResult(
    submissionId: 'SUB-12345',
  );
  
  print('상태: ${result.status}');
  print('메모리: ${result.memoryUsed}MB');
  print('시간: ${result.executionTime}ms');
  print('점수: ${result.score}/100');
} on ApiException catch (e) {
  print('결과 조회 실패: ${e.message}');
}
```

### 5. 에러 처리

```dart
try {
  await ojClient.submitCode(
    problemId: problemId,
    language: language,
    code: code,
  );
} on ApiException catch (e) {
  if (e.statusCode == 401) {
    print('토큰이 유효하지 않습니다');
  } else if (e.statusCode == 404) {
    print('존재하지 않는 문제입니다');
  } else if (e.code == 'DUPLICATE_SUBMISSION') {
    print('이미 제출된 코드입니다');
  } else if (e.statusCode == null) {
    print('네트워크 연결 실패');
  } else {
    print('오류 발생: ${e.message}');
  }
}
```

## API 계약

### 제공되는 주요 엔드포인트

#### 문제 관련 API

| 메서드 | 설명 |
|--------|------|
| getProblems | 문제 목록 조회 |
| getProblem | 특정 문제 상세 조회 |
| searchProblems | 문제 검색 |

#### 제출 관련 API

| 메서드 | 설명 |
|--------|------|
| submitCode | 코드 제출 |
| getSubmission | 제출 정보 조회 |
| getSubmissionResult | 채점 결과 조회 |
| getSubmissions | 제출 목록 조회 |

#### 채점 관련 API

| 메서드 | 설명 |
|--------|------|
| getTestCases | 문제의 테스트케이스 조회 |
| runCustomTest | 커스텀 입력으로 테스트 |

### 성공 응답 예시

```json
{
  "success": false,
  "data": null,
  "error": { "message": "문제를 찾을 수 없습니다", "code": "PROBLEM_NOT_FOUND" }
}
```

### 에러 응답 예시

```json
{
  "success": false,
  "data": null,
  "error": { "message": "문제를 찾을 수 없습니다", "code": "PROBLEM_NOT_FOUND" }
}
```


## 주요 데이터 타입

### Problem

온라인 저지 문제 정보

**주요 필드**:

- id: 문제 고유 ID
- title: 문제 제목
- description: 문제 설명
- difficulty: 난이도 (EASY, MEDIUM, HARD, VERY_HARD)
- timeLimit: 시간 제한 (밀리초)
- memoryLimit: 메모리 제한 (MB)
- tags: 태그 목록
- acceptedCount: 채택된 제출 수
- submissionCount: 총 제출 수

### Submission

코드 제출 정보

**주요 필드**:

- id: 제출 고유 ID
- problemId: 문제 ID
- userId: 사용자 ID
- code: 제출한 코드
- language: 프로그래밍 언어
- status: 채점 상태
- submittedAt: 제출 시간
- score: 점수 (0-100)

### SubmissionResult

채점 결과 상세 정보

**주요 필드**:

- submissionId: 제출 ID
- status: 최종 채점 상태
- score: 최종 점수
- executionTime: 실행 시간 (ms)
- memoryUsed: 사용 메모리 (MB)
- testCaseResults: 각 테스트케이스별 결과 배열
- errorMessage: 에러 메시지


## 설치

### pubspec.yaml에 추가

dependencies:
  aandi_oj_api:
    git:
      url: git@github.com:Team-AnI/A-AND-I-OJ-API.git
      ref: main

### 코드 생성 (필수)

이 패키지는 freezed와 json_serializable을 사용합니다. 설치 후 코드를 생성해야 합니다:

```bash
dart pub get
dart run build_runner build
```

### 지속적 개발 모드

개발 중에는 다음 명령어를 사용하면 파일 변경 시 자동으로 코드를 재생성합니다:

```bash
dart run build_runner watch
```

## 사용 예시

### 1. 전체 워크플로우 - 문제 풀기

```dart
import 'package:aandi_oj_api/aandi_oj_api.dart';

Future<void> solveProblem(String accessToken) async {
  final client = OjApiClient(
    baseUrl: 'https://api.example.com',
    accessToken: accessToken,
  );

  try {
    final problem = await client.getProblem(problemId: 'PROB-001');
    print('문제: ${problem.title}');
    print('설명: ${problem.description}');

    final submission = await client.submitCode(
      problemId: 'PROB-001',
      language: 'python3',
      code: 'print("solution")',
    );
    
    print('제출 ID: ${submission.id}');

    bool isComplete = false;
    int attempts = 0;
    
    while (!isComplete && attempts < 30) {
      await Future.delayed(Duration(seconds: 1));
      
      final result = await client.getSubmissionResult(
        submissionId: submission.id,
      );
      
      print('상태: ${result.status}');
      
      if (result.status == 'ACCEPTED') {
        print('문제를 풀었습니다!');
        print('점수: ${result.score}/100');
        isComplete = true;
      } else if (result.status == 'WRONG_ANSWER') {
        print('답이 틀렸습니다');
        isComplete = true;
      }
      
      attempts++;
    }
  } on ApiException catch (e) {
    print('오류: ${e.message}');
  }
}
```

### 2. 커스텀 테스트

```dart
try {
  final customResult = await client.runCustomTest(
    problemId: 'PROB-001',
    code: 'print("test")',
    input: 'test input',
  );
  
  print('커스텀 테스트 실행 완료');
  print('상태: ${customResult.status}');
  print('출력: ${customResult.output}');
} on ApiException catch (e) {
  print('커스텀 테스트 실패: ${e.message}');
}
```

### 3. 문제 검색 및 필터링

```dart
try {
  final searchResults = await client.searchProblems(
    query: 'array',
  );
  
  print('검색 결과: ${searchResults.length}개');
  
  final allProblems = await client.getProblems(
    page: 1,
    limit: 20,
  );
  
  final easyProblems = allProblems
      .where((p) => p.difficulty == 'EASY')
      .toList();
      
  print('쉬운 문제: ${easyProblems.length}개');
} on ApiException catch (e) {
  print('검색 실패: ${e.message}');
}
```

## 에러 코드

OJ 서비스에서 발생할 수 있는 도메인 에러 코드:

| 에러 코드 | HTTP 상태 | 설명 |
|----------|----------|------|
| PROBLEM_NOT_FOUND | 404 | 존재하지 않는 문제 |
| SUBMISSION_NOT_FOUND | 404 | 존재하지 않는 제출 |
| INVALID_LANGUAGE | 400 | 지원하지 않는 프로그래밍 언어 |
| CODE_TOO_LONG | 400 | 코드 길이 초과 |
| DUPLICATE_SUBMISSION | 409 | 중복된 제출 |
| JUDGING_FAILED | 500 | 채점 시스템 오류 |
| RATE_LIMIT_EXCEEDED | 429 | 요청 제한 초과 |

## 테스트

### 패키지 루트에서 실행

```bash
dart test
```

### 특정 테스트 파일 실행

```bash
dart test test/oj_api_client_test.dart
```

### 커버리지 측정

```bash
dart test --coverage=coverage
```

## 개발 메모

- **타입 안전성**: Dart의 제네릭과 freezed를 활용한 완전한 타입 안전 구현
- **JSON 직렬화**: json_serializable을 통한 자동 JSON 변환
- **일관된 에러 처리**: aandi_api_protocol 기반의 통일된 예외 처리
- **비동기 처리**: Dart의 async/await를 활용한 깔끔한 비동기 API
- **확장성**: 새로운 OJ 기능 추가 시 기존 구조를 유지하면서 확장 가능
- **호환성**: Dart SDK 3.10.4 이상에서 지원

## 관련 패키지

- [aandi_api_protocol](https://github.com/Team-AnI/A-AND-I-PROTOCOL-API/tree/main/packages/api_protocol): 공통 API 프로토콜
- [aandi_auth](https://github.com/Team-AnI/A-AND-I-AUTH-API): 인증 관리
- [aandi_course_api](https://github.com/Team-AnI/A-AND-I-PROTOCOL-API/tree/main/packages/course_api): 과정 API 클라이언트
- [aandi_admin_api](https://github.com/Team-AnI/A-AND-I-PROTOCOL-API/tree/main/packages/admin_api): 관리자 API 클라이언트

