# R8 rules for Martial Body.
#
# R8 is enabled in release builds. Everything below protects classes that are
# accessed reflectively by Flutter, drift, sqlite3, or one of our plugins and
# would otherwise be stripped, crashing release-only.

# ---- Flutter engine ------------------------------------------------------
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-dontwarn io.flutter.embedding.**

# ---- SQLite / drift ------------------------------------------------------
# The sqlite3_flutter_libs JNI layer loads native symbols by name.
-keep class org.sqlite.** { *; }
-keep class androidx.sqlite.** { *; }

# ---- Plugins we depend on ------------------------------------------------
# url_launcher, share_plus, path_provider — keep their entry points so the
# MethodChannel lookups survive minification.
-keep class io.flutter.plugins.urllauncher.** { *; }
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
