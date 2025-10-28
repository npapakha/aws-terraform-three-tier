package com.github

import com.zaxxer.hikari.HikariDataSource
import io.ktor.server.application.*
import kotlinx.serialization.Serializable
import kotlinx.serialization.json.Json
import org.jetbrains.exposed.sql.Database
import org.koin.dsl.module
import org.koin.ktor.plugin.Koin
import org.koin.logger.slf4jLogger
import software.amazon.awssdk.regions.Region
import software.amazon.awssdk.services.secretsmanager.SecretsManagerClient
import javax.sql.DataSource


fun Application.configureKoin() {
    install(Koin) {
        slf4jLogger()
        modules(dataModule(), awsModule())
    }
}

@Serializable
internal data class DatabaseSecret(
    val username: String,
    val password: String,
)

private fun Application.dataModule() = module {
    single<DatabaseSecret> {
        DatabaseSecret(
            username = getString("postgres.username"),
            password = getString("postgres.password"),
        )
    }
    single<DataSource> {
        HikariDataSource().apply {
            jdbcUrl = getString("postgres.url")
            username = get<DatabaseSecret>().username
            password = get<DatabaseSecret>().password
            driverClassName = "org.postgresql.Driver"
        }
    }
    single<Database> { Database.connect(get<DataSource>()) }
    single<PetService> { PetService(get()) }
}

private fun Application.awsModule() = module {
    if (hasString("aws.region")) {
        single<DatabaseSecret> {
            val region = Region.of(getString("aws.region"))
            val client = SecretsManagerClient.builder().region(region).build()
            val response = client.getSecretValue { it.secretId(getString("aws.dbSecret")) }
            Json.decodeFromString(response.secretString())
        }
    }
}

internal fun Application.getString(path: String): String {
    return environment.config.property(path).getString()
}

internal fun Application.hasString(path: String): Boolean {
    return environment.config.propertyOrNull(path) != null
}
