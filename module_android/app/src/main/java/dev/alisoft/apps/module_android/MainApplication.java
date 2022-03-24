package dev.alisoft.apps.module_android;

import android.app.Application;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.FlutterEngineCache;
import io.flutter.embedding.engine.dart.DartExecutor;

public class MainApplication extends Application {
    private FlutterEngine flutterEngine;

    @Override
    public void onCreate() {
        super.onCreate();
        // Instantiate a FlutterEngine.
        this.flutterEngine = new FlutterEngine(this);

        // Start executing Dart code to pre-warm the FlutterEngine.
        this.flutterEngine.getDartExecutor().executeDartEntrypoint(
                DartExecutor.DartEntrypoint.createDefault()
        );

        // Cache the FlutterEngine to be used by FlutterActivity.
        FlutterEngineCache
                .getInstance()
                .put("my_engine_id", flutterEngine);
    }
}
