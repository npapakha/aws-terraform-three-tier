package com.github

import com.github.Components.addPetLink
import com.github.Components.header
import com.github.Components.petCard
import com.github.Components.petForm
import com.github.Layout.page
import kotlinx.html.*


fun HTML.petsListPage(
    pets: List<ExposedPet>
) {
    val title = "Our Adorable Residents"
    val subtitle = "Meet the animals looking for their forever homes."
    page(title = title) {
        header(title = title, subtitle = subtitle) {
            addPetLink()
        }
        div(classes = "max-w-5xl mx-auto grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6") {
            pets.forEach { pet -> petCard(pet) }
        }
    }
}

fun HTML.petAddPage() {
    val title = "Register New Pet"
    val subtitle = "Enter details for the new arrival."
    val pet = ExposedPet(
        species = Utils.SPECIES.first(),
        name = "",
        age = 0,
        adopted = false,
    )
    page(title = title) {
        header(title = title, subtitle = subtitle)
        petForm(action = Utils.addPetUrl(), pet = pet)
    }
}

fun HTML.petEditPage(
    pet: ExposedPet
) {
    val title = "Edit Pet: ${pet.name}"
    val subtitle = "Updating ID #${pet.id}"
    page(title = title) {
        header(title = title, subtitle = subtitle)
        petForm(action = Utils.editPetUrl(pet.id), pet = pet)
    }
}


private object Utils {
    val SPECIES = listOf("Dog", "Cat", "Rabbit", "Bird", "Other")
    fun homeUrl() = "/"
    fun addPetUrl() = "/pets"
    fun editPetUrl(id: Int?) = "/pets/$id"
}


private object Layout {
    fun HEAD.styles() {
        script { src = "https://cdn.tailwindcss.com" }
        script {
            unsafe {
                // language=JavaScript
                +"""
                tailwind.config = {
                    theme: {
                        extend: {
                            fontFamily: {
                                sans: ['Inter', 'sans-serif']
                            },
                            colors: {
                                'primary': '#4f46e5',
                                'primary-light': '#6366f1',
                                'adopted': '#10b981',
                                'available': '#f97316'
                            }
                        }
                    }
                }
                """.trimIndent()
            }
        }
        style {
            unsafe {
                // language=CSS
                +"""
                body {
                    -webkit-font-smoothing: antialiased;
                    -moz-osx-font-smoothing: grayscale;
                }
                input:required:invalid {
                    border-color: #ef4444; /* red-500 */
                }
                """.trimIndent()
            }
        }
    }

    fun HTML.page(
        title: String,
        content: BODY.() -> Unit
    ) {
        head {
            meta(charset = "UTF-8")
            meta(name = "viewport", content = "width=device-width, initial-scale=1.0")
            styles()
            title { +title }
        }
        body(classes = "bg-gray-100 font-sans min-h-screen p-4 sm:p-8") {
            content()
        }
    }
}


private object Components {
    fun FlowContent.header(
        title: String,
        subtitle: String,
        content: HEADER.() -> Unit = {}
    ) {
        header(classes = "max-w-4xl mx-auto mt-10 mb-20 text-center") {
            h1(classes = "text-4xl font-extrabold text-gray-800 tracking-tight") { +title }
            p(classes = "mt-2 text-xl text-gray-500") { +subtitle }
            content()
        }
    }

    fun FlowContent.addPetLink() {
        a(
            href = Utils.addPetUrl(),
            classes = "mt-6 inline-block px-6 py-3 font-medium rounded-full text-white bg-primary hover:bg-primary-light"
        ) { +"Add New Pet" }
    }

    fun FlowContent.petCard(pet: ExposedPet) {
        val statusColor = if (pet.adopted) "adopted" else "available"
        val statusText = if (pet.adopted) "Adopted" else "Available"

        fun FlowContent.infoLine(
            label: String,
            value: String
        ) {
            div(classes = "flex justify-between") {
                span(classes = "font-medium text-gray-700") { +label }
                span { +value }
            }
        }

        div(classes = "bg-white rounded-xl shadow-sm border-t-4 border-${statusColor}") {
            div(classes = "p-6") {
                a(
                    href = Utils.editPetUrl(pet.id),
                    classes = "text-2xl font-bold text-gray-900",
                ) { +pet.name }
                div(classes = "mt-4 pt-4 border-t border-gray-100 space-y-2 text-sm text-gray-500") {
                    infoLine("ID", "${pet.id}")
                    infoLine("Name", pet.name)
                    infoLine("Age", "${pet.age} years old")
                    infoLine("Status", statusText)
                }
            }
        }
    }

    fun FlowContent.petForm(action: String, pet: ExposedPet) {
        div(classes = "max-w-xl mx-auto") {
            div(classes = "bg-white p-6 sm:p-8 rounded-xl shadow-xl border-t-4 border-primary") {
                form(action = action, method = FormMethod.post) {
                    input(name = "id", type = InputType.hidden) {
                        value = pet.id?.toString() ?: ""
                    }
                    div(classes = "mb-5") {
                        label(classes = "block text-sm font-medium text-gray-700") {
                            htmlFor = "name"
                            +"Name"
                        }
                        input(
                            name = "name",
                            type = InputType.text,
                            classes = "mt-1 block w-full border border-gray-300 rounded-lg p-3",
                        ) {
                            id = "name"
                            value = pet.name
                            placeholder = "e.g., Sparky"
                            required = true
                        }
                    }
                    div(classes = "mb-5") {
                        label(classes = "block text-sm font-medium text-gray-700") {
                            htmlFor = "age"
                            +"Age (Years)"
                        }
                        input(
                            name = "age",
                            type = InputType.number,
                            classes = "mt-1 block w-full border border-gray-300 rounded-lg p-3",
                        ) {
                            id = "age"
                            value = pet.age.toString()
                            placeholder = "0"
                            required = true
                            min = "0"
                            pattern = "[0-9]*"
                        }
                    }

                    div(classes = "mb-6") {
                        span(classes = "text-sm font-medium text-gray-700 block mb-2") { +"Species" }
                        div(classes = "flex flex-wrap gap-y-2") {
                            Utils.SPECIES.forEach { species ->
                                label(classes = "inline-flex items-center mr-6 cursor-pointer") {
                                    input(
                                        name = "species",
                                        type = InputType.radio,
                                        classes = "form-radio h-5 w-5 text-primary border-gray-300"
                                    ) {
                                        id = species
                                        value = species
                                        checked = pet.species == species
                                        required = true
                                    }
                                    span(classes = "ml-2 text-gray-700") { +species }
                                }
                            }
                        }
                    }

                    div(classes = "mb-8") {
                        div(classes = "relative flex flex-start") {
                            div(classes = "flex items-center h-5") {
                                input(
                                    name = "adopted",
                                    type = InputType.checkBox,
                                    classes = "h-5 w-5 border-gray-300",
                                ) {
                                    id = "adopted"
                                    checked = pet.adopted
                                }
                            }
                            div(classes = "ml-3 text-sm") {
                                label(classes = "text-gray-700 cursor-pointer") {
                                    htmlFor = "adopted"
                                    +"Adoption Status"
                                }
                                p(classes = "text-gray-500") {
                                    +"Check this box if the pet has been successfully adopted."
                                }
                            }
                        }
                    }

                    div(classes = "flex flex-col sm:flex-row space-y-3 sm:space-y-0 sm:space-x-3 mt-8") {
                        a(
                            href = Utils.homeUrl(),
                            classes = "w-full sm:w-1/3 py-3 px-4 border border-gray-300 rounded-lg text-center text-gray-700 bg-white",
                        ) { +"Back to List" }
                        button(
                            type = ButtonType.submit,
                            classes = "w-full sm:w-2/3 py-3 px-4 rounded-lg text-white bg-adopted"
                        ) { +"Save Changes" }
                    }
                }
            }
        }
    }
}
