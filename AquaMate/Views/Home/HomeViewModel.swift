import SwiftUI

// MARK: - 🎨 Paleta de Colores (AquaUI)

struct AquaUI {
    static let background      = Color(red: 0.94, green: 0.97, blue: 0.90) // verde muy claro
    static let primaryGreen    = Color(red: 0.48, green: 0.63, blue: 0.24) // verde tab contenedor
    static let secondaryGreen  = Color(red: 0.77, green: 0.85, blue: 0.52) // verde tab seleccionado / cards
    static let blue            = Color(red: 0.35, green: 0.50, blue: 0.75) // botón / avatar
    static let lightBlue       = Color(red: 0.84, green: 0.89, blue: 0.97)
    static let softYellow      = Color(red: 0.98, green: 0.93, blue: 0.70)
}

// MARK: - 🧭 Definición de Tabs

enum HomeTab: String, CaseIterable {
    case myPlants = "My plants"
    case home = "Home"
    case tips = "Tips"
}

// MARK: - 🏠 HomeViewModel (Vista Principal con Sidebar)

struct HomeViewModel: View {
    @State private var selectedTab: HomeTab = .home
    // ⚠️ Depende de que 'Plant' esté disponible globalmente.
    @State private var plants: [Plant] = Plant.samplePlants
    
    // 💡 Estado para controlar la apertura/cierre de la barra lateral
    @State private var isSidebarOpen: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            // ❗ Cambiamos la alineación principal a la derecha
            ZStack(alignment: .trailing) {
                
                // 1. Contenido Principal (con NavigationStack)
                NavigationStack {
                    ZStack {
                        AquaUI.background.ignoresSafeArea()
                        
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(alignment: .leading, spacing: 24) {
                                
                                // El header con el botón de perfil sigue a la derecha
                                HomeTopHeader(isSidebarOpen: $isSidebarOpen)
                                HomeSegmentedControl(selectedTab: $selectedTab)
                                
                                // Contenido según la pestaña
                                Group {
                                    switch selectedTab {
                                    case .home:
                                        HomeMainSection(plants: $plants)
                                    case .myPlants:
                                        MyPlantsListView(plants: $plants)
                                    case .tips:
                                        TipsScreen()
                                    }
                                }
                            }
                            .padding(.horizontal, 24)
                            .padding(.top, 24)
                            .padding(.bottom, 24)
                        }
                    }
                }
                // ❗ Aplicamos offset negativo para mover la vista principal a la izquierda
                .offset(x: isSidebarOpen ? -geometry.size.width * 0.75 : 0)
                // Oscurecemos y cerramos al tocar fuera
                .disabled(isSidebarOpen)
                .onTapGesture {
                    if isSidebarOpen {
                        withAnimation(.easeOut) { isSidebarOpen = false }
                    }
                }
                
                // 2. Barra Lateral (Sidebar)
                if isSidebarOpen {
                    SidebarView(isSidebarOpen: $isSidebarOpen)
                        .frame(width: geometry.size.width * 0.75)
                        // ❗ Animación para que entre desde la derecha
                        .transition(.move(edge: .trailing))
                }
            }
        }
    }
}

// MARK: - 👤 Sidebar y Componentes

struct SidebarView: View {
    @Binding var isSidebarOpen: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            // Header con botón de cierre
            HStack {
                // Título
                Text("Opciones")
                    .font(.largeTitle.bold())
                    .foregroundColor(AquaUI.primaryGreen)
                
                Spacer()
                
                // Botón de cierre explícito
                Button {
                    withAnimation { isSidebarOpen = false }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
                .buttonStyle(.plain)
            }
            .padding(.top, 50)
            
            // Resto de los botones del menú
            SidebarButton(title: "Mi Perfil", icon: "person.circle.fill") {
                print("Ir a Perfil")
                withAnimation { isSidebarOpen = false }
            }
            
            SidebarButton(title: "Ajustes", icon: "gear") {
                print("Ir a Ajustes")
                withAnimation { isSidebarOpen = false }
            }
            
            SidebarButton(title: "Ayuda (FAQ)", icon: "questionmark.circle.fill") {
                print("Ir a Ayuda")
                withAnimation { isSidebarOpen = false }
            }
            
            Spacer()
            
            SidebarButton(title: "Cerrar Sesión", icon: "arrow.backward.to.line") {
                print("Cerrar Sesión")
                withAnimation { isSidebarOpen = false }
            }
            .foregroundColor(.red)
            
            Spacer().frame(height: 30)
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(AquaUI.background)
        .shadow(color: .black.opacity(0.2), radius: 10, x: -5, y: 0) // Sombra ajustada a la izquierda
    }
}

struct SidebarButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title3)
                    .frame(width: 24)
                Text(title)
                    .font(.headline)
                Spacer()
            }
            .padding(.vertical, 8)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .foregroundColor(.black)
    }
}


// MARK: - Header superior (SIN CAMBIOS ESTÉTICOS)

struct HomeTopHeader: View {
    // ❗ Binding para abrir el menú
    @Binding var isSidebarOpen: Bool
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Aqua Mate")
                    .font(.title.weight(.semibold))
                    .foregroundColor(AquaUI.primaryGreen)
                
                Text("Don’t let your plants dry out")
                    .font(.subheadline)
                    .foregroundColor(.black.opacity(0.7))
            }
            
            Spacer()
            
            // Botón de perfil (en la derecha, como lo tenías)
            Button {
                withAnimation(.easeOut) {
                    isSidebarOpen.toggle() // Abre/Cierra el menú
                }
            } label: {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [AquaUI.blue, AquaUI.lightBlue],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    Image(systemName: "person.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 22, weight: .medium))
                }
                .frame(width: 46, height: 46)
            }
            .buttonStyle(.plain)
        }
    }
}


// MARK: - Segmented control
// (El resto del código de la aplicación permanece sin cambios)

struct HomeSegmentedControl: View {
    @Binding var selectedTab: HomeTab
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(HomeTab.allCases, id: \.self) { tab in
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        selectedTab = tab
                    }
                } label: {
                    Text(tab.rawValue)
                        .font(.subheadline.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .foregroundColor(
                            selectedTab == tab
                            ? .black
                            : .white
                        )
                        .background(
                            Group {
                                if selectedTab == tab {
                                    RoundedRectangle(cornerRadius: 22)
                                        .fill(AquaUI.secondaryGreen)
                                } else {
                                    Color.clear
                                }
                            }
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .background(
            Capsule()
                .fill(AquaUI.primaryGreen)
        )
    }
}

// MARK: - Saludo

struct GreetingBlock: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Hi User 👋")
                .font(.headline)
                .foregroundColor(.black)
            
            Text("We have all the information about the plant you need.")
                .font(.subheadline)
                .foregroundColor(.black.opacity(0.6))
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

// MARK: - SearchBar (adaptada al Figma)

struct SearchBar: View {
    @State private var searchText: String = ""
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search your plants", text: $searchText)
                .font(.subheadline)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(Color.white.opacity(0.6))
        .cornerRadius(14)
    }
}

// MARK: - Today’s care

struct TodayCareSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Today’s care")
                .font(.title3.weight(.semibold))
                .foregroundColor(.black)
            
            HStack(spacing: 16) {
                RoundedRectangle(cornerRadius: 18)
                    .fill(AquaUI.secondaryGreen)
                
                RoundedRectangle(cornerRadius: 18)
                    .fill(AquaUI.softYellow)
                
                RoundedRectangle(cornerRadius: 18)
                    .fill(AquaUI.lightBlue)
            }
            .frame(height: 90)
            
            Button {
                print("Add reminder tapped")
            } label: {
                Text("Add reminder")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(AquaUI.blue)
                    .cornerRadius(14)
            }
        }
    }
}

// MARK: - My Plants

struct MyPlantsSection: View {
    @Binding var plants: [Plant]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("My Plants")
                    .font(.title2.weight(.semibold))
                    .foregroundColor(.black)
                
                Spacer()
                
                NavigationLink {
                    MyPlantsListView(plants: $plants)
                } label: {
                    Text("See all")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(AquaUI.blue)
                }
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(plants) { plant in
                        NavigationLink {
                            PlantDetailView(plant: plant)
                        } label: {
                            PlantCard(plant: plant)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }
}

struct PlantCard: View {
    let plant: Plant
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.white)
                
                // Nota: Asumo que tienes imágenes llamadas "PlantExample", "PlantExample2", etc.
                Image(plant.imageName)
                    .resizable()
                    .scaledToFit()
                    .padding(14)
            }
            .frame(width: 140, height: 140)
            
            Text(plant.name)
                .font(.headline)
                .foregroundColor(.black)
            
            Text(plant.status)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(8)
        .background(Color.white.opacity(0.9))
        .cornerRadius(18)
        .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 3)
    }
}

struct MyPlantsListView: View {
    @Binding var plants: [Plant]
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("My Plants")
                        .font(.title2.weight(.semibold))
                        .foregroundColor(.black)
                    
                    Text("Here you can see all your plants at a glance.")
                        .font(.subheadline)
                        .foregroundColor(.black.opacity(0.6))
                }
                
                Spacer()
                
                NavigationLink {
                    AddPlantView(plants: $plants)
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 18, weight: .semibold))
                        Text("Add")
                            .font(.subheadline.weight(.semibold))
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(AquaUI.secondaryGreen)
                    .foregroundColor(.black)
                    .cornerRadius(16)
                }
            }
            
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(plants) { plant in
                    NavigationLink {
                        PlantDetailView(plant: plant)
                    } label: {
                        PlantCard(plant: plant)
                    }
                    .buttonStyle(.plain)
                }
            }
            Spacer()
        }
        .padding(.horizontal, -24) // Compensamos el padding de la HomeView si se usa como raíz
        .padding(.top, 0)
        .navigationTitle("All Plants")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PlantDetailView: View {
    let plant: Plant
    
    var body: some View {
        ZStack {
            AquaUI.background.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // Imagen grande
                    ZStack {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color.white.opacity(0.95))
                            .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 5)
                        
                        Image(plant.imageName)
                            .resizable()
                            .scaledToFit()
                            .padding(24)
                    }
                    .frame(height: 260)
                    
                    // Título + estado
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(alignment: .center) {
                            Text(plant.name)
                                .font(.title.bold())
                                .foregroundColor(.black)
                            
                            Spacer()
                            
                            Text(plant.status)
                                .font(.caption.weight(.semibold))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(statusBackground)
                                .foregroundColor(statusTextColor)
                                .cornerRadius(12)
                        }
                        
                        Text("Next watering: \(plant.nextWateringText)")
                            .font(.subheadline)
                            .foregroundColor(.black.opacity(0.7))
                    }
                    
                    // Info rápida
                    HStack(spacing: 16) {
                        InfoChip(
                            icon: "drop.fill",
                            title: "Frequency",
                            value: "Every \(plant.wateringFrequencyDays) days"
                        )
                        InfoChip(
                            icon: "sun.max.fill",
                            title: "Light",
                            value: "Medium"
                        )
                    }
                    
                    // Botón "Water now"
                    Button {
                        print("Water now tapped for \(plant.name)")
                    } label: {
                        Text("Water now")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(AquaUI.blue)
                            .cornerRadius(16)
                    }
                    
                    // Notas / cuidados
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Care tips")
                            .font(.headline)
                            .foregroundColor(.black)
                        
                        Text("Keep the soil slightly moist and avoid overwatering. Make sure the plant gets indirect light and adjust watering frequency based on the season.")
                            .font(.subheadline)
                            .foregroundColor(.black.opacity(0.7))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    Spacer()
                }
                .padding(24)
            }
        }
        .navigationTitle(plant.name)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // Colores según estado
    private var statusBackground: Color {
        if plant.status.lowercased().contains("water") {
            return AquaUI.softYellow
        } else {
            return AquaUI.secondaryGreen
        }
    }
    
    private var statusTextColor: Color {
        return .black
    }
}

struct AddPlantView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var plants: [Plant]
    
    @State private var name: String = ""
    @State private var imageName: String = "PlantExample"
    @State private var status: String = "Hydrated"
    @State private var wateringFrequency: Int = 3
    
    @State private var errorMessage: String? = nil
    
    var body: some View {
        ZStack {
            AquaUI.background.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    Text("Add new plant")
                        .font(.title2.weight(.semibold))
                        .foregroundColor(.black)
                    
                    Text("Fill the information below to add a new plant to your collection.")
                        .font(.subheadline)
                        .foregroundColor(.black.opacity(0.7))
                    
                    // Card blanca
                    VStack(alignment: .leading, spacing: 16) {
                        
                        // Nombre
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Name")
                                .font(.subheadline.weight(.semibold))
                            HStack(spacing: 10) {
                                Image(systemName: "leaf.fill")
                                    .foregroundColor(.gray)
                                TextField("Monstera deliciosa", text: $name)
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 12)
                            .background(Color.white.opacity(0.95))
                            .cornerRadius(14)
                        }
                        
                        // Imagen (mock simple)
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Image style")
                                .font(.subheadline.weight(.semibold))
                            
                            Picker("Image", selection: $imageName) {
                                Text("Plant 1").tag("PlantExample")
                                Text("Plant 2").tag("PlantExample2")
                                Text("Plant 3").tag("PlantExample3")
                            }
                            .pickerStyle(.segmented)
                        }
                        
                        // Estado
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Status")
                                .font(.subheadline.weight(.semibold))
                            
                            Picker("Status", selection: $status) {
                                Text("Hydrated").tag("Hydrated")
                                Text("In X days").tag("In days")
                                Text("Water now!").tag("Water now!")
                            }
                            .pickerStyle(.menu)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .background(Color.white.opacity(0.95))
                            .cornerRadius(14)
                        }
                        
                        // Frecuencia
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Watering frequency (days)")
                                .font(.subheadline.weight(.semibold))
                            
                            HStack {
                                Stepper(value: $wateringFrequency, in: 1...14) {
                                    Text("\(wateringFrequency) day\(wateringFrequency == 1 ? "" : "s")")
                                        .font(.subheadline)
                                }
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .background(Color.white.opacity(0.95))
                            .cornerRadius(14)
                        }
                    }
                    .padding(16)
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
                    
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .font(.footnote)
                            .foregroundColor(.red)
                    }
                    
                    Button {
                        handleSave()
                    } label: {
                        Text("Save plant")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(AquaUI.blue)
                            .cornerRadius(16)
                    }
                    .padding(.top, 8)
                    
                    Spacer()
                }
                .padding(24)
            }
        }
        .navigationTitle("Add Plant")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func handleSave() {
        errorMessage = nil
        
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else {
            errorMessage = "Please enter a name for the plant."
            return
        }
        
        // Definimos un texto simple para el próximo riego
        let nextWateringText = "In \(wateringFrequency) days"
        
        let newPlant = Plant(
            name: trimmedName,
            imageName: imageName,
            status: status == "In days" ? nextWateringText : status,
            wateringFrequencyDays: wateringFrequency,
            nextWateringText: nextWateringText
        )
        
        withAnimation {
            plants.append(newPlant)
        }
        
        dismiss()
    }
}

struct InfoChip: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 18))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.black.opacity(0.6))
                Text(value)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.black)
            }
        }
        .padding(12)
        .background(Color.white.opacity(0.9))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

struct HomeMainSection: View {
    @Binding var plants: [Plant]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            GreetingBlock()
            SearchBar()
            TodayCareSection()
            MyPlantsSection(plants: $plants)
        }
    }
}

struct TipsScreen: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Tips")
                .font(.title2.weight(.semibold))
                .foregroundColor(.black)
            
            Text("Soon you will find useful tips to take care of your plants here.")
                .font(.subheadline)
                .foregroundColor(.black.opacity(0.6))
            
            TipCard()
        }
    }
}

// MARK: - Preview

#Preview {
    HomeViewModel()
}
