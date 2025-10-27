import 'package:waffir/main.dart' as runner;
import 'package:waffir/flavors.dart';

Future<void> main() async {
  await runner.mainCommon(Flavor.dev);
}
