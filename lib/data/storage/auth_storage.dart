import 'package:beauty_master/data/storage/base/persistent_stream_storage.dart';
import 'package:beauty_master/domain/models/auth.dart';

class AuthStorage extends PersistentStreamStorage<Auth?> {
  AuthStorage({
    required super.secureStorage,
  }) : super(
          initialValue: null,
          fromJson: Auth.fromJson,
          toJson: (value) => value?.toJson() ?? {},
          key: 'auth',
        );
}
