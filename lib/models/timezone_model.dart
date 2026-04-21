class TimezoneData {
  final String country;
  final String offset;
  final String id;
  final String flag;

  TimezoneData({
    required this.country,
    required this.offset,
    required this.id,
    required this.flag,
  });

  /// Get display name with flag, country, and offset
  /// Example: "🇰🇭 Cambodia - UTC+07:00"
  String getDisplayName() {
    return '$flag $country - $offset';
  }

  /// Parse UTC offset to get hours
  /// Example: "UTC+05:30" returns 5.5
  double getUtcHours() {
    final sign = offset.contains('-') ? -1 : 1;
    final parts = offset
        .replaceAll('UTC', '')
        .replaceAll('+', '')
        .replaceAll('-', '')
        .split(':');
    final hours = int.tryParse(parts[0]) ?? 0;
    final minutes = int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0;
    return sign * (hours + minutes / 60.0);
  }

  /// Create a copy of this timezone with optional overrides
  TimezoneData copyWith({
    String? country,
    String? offset,
    String? id,
    String? flag,
  }) {
    return TimezoneData(
      country: country ?? this.country,
      offset: offset ?? this.offset,
      id: id ?? this.id,
      flag: flag ?? this.flag,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'country': country,
      'offset': offset,
      'id': id,
      'flag': flag,
    };
  }

  /// Create from JSON
  factory TimezoneData.fromJson(Map<String, dynamic> json) {
    return TimezoneData(
      country: json['country'] ?? '',
      offset: json['offset'] ?? '',
      id: json['id'] ?? '',
      flag: json['flag'] ?? '',
    );
  }

  @override
  String toString() => 'TimezoneData(country: $country, offset: $offset, id: $id)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimezoneData &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
