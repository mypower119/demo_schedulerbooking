import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';

part 'booking.g.dart';

@JsonSerializable()
@CopyWith()
@collection
class Booking {
  @JsonKey(includeToJson: false, includeFromJson: false)
  Id localId = Isar.autoIncrement;

  DateTime? startTime;

  DateTime? endTime;

  String? subject;

  List<String>? resourceIds;

  String? id;

  Booking({
    this.id,
    this.startTime,
    this.endTime,
    this.subject,
    this.resourceIds,
  });

  factory Booking.fromJson(Map<String, dynamic> json) =>
      _$BookingFromJson(json);

  Map<String, dynamic> toJson() => _$BookingToJson(this);
}
