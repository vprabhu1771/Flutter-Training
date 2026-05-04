# fix namespace not specified error in android studio lady bug

```bash
FAILURE: Build failed with an exception.

* What went wrong:
A problem occurred configuring project ':sim_data'.
> Could not create an instance of type com.android.build.api.variant.impl.LibraryVariantBuilderImpl.
   > Namespace not specified. Specify a namespace in the module's build file. See https://d.android.com/r/tools/upgrade-assistant/set-namespace for information about setting the namespace.

     If you've specified the package attribute in the source AndroidManifest.xml, you can use the AGP Upgrade Assistant to migrate to the namespace value in the build file. Refer to https://d.android.com/r/tools/upgrade-assistant/agp-upgrade-assistant for general information about using the AGP Upgrade Assistant.
```

`android/build.gradle`

```
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.buildDir = "../build"
subprojects {
    project.buildDir = "${rootProject.buildDir}/${project.name}"
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register("clean", Delete) {
    delete rootProject.buildDir
}
```

To

```
```