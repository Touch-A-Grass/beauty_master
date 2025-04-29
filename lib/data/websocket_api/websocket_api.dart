import 'dart:convert';

import 'package:beauty_master/data/storage/auth_storage.dart';
import 'package:beauty_master/features/chat/data/models/messages/order_chat_socket_message.dart';
import 'package:rxdart/rxdart.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebsocketApi {
  final String baseUrl;
  final AuthStorage _authStorage;

  const WebsocketApi(this._authStorage, {required this.baseUrl});

  Stream<OrderChatSocketMessage> connectToOrderChat(String orderId) =>
      _connect('/record_chat', {'recordId': orderId}).mapNotNull(
        (e) => switch (e['target']) {
          'ReceiveRecordAddMessageEvent' => MessageReceivedOrderChatSocketMessage.fromJson(
            ((e['arguments'] as List<dynamic>)[0] as Map<String, dynamic>),
          ),
          'ReceiveRecordReadMessageEvent' => MessageReadOrderChatSocketMessage.fromJson(
            ((e['arguments'] as List<dynamic>)[0] as Map<String, dynamic>),
          ),
          _ => null,
        },
      );

  Stream<Map<String, dynamic>> _connect(String path, Map<String, dynamic> queryParams) async* {
    final query = Map.of(queryParams);
    query['token'] = _authStorage.value?.token;
    final socket = WebSocketChannel.connect(Uri.parse(baseUrl + path).replace(path: path, queryParameters: query));
    socket.sink.add('{"protocol":"json","version":1}');
    yield* socket.stream.map((event) => event).mapNotNull((e) {
      if (e is String) {
        final modified = e.substring(0, e.length - 1);
        return jsonDecode(modified);
      }
      if (e is Map<String, dynamic>) {
        return e;
      }
      return null;
    });
  }
}
