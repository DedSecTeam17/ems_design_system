/// Semantic tone shared by chips, banners, badges and selection tiles.
enum EmsTone {
  /// Default, no status.
  neutral,

  /// Brand / selected.
  primary,

  /// Success, completed, ready.
  success,

  /// Warning, attention needed.
  warning,

  /// Error, danger, destructive.
  danger,

  /// Information.
  info,
}

/// Category accent for icons (decision D11: location, vehicle, equipment and
/// crew keep their own colours).
enum EmsAccent {
  /// Location / station (green).
  location,

  /// Vehicle (violet).
  vehicle,

  /// Equipment (violet).
  equipment,

  /// Crew (coral).
  crew,
}
