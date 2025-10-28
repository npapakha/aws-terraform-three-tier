package com.github

import io.ktor.http.Parameters
import io.ktor.server.application.*
import io.ktor.server.html.*
import io.ktor.server.request.receiveParameters
import io.ktor.server.response.*
import io.ktor.server.routing.*
import org.koin.ktor.ext.inject

fun Application.configureRouting() {
    val petService by inject<PetService>()
    routing {
        get("/") {
            val pets = petService.findAll()
            call.respondHtml { petsListPage(pets) }
        }
        get("/pets") {
            call.respondHtml { petAddPage() }
        }
        post("/pets") {
            val params = call.receiveParameters()
            petService.createPet(params.getPet())
            call.respondRedirect("/")
        }
        get("/pets/{id}") {
            val pet = petService.findOne(getInt("id")) ?: throw IllegalArgumentException("Invalid ID")
            call.respondHtml { petEditPage(pet) }
        }
        post("/pets/{id}") {
            val params = call.receiveParameters()
            petService.updatePet(getInt("id"), params.getPet())
            call.respondRedirect("/")
        }
        delete("/pets/{id}") {
            petService.deletePet(getInt("id"))
            call.respondRedirect("/")
        }
    }
}

private fun RoutingContext.getInt(name: String): Int {
    return call.parameters.getInt(name)
}

private fun Parameters.getInt(name: String): Int {
    return this[name]?.toInt() ?: throw IllegalArgumentException("Invalid '$name'")
}

private fun Parameters.getString(name: String): String {
    return this[name] ?: throw IllegalArgumentException("Invalid '$name'")
}

private fun Parameters.getPet(): ExposedPet {
    return ExposedPet(
        id = this["id"]?.toIntOrNull(),
        species = getString("species"),
        name = getString("name"),
        age = getInt("age"),
        adopted = this["adopted"] != null,
    )
}
