// import 'package:dartz/dartz.dart';
// import 'package:manage_account_ui/core/networking/api_endpoints.dart';
// import 'package:manage_account_ui/core/networking/dio_helper.dart';
// import 'package:manage_account_ui/core/utils/error_parser.dart';
// import 'package:manage_account_ui/core/utils/service_locator.dart';
// import 'package:manage_account_ui/core/utils/storge_helper.dart';

// /// Property Terms & Conditions + per-user consent for the onboarding flow.
// ///
// /// - [getActiveTerms] is public (no token) — called during registration before
// ///   any token exists, keyed by the property the resident is joining.
// /// - [publishTerms] and [postConsent] are authenticated (Admin/Manager publish,
// ///   any signed-in user upserts their own consent).
// class OnboardingRepo {
//   final DioHelper _dioHelper;
//   OnboardingRepo(this._dioHelper);

//   /// GET `/api/property-terms/active/{id}`. Returns the active terms' `sections`
//   /// list, or `null` when the property has no published terms (empty/null body).
//   Future<Either<String, List<dynamic>?>> getActiveTerms(int propertyId) async {
//     final res = await getActiveTermsData(propertyId);
//     return res.map((data) {
//       final sections = data?['sections'];
//       return sections is List ? sections : null;
//     });
//   }

//   /// GET `/api/property-terms/active/{id}` returning the whole active-terms
//   /// object (`{id, property_id, version, is_active, sections, ...}`), or `null`
//   /// when the property has no published terms. The wizard needs `version` to
//   /// send back as `terms_version`; [getActiveTerms] wraps this for callers that
//   /// only need the sections list.
//   Future<Either<String, Map<String, dynamic>?>> getActiveTermsData(
//     int propertyId,
//   ) async {
//     try {
//       final response = await _dioHelper.getRequest(
//         endPoint: ApiEndpoints.propertyTermsActive(propertyId),
//       );

//       if (response.statusCode == 200 ||
//           response.statusCode == 201 ||
//           response.statusCode == 202) {
//         final data = response.data;
//         if (data is Map && data['data'] is Map) {
//           return Right(Map<String, dynamic>.from(data['data'] as Map));
//         }
//         // No terms published for this property.
//         return const Right(null);
//       }
//       return Left(ErrorParser.parseError(response));
//     } catch (error) {
//       return Left(ErrorParser.parseError(error));
//     }
//   }

//   /// POST `/api/property-terms/{id}` with `{sections: [...]}`. Publishes a new
//   /// version (Admin or Manager of that property).
//   Future<Either<String, Unit>> publishTerms(
//     int propertyId,
//     List<Map<String, dynamic>> sections,
//   ) async {
//     final token = await sl<StorgeHelper>().getToken();
//     if (token == null || token.isEmpty) {
//       return const Left("No token found");
//     }
//     try {
//       final response = await _dioHelper.postRequest(
//         endPoint: ApiEndpoints.propertyTerms(propertyId),
//         token: token,
//         data: {"sections": sections},
//       );
//       if (response.statusCode == 200 ||
//           response.statusCode == 201 ||
//           response.statusCode == 202) {
//         return const Right(unit);
//       }
//       return Left(ErrorParser.parseError(response));
//     } catch (error) {
//       return Left(ErrorParser.parseError(error));
//     }
//   }

//   /// POST `/api/property-terms/{id}` history list (GET). Returns the raw list.
//   Future<Either<String, List<dynamic>>> getTermsHistory(int propertyId) async {
//     final token = await sl<StorgeHelper>().getToken();
//     if (token == null || token.isEmpty) {
//       return const Left("No token found");
//     }
//     try {
//       final response = await _dioHelper.getRequest(
//         endPoint: ApiEndpoints.propertyTerms(propertyId),
//         token: token,
//       );
//       if (response.statusCode == 200 ||
//           response.statusCode == 201 ||
//           response.statusCode == 202) {
//         final data = response.data;
//         if (data is Map && data['data'] is List) {
//           return Right(data['data'] as List);
//         }
//         return const Right(<dynamic>[]);
//       }
//       return Left(ErrorParser.parseError(response));
//     } catch (error) {
//       return Left(ErrorParser.parseError(error));
//     }
//   }

//   /// POST `/api/user-consents` with `{property_id, terms_version?, gdpr_consented?}`.
//   /// Upserts the signed-in user's consent record.
//   Future<Either<String, Unit>> postConsent({
//     required int propertyId,
//     int? termsVersion,
//     bool? gdprConsented,
//   }) async {
//     final token = await sl<StorgeHelper>().getToken();
//     if (token == null || token.isEmpty) {
//       return const Left("No token found");
//     }
//     try {
//       final data = <String, dynamic>{"property_id": propertyId};
//       if (termsVersion != null) data["terms_version"] = termsVersion;
//       if (gdprConsented != null) data["gdpr_consented"] = gdprConsented;

//       final response = await _dioHelper.postRequest(
//         endPoint: ApiEndpoints.userConsents,
//         token: token,
//         data: data,
//       );
//       if (response.statusCode == 200 ||
//           response.statusCode == 201 ||
//           response.statusCode == 202) {
//         return const Right(unit);
//       }
//       return Left(ErrorParser.parseError(response));
//     } catch (error) {
//       return Left(ErrorParser.parseError(error));
//     }
//   }
// }
