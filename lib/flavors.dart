enum Flavor {
  dev,
  prod,
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.dev:
        return 'Counter App Dev';
      case Flavor.prod:
        return 'Counter App Prod';
      default:
        return 'title';
    }
  }

}
