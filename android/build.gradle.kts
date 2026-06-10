allprojects {
    repositories {
        google()
        mavenCentral()
<<<<<<< HEAD
        maven { url = uri("https://jitpack.io") }
=======
>>>>>>> b5440cd9c1fee6707fb69424caffafa405c5283c
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
