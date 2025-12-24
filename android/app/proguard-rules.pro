# Flutter specific ProGuard rules
# Keep Flutter engine classes
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep Dart side classes
-keep class * extends io.flutter.embedding.android.FlutterActivity
-keep class * extends io.flutter.embedding.android.FlutterFragment
-keep class * extends io.flutter.embedding.android.FlutterFragmentActivity

# Keep AndroidX classes
-keep class androidx.** { *; }
-keep interface androidx.** { *; }

# Keep Google Play services classes (for AdMob, etc.)
-keep class com.google.android.gms.** { *; }
-keep class com.google.ads.** { *; }

# RevenueCat
-keep class com.revenuecat.purchases.** { *; }

# Gson (used by many plugins)
-keepattributes Signature
-keepattributes *Annotation*
-keep class com.google.gson.** { *; }

# Prevent stripping of native method names
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep enum classes
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Keep Parcelable implementations
-keepclassmembers class * implements android.os.Parcelable {
    public static final ** CREATOR;
}

# Keep Serializable classes
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Suppress warnings for missing classes that are not used
-dontwarn javax.annotation.**
-dontwarn kotlin.Unit
-dontwarn retrofit2.**
-dontwarn okhttp3.**
-dontwarn okio.**

# Google Play Core (deferred components) - suppress warnings for optional features
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.SplitInstallException
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManager
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManagerFactory
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest$Builder
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest
-dontwarn com.google.android.play.core.splitinstall.SplitInstallSessionState
-dontwarn com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener
-dontwarn com.google.android.play.core.tasks.OnFailureListener
-dontwarn com.google.android.play.core.tasks.OnSuccessListener
-dontwarn com.google.android.play.core.tasks.Task
