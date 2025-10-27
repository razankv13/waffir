// @dart=3.6
// ignore_for_file: directives_ordering
// build_runner >=2.4.16
// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:build_runner_core/build_runner_core.dart' as _i1;
import 'package:riverpod_generator/builder.dart' as _i2;
import 'package:freezed/builder.dart' as _i3;
import 'package:json_serializable/builder.dart' as _i4;
import 'package:hive_ce_generator/hive_generator.dart' as _i5;
import 'package:source_gen/builder.dart' as _i6;
import 'package:mockito/src/builder.dart' as _i7;
import 'package:build_config/build_config.dart' as _i8;
import 'package:flutter_gen_runner/flutter_gen_runner.dart' as _i9;
import 'dart:isolate' as _i10;
import 'package:build_runner/src/build_script_generate/build_process_state.dart'
    as _i11;
import 'package:build_runner/build_runner.dart' as _i12;
import 'dart:io' as _i13;

final _builders = <_i1.BuilderApplication>[
  _i1.apply(
    r'riverpod_generator:riverpod_generator',
    [_i2.riverpodBuilder],
    _i1.toDependentsOf(r'riverpod_generator'),
    hideOutput: true,
    appliesBuilders: const [r'source_gen:combining_builder'],
  ),
  _i1.apply(
    r'freezed:freezed',
    [_i3.freezed],
    _i1.toDependentsOf(r'freezed'),
    hideOutput: false,
  ),
  _i1.apply(
    r'json_serializable:json_serializable',
    [_i4.jsonSerializable],
    _i1.toDependentsOf(r'json_serializable'),
    hideOutput: true,
    appliesBuilders: const [r'source_gen:combining_builder'],
  ),
  _i1.apply(
    r'hive_ce_generator:hive_type_adapter_generator',
    [_i5.getTypeAdapterBuilder],
    _i1.toDependentsOf(r'hive_ce_generator'),
    hideOutput: true,
    appliesBuilders: const [r'source_gen:combining_builder'],
  ),
  _i1.apply(
    r'hive_ce_generator:hive_adapters_generator',
    [_i5.getAdaptersBuilder],
    _i1.toDependentsOf(r'hive_ce_generator'),
    hideOutput: true,
    appliesBuilders: const [r'source_gen:combining_builder'],
  ),
  _i1.apply(
    r'source_gen:combining_builder',
    [_i6.combiningBuilder],
    _i1.toNoneByDefault(),
    hideOutput: false,
    appliesBuilders: const [r'source_gen:part_cleanup'],
  ),
  _i1.apply(
    r'mockito:mockBuilder',
    [_i7.buildMocks],
    _i1.toDependentsOf(r'mockito'),
    hideOutput: false,
    defaultGenerateFor: const _i8.InputSet(include: [r'test/**']),
  ),
  _i1.apply(
    r'hive_ce_generator:hive_schema_migrator',
    [_i5.getSchemaMigratorBuilder],
    _i1.toNoneByDefault(),
    hideOutput: false,
  ),
  _i1.apply(
    r'hive_ce_generator:hive_registrar_intermediate_generator',
    [_i5.getRegistrarIntermediateBuilder],
    _i1.toDependentsOf(r'hive_ce_generator'),
    hideOutput: true,
  ),
  _i1.apply(
    r'hive_ce_generator:hive_registrar_generator',
    [_i5.getRegistrarBuilder],
    _i1.toDependentsOf(r'hive_ce_generator'),
    hideOutput: false,
  ),
  _i1.apply(
    r'flutter_gen_runner:flutter_gen_runner',
    [_i9.build],
    _i1.toDependentsOf(r'flutter_gen_runner'),
    hideOutput: false,
  ),
  _i1.applyPostProcess(
    r'source_gen:part_cleanup',
    _i6.partCleanup,
  ),
];
void main(
  List<String> args, [
  _i10.SendPort? sendPort,
]) async {
  await _i11.buildProcessState.receive(sendPort);
  _i11.buildProcessState.isolateExitCode = await _i12.run(
    args,
    _builders,
  );
  _i13.exitCode = _i11.buildProcessState.isolateExitCode!;
  await _i11.buildProcessState.send(sendPort);
}
