import 'package:equatable/equatable.dart';
import '../../../domain/entities/parking_overview_entity.dart';

abstract class AdminNotificationsState extends Equatable {
  const AdminNotificationsState();

  @override
  List<Object?> get props => [];
}

class AdminNotificationsInitial extends AdminNotificationsState {}

class AdminNotificationsLoading extends AdminNotificationsState {}

class AdminNotificationsLoaded extends AdminNotificationsState {
  final AdminNotificationsEntity overview;

  const AdminNotificationsLoaded(this.overview);

  @override
  List<Object?> get props => [overview];
}

class AdminNotificationsError extends AdminNotificationsState {
  final String message;

  const AdminNotificationsError(this.message);

  @override
  List<Object?> get props => [message];
}

class AdminNotificationsForbidden extends AdminNotificationsState {
  const AdminNotificationsForbidden();
}
