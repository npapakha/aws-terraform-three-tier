val exposed_version: String by project
val kotlinx_html_version: String by project
val logback_version: String by project
val postgres_version: String by project
val hikaricp_version: String by project
val koin_ktor: String by project
val aws_sdk: String by project

plugins {
    kotlin("jvm") version "2.2.20"
    id("io.ktor.plugin") version "3.3.1"
    id("org.jetbrains.kotlin.plugin.serialization") version "2.2.20"
}

group = "com.github.app"
version = "0.0.1"

application {
    mainClass = "io.ktor.server.netty.EngineMain"
}

ktor {
    docker {
        localImageName.set("540883425878.dkr.ecr.us-east-1.amazonaws.com/petstore")
    }
}

dependencies {
    implementation(platform("software.amazon.awssdk:bom:$aws_sdk"))
    implementation("software.amazon.awssdk:secretsmanager")
    implementation("io.insert-koin:koin-ktor:$koin_ktor")
    implementation("io.insert-koin:koin-logger-slf4j:$koin_ktor")
    implementation("io.ktor:ktor-server-core")
    implementation("io.ktor:ktor-server-html-builder")
    implementation("org.jetbrains.kotlinx:kotlinx-html:$kotlinx_html_version")
    implementation("io.ktor:ktor-server-content-negotiation")
    implementation("io.ktor:ktor-serialization-kotlinx-json")
    implementation("org.jetbrains.exposed:exposed-core:$exposed_version")
    implementation("org.jetbrains.exposed:exposed-jdbc:$exposed_version")
    implementation("org.postgresql:postgresql:$postgres_version")
    implementation("com.zaxxer:HikariCP:${hikaricp_version}")
    implementation("io.ktor:ktor-server-netty")
    implementation("ch.qos.logback:logback-classic:$logback_version")
    implementation("io.ktor:ktor-server-config-yaml")
}
