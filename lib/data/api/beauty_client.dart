import 'package:beauty_master/data/models/dto/chat_log_dto.dart';
import 'package:beauty_master/data/models/dto/day_schedule_dto.dart';
import 'package:beauty_master/data/models/dto/staff_time_slot_dto.dart';
import 'package:beauty_master/data/models/dto/workload_dto.dart';
import 'package:beauty_master/data/models/requests/add_time_slot_request.dart';
import 'package:beauty_master/data/models/requests/edit_time_slot_request.dart';
import 'package:beauty_master/data/models/requests/mark_as_read_request.dart';
import 'package:beauty_master/data/models/requests/send_code_request.dart';
import 'package:beauty_master/data/models/requests/send_firebase_token_request.dart';
import 'package:beauty_master/data/models/requests/send_message_request.dart';
import 'package:beauty_master/data/models/requests/send_phone_request.dart';
import 'package:beauty_master/data/models/requests/update_record_request.dart';
import 'package:beauty_master/data/models/requests/update_staff_request.dart';
import 'package:beauty_master/domain/models/auth.dart';
import 'package:beauty_master/domain/models/order.dart';
import 'package:beauty_master/domain/models/staff_profile.dart';
import 'package:beauty_master/domain/models/venue.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'beauty_client.g.dart';

@RestApi()
abstract class BeautyClient {
  factory BeautyClient(Dio dio, {String? baseUrl}) = _BeautyClient;

  @POST('/staff/phone_challenge')
  Future<void> sendPhone(@Body() SendPhoneRequest request);

  @POST('/staff/auth')
  Future<Auth> sendCode(@Body() SendCodeRequest request);

  @GET('/staff')
  Future<StaffProfile> getProfile();

  @POST('/user/firebase_token')
  Future<Auth> sendFirebaseToken(@Body() SendFirebaseTokenRequest request);

  @GET('/record/{id}')
  Future<Order> getOrder(@Path('id') String id);

  @GET('/staff/records')
  Future<List<Order>> getOrders({
    @Query('limit') required int limit,
    @Query('offset') required int offset,
    @Query('date') DateTime? date,
  });

  @GET('/staff/schedule/workload/{year}/{month}')
  Future<List<WorkloadDto>> getWorkload(@Path('year') int year, @Path('month') int month);

  @GET('/staff/schedule/workload/{year}/{month}/{day}')
  Future<List<DayScheduleDto>> getDaySchedule(@Path('year') int year, @Path('month') int month, @Path('day') int day);

  @PATCH('/staff/record')
  Future<void> updateOrder(@Body() UpdateRecordRequest request);

  @GET('/staff/{id}/schedule')
  Future<List<StaffTimeSlotDto>> getVenueStaffTimeSlots({
    @Path('id') required String staffId,
    @Query('venueId') required String venueId,
  });

  @PATCH('/staff')
  Future<void> updateStaff(@Body() UpdateStaffRequest request);

  @POST('/staff/schedule')
  Future<void> addStaffTimeSlot(@Body() AddTimeSlotRequest request);

  @PATCH('/staff/schedule')
  Future<void> editStaffTimeSlot(@Body() EditTimeSlotRequest request);

  @GET('/staff/organization/venues')
  Future<List<Venue>> getStaffOrganizationVenues();

  @GET('/venue/{id}')
  Future<Venue> getVenue(@Path('id') String id);

  @GET('/record/{recordId}/messages')
  Future<List<ChatLogDto>> getOrderMessages(@Path('recordId') String orderId);

  @POST('/record/{recordId}/message')
  Future<List<ChatLogDto>> sendOrderMessage(@Path('recordId') String orderId, @Body() SendMessageRequest request);

  @PATCH('/record/{recordId}/messages')
  Future<void> markAsRead(@Path('recordId') String orderId, @Body() MarkAsReadRequest request);
}
