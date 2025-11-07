plugins {
    kotlin("jvm") version "1.9.20"
    application
}

group = "com.web3.walletsdk"
version = "1.0.0"

repositories {
    mavenCentral()
}

dependencies {
    // Web3j
    implementation("org.web3j:core:4.10.3")

    // Kotlin Coroutines
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-core:1.7.3")

    // Testing
    testImplementation(kotlin("test"))
}

tasks.test {
    useJUnitPlatform()
}

kotlin {
    jvmToolchain(17)
}

application {
    mainClass.set("com.web3.walletsdk.WalletSDKKt")
}
