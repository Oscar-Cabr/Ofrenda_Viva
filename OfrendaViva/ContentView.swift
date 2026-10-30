//
//  ContentView.swift
//  Ofrenda Viva — prototipo de pantallas (SwiftUI, iOS 17+)
//
//  Cómo usarlo:
//  1. Xcode > File > New > Project > iOS > App
//     Nombre: OfrendaViva · Interface: SwiftUI · Language: Swift
//  2. Borra todo el contenido de ContentView.swift y pega este archivo.
//  3. Elige un simulador de iPhone y presiona ▶︎ (Cmd + R).
//
//  No necesita imágenes ni librerías: usa SF Symbols y datos de ejemplo.
//

import SwiftUI

// MARK: - Colores

extension Color {
    static let noche = Color(red: 0.17, green: 0.09, blue: 0.25)
    static let cempa = Color(red: 0.95, green: 0.55, blue: 0.11)
    static let rosa  = Color(red: 0.88, green: 0.27, blue: 0.48)
    static let vela  = Color(red: 1.00, green: 0.82, blue: 0.40)
    static let papel = Color(red: 1.00, green: 0.96, blue: 0.93)
}

// MARK: - Modelo

struct Recuerdo: Identifiable {
    let id = UUID()
    let autor: String
    let texto: String
    let esAudio: Bool
    var duracion: String = ""
}

struct SerQuerido: Identifiable, Hashable {
    let id = UUID()
    let nombre: String
    let parentesco: String
    let nacimiento: Int
    let fallecimiento: Int
    let origen: String
    let oficio: String
    let historia: String
    let favoritos: [String]
    let recuerdos: [Recuerdo]
    let icono: String
    let color: Color
    let look: Look

    static func == (a: SerQuerido, b: SerQuerido) -> Bool { a.id == b.id }
    func hash(into h: inout Hasher) { h.combine(id) }

    var iniciales: String {
        nombre.split(separator: " ").prefix(2).compactMap { $0.first }.map(String.init).joined()
    }
}

// MARK: - Datos de ejemplo

enum Datos {
    static let familia = "Familia Hernández"

    static let seres: [SerQuerido] = [
        SerQuerido(
            nombre: "José Hernández", parentesco: "Tu bisabuelo",
            nacimiento: 1932, fallecimiento: 2004, origen: "Oaxaca",
            oficio: "Carpintero",
            historia: "Era carpintero. Le encantaba cantar boleros y siempre traía dulces de tamarindo en la bolsa para sus nietos. Hizo con sus manos la mesa donde hoy se pone la ofrenda.",
            favoritos: ["Tamales", "Café de olla", "Pan dulce", "Boleros"],
            recuerdos: [
                Recuerdo(autor: "Abuela Carmen", texto: "Nos llevaba al río todos los domingos.", esAudio: false),
                Recuerdo(autor: "Tío Beto", texto: "Me enseñó a usar el serrucho cuando tenía 8 años.", esAudio: false),
                Recuerdo(autor: "Abuela Carmen", texto: "Cómo conoció a mi mamá", esAudio: true, duracion: "1:24")
            ],
            icono: "hammer.fill", color: .cempa,
            look: Look(pelo: .corto, canas: true, sombrero: true, bigote: true)),
        SerQuerido(
            nombre: "Rosa Martínez", parentesco: "Tu bisabuela",
            nacimiento: 1935, fallecimiento: 2010, origen: "Puebla",
            oficio: "Cocinera",
            historia: "Hacía el mejor mole de todo el pueblo. Cada Día de Muertos preparaba pan para toda la cuadra y nunca dejaba que nadie se fuera de su casa con hambre.",
            favoritos: ["Mole poblano", "Chocolate caliente", "Flores de cempasúchil"],
            recuerdos: [
                Recuerdo(autor: "Mamá", texto: "Me enseñó la receta del mole. Todavía la hago igual.", esAudio: false),
                Recuerdo(autor: "Abuela Carmen", texto: "Las canciones que cantaba en la cocina", esAudio: true, duracion: "2:05")
            ],
            icono: "fork.knife", color: .rosa,
            look: Look(pelo: .chongo, canas: true, rebozo: true)),
        SerQuerido(
            nombre: "Pedro Ramírez", parentesco: "Tu abuelo",
            nacimiento: 1955, fallecimiento: 2019, origen: "Ciudad de México",
            oficio: "Maestro",
            historia: "Fue maestro de primaria por 35 años. Muchos de sus alumnos todavía lo visitan en la ofrenda. Le apasionaba el futbol y los crucigramas.",
            favoritos: ["Tacos al pastor", "Refresco de toronja", "Futbol"],
            recuerdos: [
                Recuerdo(autor: "Tío Beto", texto: "Nunca se perdía un partido del domingo.", esAudio: false)
            ],
            icono: "book.fill", color: .noche,
            look: Look(pelo: .corto, canas: true, bigote: true, lentes: true))
    ]
}

// MARK: - App principal (pestañas)

struct ContentView: View {
    var body: some View {
        TabView {
            InicioView()
                .tabItem { Label("Inicio", systemImage: "house.fill") }
            FamiliaView()
                .tabItem { Label("Familia", systemImage: "person.3.fill") }
            OfrendaView()
                .tabItem { Label("Ofrenda", systemImage: "flame.fill") }
            EscanearView()
                .tabItem { Label("Escanear", systemImage: "qrcode.viewfinder") }
        }
        .tint(.rosa)
    }
}

// MARK: - Componentes

// Rasgos para dibujar un retrato de ejemplo (no se necesitan fotos reales)
struct Look {
    enum Pelo { case corto, largo, chongo, calvo }
    var pelo: Pelo = .corto
    var canas = false
    var sombrero = false
    var bigote = false
    var lentes = false
    var rebozo = false
}

/// Retrato ilustrado. `antiguo = true` lo pinta en sepia, como foto vieja de ofrenda.
struct Retrato: View {
    let look: Look
    var antiguo = true
    var ropa: Color = .noche

    var body: some View {
        GeometryReader { g in
            let w = min(g.size.width, g.size.height)
            let piel = antiguo ? Color(red: 0.80, green: 0.66, blue: 0.50) : Color(red: 0.87, green: 0.68, blue: 0.52)
            let pelo = look.canas ? Color(red: 0.78, green: 0.76, blue: 0.72)
                                  : (antiguo ? Color(red: 0.30, green: 0.22, blue: 0.15) : Color(red: 0.20, green: 0.13, blue: 0.10))
            let tela = antiguo ? Color(red: 0.35, green: 0.26, blue: 0.18) : ropa

            ZStack {
                // Fondo
                LinearGradient(colors: antiguo
                               ? [Color(red: 0.93, green: 0.85, blue: 0.70), Color(red: 0.72, green: 0.58, blue: 0.40)]
                               : [Color.papel, ropa.opacity(0.25)],
                               startPoint: .top, endPoint: .bottom)

                // Pelo largo o chongo (detrás de la cabeza)
                if look.pelo == .largo {
                    RoundedRectangle(cornerRadius: w * 0.2).fill(pelo)
                        .frame(width: w * 0.5, height: w * 0.62).offset(y: w * 0.02)
                }
                if look.pelo == .chongo {
                    Circle().fill(pelo).frame(width: w * 0.2).offset(y: -w * 0.33)
                }

                // Hombros
                Ellipse().fill(tela)
                    .frame(width: w * 0.95, height: w * 0.6).offset(y: w * 0.46)
                if look.rebozo {
                    Ellipse().stroke(antiguo ? Color(red: 0.55, green: 0.42, blue: 0.30) : Color.rosa, lineWidth: w * 0.06)
                        .frame(width: w * 0.85, height: w * 0.5).offset(y: w * 0.46)
                }
                // Cuello
                Rectangle().fill(piel).frame(width: w * 0.15, height: w * 0.16).offset(y: w * 0.14)
                // Cabeza
                Ellipse().fill(piel).frame(width: w * 0.36, height: w * 0.44).offset(y: -w * 0.05)

                // Pelo encima
                if look.pelo != .calvo && !look.sombrero {
                    Ellipse().fill(pelo)
                        .frame(width: w * 0.40, height: w * 0.22)
                        .offset(y: -w * 0.22)
                }

                // Ojos
                HStack(spacing: w * 0.09) {
                    Circle().frame(width: w * 0.035)
                    Circle().frame(width: w * 0.035)
                }
                .foregroundStyle(Color(red: 0.2, green: 0.15, blue: 0.1))
                .offset(y: -w * 0.07)

                if look.lentes {
                    HStack(spacing: w * 0.03) {
                        Circle().stroke(lineWidth: w * 0.015).frame(width: w * 0.1)
                        Circle().stroke(lineWidth: w * 0.015).frame(width: w * 0.1)
                    }
                    .foregroundStyle(Color(red: 0.15, green: 0.1, blue: 0.05))
                    .offset(y: -w * 0.07)
                }
                if look.bigote {
                    Capsule().fill(pelo).frame(width: w * 0.16, height: w * 0.035).offset(y: w * 0.04)
                }
                // Sonrisa
                Capsule().fill(Color(red: 0.55, green: 0.30, blue: 0.25))
                    .frame(width: w * 0.08, height: w * 0.02).offset(y: w * 0.08)

                if look.sombrero {
                    Capsule().fill(Color(red: 0.25, green: 0.18, blue: 0.12))
                        .frame(width: w * 0.62, height: w * 0.07).offset(y: -w * 0.22)
                    RoundedRectangle(cornerRadius: w * 0.05).fill(Color(red: 0.25, green: 0.18, blue: 0.12))
                        .frame(width: w * 0.36, height: w * 0.17).offset(y: -w * 0.31)
                }
            }
            .frame(width: g.size.width, height: g.size.height)
            .clipped()
        }
    }
}

/// Foto redonda pequeña (listas, inicio).
struct Avatar: View {
    let persona: SerQuerido
    var tamano: CGFloat = 56

    var body: some View {
        Retrato(look: persona.look, antiguo: true)
            .frame(width: tamano, height: tamano)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.vela, lineWidth: tamano > 80 ? 4 : 2))
            .shadow(color: .black.opacity(0.15), radius: 3, y: 2)
    }
}

/// Foto antigua con marco, como la que se pone en la ofrenda.
struct FotoAntigua: View {
    let persona: SerQuerido
    var ancho: CGFloat = 170
    var inclinacion: Double = -3

    var body: some View {
        VStack(spacing: ancho * 0.05) {
            Retrato(look: persona.look, antiguo: true)
                .frame(width: ancho * 0.86, height: ancho * 1.05)
                .overlay(
                    // viñeta para que parezca foto vieja
                    RadialGradient(colors: [.clear, .black.opacity(0.35)],
                                   center: .center, startRadius: ancho * 0.3, endRadius: ancho * 0.75)
                )
            if ancho > 100 {
                Text(persona.nombre.components(separatedBy: " ").first ?? "")
                    .font(.system(size: ancho * 0.09, weight: .medium, design: .serif))
                    .italic()
                    .foregroundStyle(Color(red: 0.35, green: 0.26, blue: 0.18))
            }
        }
        .padding(ancho * 0.07)
        .background(Color(red: 0.99, green: 0.97, blue: 0.92))
        .overlay(Rectangle().stroke(Color.cempa, lineWidth: 3))
        .rotationEffect(.degrees(inclinacion))
        .shadow(color: .black.opacity(0.25), radius: 8, y: 5)
    }
}

struct Tarjeta<Contenido: View>: View {
    @ViewBuilder let contenido: Contenido
    var body: some View {
        contenido
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.white, in: RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.06), radius: 6, y: 3)
    }
}

// MARK: - 1. Inicio

struct InicioView: View {
    var diasParaDiaDeMuertos: Int {
        let cal = Calendar.current
        let hoy = cal.startOfDay(for: .now)
        var comp = DateComponents(year: cal.component(.year, from: hoy), month: 11, day: 1)
        var fecha = cal.date(from: comp)!
        if fecha < hoy {
            comp.year! += 1
            fecha = cal.date(from: comp)!
        }
        return cal.dateComponents([.day], from: hoy, to: fecha).day ?? 0
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Encabezado
                    VStack(alignment: .leading, spacing: 4) {
                        Text(Datos.familia).font(.title2.bold())
                        Text("\(Datos.seres.count) seres queridos · 8 familiares")
                            .font(.subheadline).foregroundStyle(.secondary)
                    }

                    // Contador
                    HStack {
                        VStack(alignment: .leading) {
                            Text(diasParaDiaDeMuertos == 0 ? "¡Hoy es Día de Muertos!" : "Faltan \(diasParaDiaDeMuertos) días")
                                .font(.title3.bold())
                            Text("para Día de Muertos").font(.subheadline)
                        }
                        Spacer()
                        Image(systemName: "flame.fill").font(.system(size: 40))
                    }
                    .foregroundStyle(.white)
                    .padding()
                    .background(Color.cempa.gradient, in: RoundedRectangle(cornerRadius: 18))

                    // Recuerdo del día
                    Text("Recuerdo del día").font(.headline)
                    NavigationLink(value: Datos.seres[1]) {
                        Tarjeta {
                            HStack(spacing: 14) {
                                Avatar(persona: Datos.seres[1])
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(Datos.seres[1].nombre).font(.headline)
                                    Text("Hacía el mejor mole de todo el pueblo.")
                                        .font(.subheadline).foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                    .buttonStyle(.plain)

                    // Actividad
                    Text("Actividad reciente").font(.headline)
                    Tarjeta {
                        VStack(alignment: .leading, spacing: 12) {
                            fila("photo.fill", "Tía Lupe subió 3 fotos de Rosa")
                            fila("mic.fill", "Abuela Carmen grabó un audio sobre José")
                            fila("text.bubble.fill", "Tío Beto agregó un recuerdo de Pedro")
                        }
                    }
                }
                .padding()
            }
            .background(Color.papel)
            .navigationTitle("Ofrenda Viva")
            .navigationDestination(for: SerQuerido.self) { PerfilView(persona: $0) }
        }
    }

    func fila(_ icono: String, _ texto: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icono).foregroundStyle(Color.rosa).frame(width: 22)
            Text(texto).font(.subheadline)
        }
    }
}

// MARK: - 2. Familia (lista + árbol)

struct FamiliaView: View {
    @State private var modo = 0

    var body: some View {
        NavigationStack {
            VStack {
                Picker("Vista", selection: $modo) {
                    Text("Seres queridos").tag(0)
                    Text("Árbol").tag(1)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                if modo == 0 {
                    List(Datos.seres) { persona in
                        NavigationLink(value: persona) {
                            HStack(spacing: 14) {
                                Avatar(persona: persona, tamano: 48)
                                VStack(alignment: .leading) {
                                    Text(persona.nombre).font(.headline)
                                    Text("\(persona.parentesco) · \(String(persona.nacimiento))–\(String(persona.fallecimiento))")
                                        .font(.caption).foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                } else {
                    ArbolView()
                }
                Spacer(minLength: 0)
            }
            .background(Color.papel)
            .navigationTitle("Familia")
            .navigationDestination(for: SerQuerido.self) { PerfilView(persona: $0) }
            .toolbar {
                Button { } label: { Image(systemName: "plus.circle.fill") }
            }
        }
    }
}

struct ArbolView: View {
    struct Miembro {
        let nombre: String
        let look: Look
        var fallecido = false
        var ropa: Color = .rosa
    }

    struct Nodo: View {
        let m: Miembro
        var body: some View {
            VStack(spacing: 4) {
                Retrato(look: m.look, antiguo: m.fallecido, ropa: m.ropa)
                    .frame(width: 64, height: 64)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(m.fallecido ? Color.cempa : m.ropa, lineWidth: 3))
                    .overlay(alignment: .bottomTrailing) {
                        if m.fallecido {
                            Image(systemName: "flame.fill")
                                .font(.caption2).foregroundStyle(.white)
                                .padding(4).background(Color.cempa, in: Circle())
                        }
                    }
                Text(m.nombre).font(.caption.bold())
            }
            .frame(width: 84)
        }
    }

    struct Rama: View {
        var body: some View {
            Rectangle().fill(Color.gray.opacity(0.4)).frame(width: 2, height: 20)
        }
    }

    let jose   = Miembro(nombre: "José",     look: Look(pelo: .corto, canas: true, sombrero: true, bigote: true), fallecido: true)
    let rosa   = Miembro(nombre: "Rosa",     look: Look(pelo: .chongo, canas: true, rebozo: true), fallecido: true)
    let carmen = Miembro(nombre: "Carmen",   look: Look(pelo: .chongo, canas: true, lentes: true), ropa: .cempa)
    let pedro  = Miembro(nombre: "Pedro",    look: Look(pelo: .corto, canas: true, bigote: true, lentes: true), fallecido: true)
    let mama   = Miembro(nombre: "Mamá",     look: Look(pelo: .largo), ropa: .rosa)
    let beto   = Miembro(nombre: "Tío Beto", look: Look(pelo: .corto, bigote: true), ropa: .noche)
    let tu     = Miembro(nombre: "Tú",       look: Look(pelo: .corto), ropa: .cempa)

    var body: some View {
        ScrollView {
            VStack(spacing: 6) {
                Text("Bisabuelos").font(.caption).foregroundStyle(.secondary)
                HStack(spacing: 24) { Nodo(m: jose); Nodo(m: rosa) }
                Rama()
                Text("Abuelos").font(.caption).foregroundStyle(.secondary)
                HStack(spacing: 24) { Nodo(m: carmen); Nodo(m: pedro) }
                Rama()
                Text("Padres y tíos").font(.caption).foregroundStyle(.secondary)
                HStack(spacing: 24) { Nodo(m: mama); Nodo(m: beto) }
                Rama()
                Nodo(m: tu)

                HStack(spacing: 6) {
                    Image(systemName: "flame.fill").font(.caption2).foregroundStyle(.white)
                        .padding(4).background(Color.cempa, in: Circle())
                    Text("Foto en sepia: está en la ofrenda").font(.caption).foregroundStyle(.secondary)
                }
                .padding(.top, 12)
            }
            .padding(.vertical, 20)
            .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - 3. Perfil del ser querido

struct PerfilView: View {
    let persona: SerQuerido
    @State private var seccion = 0
    @State private var mostrarNuevo = false

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                FotoAntigua(persona: persona, ancho: 170)
                    .padding(.vertical, 12)
                VStack(spacing: 4) {
                    Text(persona.nombre).font(.title2.bold())
                    Text("\(persona.parentesco) · \(String(persona.nacimiento))–\(String(persona.fallecimiento))")
                        .foregroundStyle(.secondary)
                    Label("\(persona.oficio) · Nació en \(persona.origen)", systemImage: persona.icono)
                        .font(.subheadline).foregroundStyle(Color.rosa)
                }

                Picker("Sección", selection: $seccion) {
                    Text("Historia").tag(0)
                    Text("Recuerdos").tag(1)
                    Text("Su ofrenda").tag(2)
                }
                .pickerStyle(.segmented)

                switch seccion {
                case 0:
                    Tarjeta { Text(persona.historia).lineSpacing(4) }
                case 1:
                    ForEach(persona.recuerdos) { RecuerdoView(recuerdo: $0) }
                    Button { mostrarNuevo = true } label: {
                        Label("Agregar recuerdo", systemImage: "plus")
                            .bold().frame(maxWidth: .infinity).padding()
                            .background(Color.rosa, in: Capsule())
                            .foregroundStyle(.white)
                    }
                default:
                    Tarjeta {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Lo que le gustaba").font(.headline)
                            ForEach(persona.favoritos, id: \.self) { fav in
                                Label(fav, systemImage: "heart.fill")
                                    .foregroundStyle(Color.noche)
                            }
                            Text("Ideas para ponerle en la ofrenda.")
                                .font(.caption).foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .padding()
        }
        .background(Color.papel)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $mostrarNuevo) { NuevoRecuerdoView(persona: persona) }
    }
}

struct RecuerdoView: View {
    let recuerdo: Recuerdo
    @State private var reproduciendo = false

    var body: some View {
        if recuerdo.esAudio {
            HStack(spacing: 12) {
                Button { reproduciendo.toggle() } label: {
                    Image(systemName: reproduciendo ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 38)).foregroundStyle(Color.vela)
                }
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 3) {
                        ForEach(0..<22, id: \.self) { i in
                            Capsule().fill(Color.vela)
                                .frame(width: 3, height: CGFloat([8, 16, 12, 22, 10, 18][i % 6]))
                        }
                    }
                    Text("\(recuerdo.texto) · \(recuerdo.autor)")
                        .font(.caption).foregroundStyle(.white.opacity(0.8))
                }
                Spacer()
                Text(recuerdo.duracion).font(.caption).foregroundStyle(.white)
            }
            .padding()
            .background(Color.noche, in: RoundedRectangle(cornerRadius: 16))
        } else {
            Tarjeta {
                VStack(alignment: .leading, spacing: 6) {
                    Label(recuerdo.autor, systemImage: "person.crop.circle.fill")
                        .font(.subheadline.bold()).foregroundStyle(Color.cempa)
                    Text(recuerdo.texto)
                }
            }
        }
    }
}

struct NuevoRecuerdoView: View {
    let persona: SerQuerido
    @Environment(\.dismiss) private var dismiss
    @State private var texto = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Tu recuerdo de \(persona.nombre)") {
                    TextField("Cuéntanos una anécdota…", text: $texto, axis: .vertical)
                        .lineLimit(4...8)
                }
                Section {
                    Label("Grabar nota de voz", systemImage: "mic.fill")
                    Label("Agregar fotos", systemImage: "photo.on.rectangle")
                }
                .foregroundStyle(Color.rosa)
            }
            .navigationTitle("Nuevo recuerdo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancelar") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) { Button("Guardar") { dismiss() } }
            }
        }
    }
}

// MARK: - 4. Ofrenda digital

struct ElementoOfrenda: Identifiable {
    let id = UUID()
    let nombre: String
    let icono: String
    let color: Color
    let significado: String
}

struct OfrendaView: View {
    @State private var seleccionado: ElementoOfrenda?

    let elementos: [ElementoOfrenda] = [
        .init(nombre: "Cempasúchil", icono: "camera.macro", color: .cempa,
              significado: "Su color y aroma guían a las almas en su camino de regreso."),
        .init(nombre: "Velas", icono: "flame.fill", color: .vela,
              significado: "Su luz ilumina el camino de los difuntos hacia la ofrenda."),
        .init(nombre: "Agua", icono: "drop.fill", color: .cyan,
              significado: "Calma la sed de las almas después de su largo viaje."),
        .init(nombre: "Sal", icono: "sparkles", color: .white,
              significado: "Símbolo de purificación."),
        .init(nombre: "Pan de muerto", icono: "birthday.cake.fill", color: .cempa,
              significado: "Representa al difunto y la generosidad de quien lo ofrece."),
        .init(nombre: "Papel picado", icono: "flag.fill", color: .rosa,
              significado: "Representa la unión entre la vida y la muerte, y el viento."),
        .init(nombre: "Fotografía", icono: "photo.fill", color: .white,
              significado: "Indica a quién está dedicada la ofrenda."),
        .init(nombre: "Comida favorita", icono: "fork.knife", color: .rosa,
              significado: "Para recibir a nuestros seres queridos con lo que más les gustaba.")
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 18) {
                    // Fotos en la ofrenda
                    HStack(spacing: 14) {
                        ForEach(Datos.seres) { p in
                            NavigationLink(value: p) {
                                VStack {
                                    FotoAntigua(persona: p, ancho: 74, inclinacion: [-4.0, 2.0, -2.0][(Datos.seres.firstIndex(of: p) ?? 0) % 3])
                                    Text(p.nombre.components(separatedBy: " ").first ?? "")
                                        .font(.caption).foregroundStyle(.white)
                                }
                            }
                        }
                    }
                    .padding(.top)

                    Rectangle().fill(Color.rosa.opacity(0.8)).frame(height: 8).clipShape(Capsule())

                    Text("Toca un elemento para conocer su significado")
                        .font(.footnote).foregroundStyle(Color.vela)

                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 90))], spacing: 14) {
                        ForEach(elementos) { e in
                            Button { seleccionado = e } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: e.icono).font(.title).foregroundStyle(e.color)
                                    Text(e.nombre).font(.caption).foregroundStyle(.white)
                                        .multilineTextAlignment(.center)
                                }
                                .frame(maxWidth: .infinity, minHeight: 84)
                                .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 14))
                            }
                        }
                    }
                }
                .padding()
            }
            .background(Color.noche.ignoresSafeArea())
            .navigationTitle("Mi ofrenda")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color.noche, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationDestination(for: SerQuerido.self) { PerfilView(persona: $0) }
            .sheet(item: $seleccionado) { e in
                VStack(spacing: 16) {
                    Image(systemName: e.icono).font(.system(size: 56)).foregroundStyle(Color.cempa)
                    Text(e.nombre).font(.title.bold())
                    Text(e.significado).font(.title3).multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                }
                .padding(30)
                .presentationDetents([.fraction(0.4)])
            }
        }
    }
}

// MARK: - 5. Escanear QR (simulado)

struct EscanearView: View {
    @State private var escaneado = false
    @State private var animar = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Apunta la cámara al código QR\njunto a la foto en tu ofrenda")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white.opacity(0.85))

                ZStack {
                    RoundedRectangle(cornerRadius: 24).fill(.black.opacity(0.5))
                    Image(systemName: "qrcode")
                        .font(.system(size: 120)).foregroundStyle(.white.opacity(0.9))
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.vela, style: StrokeStyle(lineWidth: 4, dash: [40, 140]))
                    Rectangle().fill(Color.cempa).frame(height: 3)
                        .offset(y: animar ? 110 : -110)
                }
                .frame(width: 260, height: 260)
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.6).repeatForever(autoreverses: true)) { animar = true }
                }

                if escaneado {
                    NavigationLink(value: Datos.seres[0]) {
                        HStack(spacing: 14) {
                            Avatar(persona: Datos.seres[0], tamano: 54)
                            VStack(alignment: .leading) {
                                Text(Datos.seres[0].nombre).font(.headline)
                                Text("Tu bisabuelo · 1932–2004").font(.caption).foregroundStyle(.secondary)
                                Text("Ver su historia →").font(.caption.bold()).foregroundStyle(Color.rosa)
                            }
                            Spacer()
                        }
                        .padding()
                        .background(.white, in: RoundedRectangle(cornerRadius: 16))
                    }
                    .buttonStyle(.plain)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                } else {
                    Button("Simular escaneo") {
                        withAnimation(.spring) { escaneado = true }
                    }
                    .bold().padding(.horizontal, 30).padding(.vertical, 14)
                    .background(Color.rosa, in: Capsule())
                    .foregroundStyle(.white)
                }
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.noche.ignoresSafeArea())
            .navigationTitle("Escanear foto")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color.noche, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationDestination(for: SerQuerido.self) { PerfilView(persona: $0) }
        }
    }
}

#Preview {
    ContentView()
}
