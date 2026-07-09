# =============================================================================
# REGLAS CRÍTICAS DE REGISTRO DE PLUGINS (Evita canales rotos)
# =============================================================================
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.plugins.GeneratedPluginRegistrant { *; }
-keep class io.flutter.embedding.engine.plugins.** { *; }

# Mantener todos los canales de mensajería Pigeon y Platform Views
-keep class dev.flutter.pigeon.** { *; }
-keep class io.flutter.plugin.platform.** { *; }
-keep class io.flutter.plugin.common.** { *; }

# =============================================================================
# WEBVIEW FLUTTER CORREGIDO
# =============================================================================
-keep class io.flutter.plugins.webview_flutter.** { *; }
-dontwarn io.flutter.plugins.webview_flutter.**

# =============================================================================
# FLUTTER ENGINE BÁSICO
# =============================================================================
-keep class io.flutter.** { *; }
-dontwarn com.google.android.play.core.**

# =============================================================================
# GOOGLE ML KIT TEXT RECOGNITION
# =============================================================================
-keep class com.google.mlkit.vision.text.** { *; }
-keep class com.google.mlkit.vision.common.** { *; }
-dontwarn com.google.mlkit.vision.text.chinese.**
-dontwarn com.google.mlkit.vision.text.japanese.**
-dontwarn com.google.mlkit.vision.text.korean.**
-dontwarn com.google.mlkit.vision.text.devanagari.**

# =============================================================================
# REGLAS PARA VISOR DE PDF NATIVO
# =============================================================================
-keep class com.github.barteksc.pdfviewer.** { *; }
-dontwarn com.github.barteksc.pdfviewer.**