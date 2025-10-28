package com.github

import kotlinx.coroutines.Dispatchers
import kotlinx.serialization.Serializable
import org.jetbrains.exposed.sql.Database
import org.jetbrains.exposed.sql.SchemaUtils
import org.jetbrains.exposed.sql.SortOrder
import org.jetbrains.exposed.sql.SqlExpressionBuilder.eq
import org.jetbrains.exposed.sql.Table
import org.jetbrains.exposed.sql.deleteWhere
import org.jetbrains.exposed.sql.insert
import org.jetbrains.exposed.sql.selectAll
import org.jetbrains.exposed.sql.transactions.experimental.newSuspendedTransaction
import org.jetbrains.exposed.sql.transactions.transaction
import org.jetbrains.exposed.sql.update

@Serializable
data class ExposedPet(
    val id: Int? = null,
    val species: String,
    val name: String,
    val age: Int,
    val adopted: Boolean = false
)

class PetService(database: Database) {

    object Pets : Table() {
        val id = integer("id").autoIncrement()
        val species = varchar("species", length = 255)
        val name = varchar("name", length = 255)
        val age = integer("age")
        val adopted = bool("adopted")
    }

    init {
        transaction(database) {
            SchemaUtils.create(Pets)
        }
    }

    suspend fun findAll(): List<ExposedPet> =
        execute {
            Pets.selectAll()
                .orderBy(Pets.id, SortOrder.DESC)
                .map {
                    ExposedPet(
                        id = it[Pets.id],
                        species = it[Pets.species],
                        name = it[Pets.name],
                        age = it[Pets.age],
                        adopted = it[Pets.adopted],
                    )
                }
        }

    suspend fun findOne(id: Int): ExposedPet? =
        execute {
            Pets.selectAll()
                .where { Pets.id eq id }
                .firstOrNull()
                ?.let {
                    ExposedPet(
                        id = it[Pets.id],
                        species = it[Pets.species],
                        name = it[Pets.name],
                        age = it[Pets.age],
                        adopted = it[Pets.adopted],
                    )
                }
        }

    suspend fun createPet(pet: ExposedPet): Int =
        execute {
            Pets.insert {
                it[Pets.species] = pet.species
                it[Pets.name] = pet.name
                it[Pets.age] = pet.age
                it[Pets.adopted] = pet.adopted
            }[Pets.id]
        }

    suspend fun updatePet(id: Int, pet: ExposedPet) =
        execute {
            Pets.update({ Pets.id eq id }) {
                it[Pets.species] = pet.species
                it[Pets.name] = pet.name
                it[Pets.age] = pet.age
                it[Pets.adopted] = pet.adopted
            }
        }

    suspend fun deletePet(id: Int) =
        execute { Pets.deleteWhere { Pets.id eq id } }
}

private suspend fun <T> execute(block: suspend () -> T): T {
    return newSuspendedTransaction(Dispatchers.IO) { block() }
}
