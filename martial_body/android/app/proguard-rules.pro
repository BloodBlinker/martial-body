# R8 rules for Martial Body.
#
# R8 is enabled in release builds. Everything below protects classes that are
# accessed reflectively by Flutter, drift, sqlite3, or one of our plugins and
# would otherwise be stripped, crashing release-only.

# ---- Flutter engine ------------------------------------------------------
# Keep Flutter embedding subpackages explicitly — intentionally omits
# deferredcomponents so R8 can remove PlayStoreDeferredComponentManager
# and its Google Play Core dependencies from the APK DEX.
-keep class io.flutter.embedding.android.** { *; }
-keep class io.flutter.embedding.engine.dart.** { *; }
-keep class io.flutter.embedding.engine.FlutterEngine { *; }
-keep class io.flutter.embedding.engine.FlutterEngineCache { *; }
-keep class io.flutter.embedding.engine.FlutterEngineGroup { *; }
-keep class io.flutter.embedding.engine.FlutterJNI { *; }
-keep class io.flutter.embedding.engine.FlutterShellArgs { *; }
-keep class io.flutter.embedding.engine.loader.** { *; }
-keep class io.flutter.embedding.engine.mutatorsstack.** { *; }
-keep class io.flutter.embedding.engine.plugins.** { *; }
-keep class io.flutter.embedding.engine.renderer.** { *; }
-keep class io.flutter.embedding.engine.systemchannels.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-dontwarn io.flutter.embedding.**

# Remove Play Core and deferred components entirely.
# These classes are compiled into Flutter's engine but unused by this app.
# Tell R8 these classes have no extensions, allowing aggressive shrinking/removal.
-assumenoextension,allowshrinking class com.google.android.play.core.** { *; }
-assumenoextension,allowshrinking class com.google.android.play.** { *; }
-assumenoextension,allowshrinking class io.flutter.embedding.engine.deferredcomponents.** { *; }

# Suppress warnings about missing Play Core references
-dontwarn com.google.android.play.**
-dontwarn io.flutter.embedding.engine.deferredcomponents.**

# ---- SQLite / drift ------------------------------------------------------
# The sqlite3_flutter_libs JNI layer loads native symbols by name.
-keep class org.sqlite.** { *; }
-keep class androidx.sqlite.** { *; }

# ---- Plugins we depend on ------------------------------------------------
# share_plus, path_provider — keep their entry points so the
# MethodChannel lookups survive minification.
-keep class dev.fluttercommunity.plus.share.** { *; }
-keep class io.flutter.plugins.pathprovider.** { *; }

# ---- Kotlin metadata -----------------------------------------------------
# Strip kotlin.Metadata to reduce size but keep kotlin.Unit / coroutines.
-keep class kotlin.Metadata { *; }
-dontwarn kotlin.**
-dontwarn kotlinx.**

# ---- Miscellaneous warnings we don't care about --------------------------
-dontwarn javax.annotation.**
-dontwarn com.google.errorprone.annotations.**
