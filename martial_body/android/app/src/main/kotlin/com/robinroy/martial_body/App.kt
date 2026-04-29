package com.robinroy.martial_body

import android.app.Application
import io.flutter.embedding.engine.FlutterInjector

class App : Application() {
    override fun onCreate() {
        // Configure FlutterInjector before Flutter initialises.
        // By default Flutter creates a PlayStoreDeferredComponentManager (which pulls in
        // Google Play Core classes). This app has no deferred components, so we provide
        // an injector with no deferred component manager. R8 can then remove
        // PlayStoreDeferredComponentManager and its Play Core dependencies entirely.
        FlutterInjector.setInstance(FlutterInjector.Builder().build())
        super.onCreate()
    }
}
