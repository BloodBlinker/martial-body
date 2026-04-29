package com.robinroy.martial_body

import android.app.Application

class App : Application() {
    override fun onCreate() {
        disableDeferredComponents()
        super.onCreate()
    }

    // Configure FlutterInjector to not create a PlayStoreDeferredComponentManager.
    // Done via reflection to avoid a compile-time dependency on the Flutter engine JAR,
    // which may not be on the classpath during F-Droid's Kotlin compilation phase.
    // At runtime the Flutter engine is always present so the reflection calls succeed.
    private fun disableDeferredComponents() {
        try {
            val injectorClass = Class.forName("io.flutter.embedding.engine.FlutterInjector")
            val builderClass = Class.forName("io.flutter.embedding.engine.FlutterInjector\$Builder")
            val builder = builderClass.getDeclaredConstructor().newInstance()
            val injector = builderClass.getMethod("build").invoke(builder)
            injectorClass.getMethod("setInstance", injectorClass).invoke(null, injector)
        } catch (_: Exception) {
            // Flutter not initialised yet or API not available — safe to ignore.
        }
    }
}
