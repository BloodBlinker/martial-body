# R8 rules for Martial Body.
#
# Flutter's embedding AAR ships its own consumer-rules.pro which is applied
# automatically by AGP — no custom Flutter keep rules are needed here.
# Adding them caused R8 to keep PlayStoreDeferredComponentManager (and its
# Google Play Core dependencies) that Flutter's own rules correctly leave out.

# ---- SQLite / drift ------------------------------------------------------
# sqlite3_flutter_libs loads native symbols by name via JNI.
-keep class org.sqlite.** { *; }
-keep class androidx.sqlite.** { *; }

# ---- Plugins we depend on ------------------------------------------------
-keep class dev.fluttercommunity.plus.share.** { *; }
-keep class io.flutter.plugins.pathprovider.** { *; }

# ---- Kotlin --------------------------------------------------------------
-keep class kotlin.Metadata { *; }
-dontwarn kotlin.**
-dontwarn kotlinx.**

# ---- Suppress known harmless warnings ------------------------------------
-dontwarn javax.annotation.**
-dontwarn com.google.errorprone.annotations.**
-dontwarn com.google.android.play.**
-dontwarn io.flutter.embedding.engine.deferredcomponents.**
