enum TripLogo {
  car("assets/svgs/car.fill.svg"),
  globe("assets/svgs/globe.svg"),
  bus("assets/svgs/bus.fill.svg"),
  airplaneDeparture("assets/svgs/airplane.departure.svg"),
  mountain2Fill("assets/svgs/mountain.2.fill.svg"),
  tentFill("assets/svgs/tent.fill.svg"),
  binocularsFill("assets/svgs/binoculars.fill.svg");

  final String icon;
  const TripLogo(this.icon);

  static TripLogo fromName(String name) {
    return TripLogo.values.firstWhere(
      (e) => e.name == name,
      orElse: () => TripLogo.car, // default if no match
    );
  }
}

enum SplitType {
  equally("Equally"),
  unequally("Unequally"),
  percentage("Percentage");

  final String value;
  const SplitType(this.value);
}
