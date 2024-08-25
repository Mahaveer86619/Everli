library home_repository;

import 'dart:convert';
import 'package:everli_client/core/common/constants/app_constants.dart';
import 'package:everli_client/core/common/models/app_user.dart';
import 'package:everli_client/core/common/models/assignments.dart';
import 'package:everli_client/core/common/models/checkpoint.dart';
import 'package:everli_client/core/common/models/invitation.dart';
import 'package:everli_client/core/common/models/role.dart';
import 'package:everli_client/core/resources/helpers.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:everli_client/core/common/models/event.dart';
import 'package:everli_client/core/resources/data_state.dart';

class HomeRepository {
  final Logger _logger;

  HomeRepository({
    required Logger logger,
  }) : _logger = logger;

  //* Events
  Future<DataState<List<MyEvent>>> getMyEvents(
    String userId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${dotenv.get('BASE_URL')}/api/v1/roles/member?member_id=$userId',
        ),
      );
      final jsonData = jsonDecode(response.body);
      final statusCode = jsonData['status_code'];
      final message = jsonData['message'];
      final jData = jsonData['data'];
      final List<dynamic> data;

      if (jData == null) {
        data = List<Map<String, dynamic>>.empty();
      } else {
        data = jData;
      }

      if (statusCode != 200) {
        if (statusCode == 404) {
          return DataFailure('No events found ', statusCode);
        }
        return DataFailure(message, statusCode);
      }

      if (data.isEmpty) {
        return DataSuccess([], message);
      } else {
        final roles =
            data.map((roleData) => MyRole.fromJson(roleData)).toList();

        final eventIds = roles.map((role) => role.eventId).toList();

        final eventsFuture =
            eventIds.map((eventId) => getEventDetails(eventId));
        final events = await Future.wait(eventsFuture);

        if (events.every((event) => event is DataSuccess)) {
          final successfulEvents = events
              .cast<DataSuccess<MyEvent>>()
              .map((event) => event.data!)
              .toList();

          return DataSuccess(successfulEvents, 'Events fetched successfully');
        } else {
          // print if needed
          // final failedEvents =
          //     events.where((event) => event is! DataSuccess).toList();
          return const DataFailure('Failed to fetch some events', -1);
        }
      }
    } catch (e) {
      _logger.e(e.toString());
      return DataFailure(e.toString(), -1);
    }
  }

  Future<DataState<MyEvent>> getEventDetails(
    String eventId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${dotenv.get('BASE_URL')}/api/v1/events?id=$eventId',
        ),
      );

      final jsonData = jsonDecode(response.body);
      final statusCode = jsonData['status_code'];
      final message = jsonData['message'];
      final eventsData = jsonData['data'];

      if (statusCode != 200) {
        if (statusCode == 404) {
          return DataFailure('No event found', statusCode);
        }
        return DataFailure(jsonData['message'], statusCode);
      }

      return DataSuccess(MyEvent.fromJson(eventsData), message);
    } catch (e) {
      _logger.e(e.toString());
      return DataFailure(e.toString(), -1);
    }
  }

  Future<DataState<List<AppUser>>> getEventMembers(
    String eventId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${dotenv.get('BASE_URL')}/api/v1/roles/event?event_id=$eventId',
        ),
      );

      final jsonData = jsonDecode(response.body);
      final statusCode = jsonData['status_code'];
      final message = jsonData['message'];
      final List<dynamic> rolesData;

      if (statusCode != 200) {
        if (statusCode == 404) {
          return DataFailure('No event found', statusCode);
        }
        return DataFailure(message, statusCode);
      }

      if (jsonData['data'] == null) {
        rolesData = List<AppUser>.empty();
      } else {
        rolesData = jsonData['data'] as List<dynamic>;
      }

      final roles =
          rolesData.map((roleData) => MyRole.fromJson(roleData)).toList();

      final memberId = roles.map((role) => role.memberId).toList();

      final membersFuture =
          memberId.map((memberId) => getMemberDetails(memberId));
      final members = await Future.wait(membersFuture);

      if (members.every((member) => member is DataSuccess)) {
        final successfulMembers = members
            .cast<DataSuccess<AppUser>>()
            .map((resp) => resp.data!)
            .toList();

        return DataSuccess(successfulMembers, 'Members fetched successfully');
      } else {
        // print if needed
        // final failedMembers =
        //     members.where((members) => members is! DataSuccess).toList();
        return const DataFailure('Failed to fetch some members', -1);
      }
    } catch (e) {
      _logger.e(e.toString());
      return DataFailure(e.toString(), -1);
    }
  }

  Future<DataState<AppUser>> getMemberDetails(String userId) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${dotenv.get('BASE_URL')}/api/v1/users?id=$userId',
        ),
      );

      final jsonData = jsonDecode(response.body);
      final statusCode = jsonData['status_code'];
      final message = jsonData['message'];
      final data = jsonData['data'];

      if (statusCode != 200) {
        if (statusCode == 404) {
          return DataFailure('User not found', statusCode);
        }
        return DataFailure(message, statusCode);
      }
      return DataSuccess(
        AppUser.fromJson(data),
        message,
      );
    } catch (e) {
      return DataFailure(e.toString(), -1);
    }
  }

  //* Assignments
  Future<DataState<List<MyAssignment>>> getMyAssignments(
    String userId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${dotenv.get('BASE_URL')}/api/v1/assignments/member?member_id=$userId',
        ),
      );
      final jsonData = jsonDecode(response.body);
      final statusCode = jsonData['status_code'];
      final message = jsonData['message'];
      final List<dynamic> assignmentsData;

      if (statusCode != 200) {
        if (statusCode == 404) {
          return DataFailure('No assignments found', statusCode);
        }
        return DataFailure(jsonData['message'], statusCode);
      }

      if (jsonData['data'] == null) {
        assignmentsData = List<MyAssignment>.empty();
      } else {
        assignmentsData = jsonData['data'] as List<dynamic>;
      }

      final assignments = assignmentsData
          .map((assignment) => MyAssignment.fromJson(assignment))
          .toList();
      // final List<MyAssignment> assignments = assignmentsData
      //     .map((assignmentJson) => MyAssignment.fromJson(assignmentJson))
      //     .toList();

      return DataSuccess(assignments, message);
    } catch (e) {
      _logger.e(e.toString());
      return DataFailure(e.toString(), -1);
    }
  }

  Future<DataState<MyAssignment>> getAssignmentDetails(
    String assignmentId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${dotenv.get('BASE_URL')}/api/v1/assignments?id=$assignmentId',
        ),
      );

      final jsonData = jsonDecode(response.body);
      final statusCode = jsonData['status_code'];
      final message = jsonData['message'];
      final assignmentsData = jsonData['data'];

      if (statusCode != 200) {
        if (statusCode == 404) {
          return DataFailure('No assignment found', statusCode);
        }
        return DataFailure(message, statusCode);
      }

      if (jsonData['data'] == null) {
        return DataFailure(message, statusCode);
      }

      return DataSuccess(MyAssignment.fromJson(assignmentsData), message);
    } catch (e) {
      return DataFailure(e.toString(), -1);
    }
  }

  //* Checkpoints
  Future<DataState<List<MyCheckpoint>>> getMyCheckpoints(
    String userId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${dotenv.get('BASE_URL')}/api/v1/checkpoints/member?member_id=$userId',
        ),
      );
      final jsonData = jsonDecode(response.body);
      final statusCode = jsonData['status_code'];
      final message = jsonData['message'];
      final List<dynamic> checkpointsData;

      if (statusCode != 200) {
        if (statusCode == 404) {
          return DataFailure(message, statusCode);
        }
        return DataFailure(message, statusCode);
      }

      if (jsonData['data'] == null) {
        checkpointsData = List<MyAssignment>.empty();
      } else {
        checkpointsData = jsonData['data'] as List<dynamic>;
      }

      final List<MyCheckpoint> checkpoints = checkpointsData
          .map((checkpointJson) => MyCheckpoint.fromJson(checkpointJson))
          .toList();

      return DataSuccess(checkpoints, message);
    } catch (e) {
      return DataFailure(e.toString(), -1);
    }
  }

  Future<DataState<MyCheckpoint>> getCheckpointDetails(
    String checkpointId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${dotenv.get('BASE_URL')}/api/v1/checkpoints?id=$checkpointId',
        ),
      );

      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      final statusCode = response.statusCode;

      if (statusCode != 200) {
        if (statusCode == 404) {
          return DataFailure('No checkpoint found', statusCode);
        }
        return DataFailure(jsonData['message'], statusCode);
      }

      final checkpointData = jsonData['data'];
      final message = jsonData['message'];

      return DataSuccess(MyCheckpoint.fromJson(checkpointData), message);
    } catch (e) {
      return DataFailure(e.toString(), -1);
    }
  }

  //* Invitations
  Future<DataState<void>> deleteInvitation(String invitationId) async {
    try {
      final response = await http.delete(
        Uri.parse(
          '${dotenv.get('BASE_URL')}/api/v1/invitations?id=$invitationId',
        ),
      );

      final jsonData = jsonDecode(response.body);
      final statusCode = jsonData['status_code'];
      final message = jsonData['message'];

      if (statusCode != 200) {
        if (statusCode == 404) {
          return DataFailure('No invitation found', statusCode);
        }
        return DataFailure(message, statusCode);
      }

      return DataSuccess(null, message);
    } catch (e) {
      _logger.e(e.toString());
      return DataFailure(e.toString(), -1);
    }
  }

  Future<DataState<MyEvent>> joinEvent(
    String userId,
    String code,
  ) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${dotenv.get('BASE_URL')}/api/v1/invitations?code=$code',
        ),
      );

      final jsonData = jsonDecode(response.body);
      final statusCode = jsonData['status_code'];
      final message = jsonData['message'];
      final jData = jsonData['data'];

      if (statusCode != 200) {
        if (statusCode == 404) {
          return DataFailure('No invitation found with code', statusCode);
        }
        return DataFailure(message, statusCode);
      }
      final invitationData = MyInvitation.fromJson(jData);

      if (checkDateTimeStatus(invitationData.expiry)) {
        String role;
        switch (invitationData.role) {
          case 'member':
            role = userRoleToString(UserRole.member);
          case 'admin':
            role = userRoleToString(UserRole.admin);
          case 'guest':
            role = userRoleToString(UserRole.guest);
          default:
            return const DataFailure('Invalid role', 400);
        }

        final roleData = MyRole(
          id: invitationData.id,
          memberId: userId,
          eventId: invitationData.eventId,
          role: role,
          createdAt: DateTime.now().toIso8601String(),
          updatedAt: DateTime.now().toIso8601String(),
        );

        final resp = await addRole(roleData);

        if (resp is DataSuccess) {
          return DataSuccess(resp.data!, message);
        } else {
          return DataFailure(message, statusCode);
        }
      } else {
        deleteInvitation(invitationData.id);
        return const DataFailure('Invitation expired, ask for a new one', 400);
      }
    } catch (e) {
      _logger.e(e.toString());
      return DataFailure(e.toString(), -1);
    }
  }

  Future<DataState<MyEvent>> addRole(MyRole role) async {
    try {
      final response = await http.post(
        Uri.parse(
          '${dotenv.get('BASE_URL')}/api/v1/roles',
        ),
        body: const JsonEncoder().convert(role.toJson()),
      );

      final jsonData = jsonDecode(response.body);
      final statusCode = jsonData['status_code'];
      final message = jsonData['message'];
      final jData = jsonData['data'];

      if (statusCode != 201) {
        return DataFailure(message, statusCode);
      }

      final eventId = jData['event_id'];
      final eventResp = await getEventDetails(eventId);

      if (eventResp is DataSuccess) {
        return DataSuccess(eventResp.data!, message);
      } else {
        return DataFailure(message, statusCode);
      }
    } catch (e) {
      _logger.e(e.toString());
      return DataFailure(e.toString(), -1);
    }
  }

  bool checkDateTimeStatus(String iso8601String) {
    final DateTime dateTime = DateTime.parse(iso8601String);
    final now = DateTime.now();
    final difference = dateTime.difference(now);

    if (difference.inHours > 0) {
      return true;
    } else {
      return false;
    }
  }
}
