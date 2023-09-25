// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'keeps_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$keepsRepositoryHash() => r'8021788be5f696c1869729ab9861e9f3af71a44c';

/// See also [keepsRepository].
@ProviderFor(keepsRepository)
final keepsRepositoryProvider = Provider<KeepsRepository>.internal(
  keepsRepository,
  name: r'keepsRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$keepsRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef KeepsRepositoryRef = ProviderRef<KeepsRepository>;
String _$keepsQueryHash() => r'11224f7d0d1c8fcd9b74f9001b05531e719564d2';

/// See also [keepsQuery].
@ProviderFor(keepsQuery)
final keepsQueryProvider = AutoDisposeProvider<Query<Keep>>.internal(
  keepsQuery,
  name: r'keepsQueryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$keepsQueryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef KeepsQueryRef = AutoDisposeProviderRef<Query<Keep>>;
String _$keepStreamHash() => r'1de8e1c11889b14039de9e886172a07114ef8ba3';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

typedef KeepStreamRef = AutoDisposeStreamProviderRef<Keep>;

/// See also [keepStream].
@ProviderFor(keepStream)
const keepStreamProvider = KeepStreamFamily();

/// See also [keepStream].
class KeepStreamFamily extends Family<AsyncValue<Keep>> {
  /// See also [keepStream].
  const KeepStreamFamily();

  /// See also [keepStream].
  KeepStreamProvider call(
    String keepId,
  ) {
    return KeepStreamProvider(
      keepId,
    );
  }

  @override
  KeepStreamProvider getProviderOverride(
    covariant KeepStreamProvider provider,
  ) {
    return call(
      provider.keepId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'keepStreamProvider';
}

/// See also [keepStream].
class KeepStreamProvider extends AutoDisposeStreamProvider<Keep> {
  /// See also [keepStream].
  KeepStreamProvider(
    this.keepId,
  ) : super.internal(
          (ref) => keepStream(
            ref,
            keepId,
          ),
          from: keepStreamProvider,
          name: r'keepStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$keepStreamHash,
          dependencies: KeepStreamFamily._dependencies,
          allTransitiveDependencies:
              KeepStreamFamily._allTransitiveDependencies,
        );

  final String keepId;

  @override
  bool operator ==(Object other) {
    return other is KeepStreamProvider && other.keepId == keepId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, keepId.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
