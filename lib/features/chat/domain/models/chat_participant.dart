import 'package:beauty_master/domain/models/staff.dart';
import 'package:beauty_master/domain/models/staff_profile.dart';
import 'package:beauty_master/domain/models/user.dart';

typedef ChatParticipantsData = Map<String, ChatParticipant>;

sealed class ChatParticipant {
  final String id;
  final String name;
  final String initials;
  final String? avatar;
  final bool isOwner;

  ChatParticipant({
    required this.id,
    required this.name,
    required this.initials,
    required this.avatar,
    this.isOwner = false,
  });
}

class UserParticipant extends ChatParticipant {
  final User user;

  UserParticipant(this.user, {super.isOwner})
    : super(id: user.id, name: user.name, initials: user.initials, avatar: user.photo);
}

class StaffParticipant extends ChatParticipant {
  final Staff staff;

  StaffParticipant(this.staff, {super.isOwner})
    : super(id: staff.id, name: staff.name, initials: staff.initials, avatar: staff.photo);
}

class StaffProfileParticipant extends ChatParticipant {
  final StaffProfile staff;

  StaffProfileParticipant(this.staff, {super.isOwner})
    : super(id: staff.id, name: staff.name, initials: staff.initials, avatar: staff.photo);
}

class UnknownParticipant extends ChatParticipant {
  UnknownParticipant(String id) : super(id: id, name: 'Unknown', initials: '?', avatar: null);
}
