```
https://kotlinlang.org/docs/gradle-compiler-options.html#target-the-jvm
```

`app/build.gradle.kts`

```
import org.jetbrains.kotlin.gradle.dsl.JvmTarget
import org.jetbrains.kotlin.gradle.dsl.KotlinVersion

android {

  kotlin {
        compilerOptions {
            jvmTarget = JvmTarget.fromTarget("17")
        }
    }

    kotlinOptions {
         // jvmTarget = JavaVersion.VERSION_11.toString()
    }
}
````
