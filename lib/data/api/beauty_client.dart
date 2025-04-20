import 'package:beauty_master/data/models/dto/workload_dto.dart';
import 'package:beauty_master/data/models/requests/send_code_request.dart';
import 'package:beauty_master/data/models/requests/send_phone_request.dart';
import 'package:beauty_master/data/models/requests/update_record_request.dart';
import 'package:beauty_master/domain/models/auth.dart';
import 'package:beauty_master/domain/models/order.dart';
import 'package:beauty_master/domain/models/staff_profile.dart';
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

  @PATCH('/staff/record')
  Future<void> updateOrder(@Body() UpdateRecordRequest request);
}
