import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'viewmodels/map_vm.dart';

final mapVM = ChangeNotifierProvider.autoDispose((ref) => MapViewModel());
