import 'dart:convert';
import 'package:everli_client/features/app/model/assignments.dart';
import 'package:everli_client/features/app/model/checkpoint.dart';
import 'package:everli_client/features/app/model/role.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:everli_client/features/app/model/event.dart';
import 'package:everli_client/core/resources/data_state.dart';

class HomeRepository {
  final Logger _logger;

  HomeRepository({required Logger logger}) : _logger = logger;

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
      final data = jsonData['data'] as List<dynamic>;

      if (statusCode != 200) {
        if (statusCode == 404) {
          return DataFailure('No events found', statusCode);
        }
        return DataFailure(message, statusCode);
      }

      final roles = data.map((roleData) => MyRole.fromJson(roleData)).toList();

      final eventIds = roles.map((role) => role.eventId).toList();

      final eventsFuture = eventIds.map((eventId) => getEventDetails(eventId));
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
      print("jsonData:");
      _logger.d(jsonData);
      final statusCode = jsonData['status_code'];
      print("statusCode:");
      _logger.d(statusCode);
      final message = jsonData['message'];
      print("message:");
      _logger.d(message);
      final assignmentsData = jsonData['data'] as List<dynamic>;
      print("assignmentsData:");
      _logger.d(assignmentsData);
      if (statusCode != 200) {
        if (statusCode == 404) {
          return DataFailure('No assignments found', statusCode);
        }
        return DataFailure(jsonData['message'], statusCode);
      }

      final assignments = assignmentsData.map((assignment) => MyAssignment.fromJson(assignment)).toList();
      print("assignments:");
      _logger.d(assignments);
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

      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      final statusCode = response.statusCode;

      if (statusCode != 200) {
        if (statusCode == 404) {
          return DataFailure('No assignment found', statusCode);
        }
        return DataFailure(jsonData['message'], statusCode);
      }

      final assignmentData = jsonData['data'];
      final message = jsonData['message'];

      return DataSuccess(MyAssignment.fromJson(assignmentData), message);
    } catch (e) {
      return DataFailure(e.toString(), -1);
    }
  }

  Future<DataState<List<MyCheckpoint>>> getMyCheckpoints(
    String userId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${dotenv.get('BASE_URL')}/api/v1/checkpoints/member?member_id=$userId',
        ),
      );

      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      final statusCode = response.statusCode;

      if (statusCode != 200) {
        if (statusCode == 404) {
          return DataFailure('No checkpoints found', statusCode);
        }
        return DataFailure(jsonData['message'], statusCode);
      }

      final checkpointsData = jsonData['data'] as List<dynamic>;
      final message = jsonData['message'];

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
}
