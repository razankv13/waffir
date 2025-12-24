import com.android.build.gradle.AppExtension

val android = project.extensions.getByType(AppExtension::class.java)

android.apply {
    flavorDimensions("environment")

    productFlavors {
        create("dev") {
            dimension = "environment"
            applicationId = "net.waffir.app.dev"
            resValue(type = "string", name = "app_name", value = "Waffir (Dev)")
        }
        create("staging") {
            dimension = "environment"
            applicationId = "net.waffir.app.staging"
            resValue(type = "string", name = "app_name", value = "Waffir (Staging)")
        }
        create("production") {
            dimension = "environment"
            applicationId = "net.waffir.app"
            resValue(type = "string", name = "app_name", value = "Waffir")
        }
    }
}