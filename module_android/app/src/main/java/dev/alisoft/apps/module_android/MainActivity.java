package dev.alisoft.apps.module_android;

import android.os.Build;
import android.os.Bundle;
import android.window.SplashScreenView;

import androidx.core.splashscreen.SplashScreen;
import androidx.core.view.WindowCompat;

import io.flutter.embedding.android.FlutterActivity;

public class MainActivity extends FlutterActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        WindowCompat.setDecorFitsSystemWindows(getWindow(), false);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            // Disable the Android splash screen fade out animation to avoid
            // a flicker before the similar frame is drawn in Flutter.
            getSplashScreen()
                    .setOnExitAnimationListener(
                            SplashScreenView::remove);
        } else {
            SplashScreen.installSplashScreen(this);
        }

        super.onCreate(savedInstanceState);
//        setContentView(R.layout.activity_main);
    }
}