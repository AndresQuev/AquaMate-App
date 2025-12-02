import SwiftUI
import UserNotifications

// MARK: - ⚠️ PRE-REQUISITOS (Plant + TipCard incluidos aquí para que el archivo sea autocontenido)

// Modelo


// TipCard mínimo

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

// MARK: - 🏷️ Sidebar Navigation Tags

enum SidebarTag: String, CaseIterable, Identifiable {
    case profile, settings, helpFAQ
    var id: String { rawValue }
    @ViewBuilder
    func view() -> some View {
        switch self {
        case .profile: ProfileView()
        case .settings: SettingsView()
        case .helpFAQ: HelpFAQView()
        }
    }
}

// MARK: - ✅ Reminder model + storage + notifications (no redefine Plant ni TipCard)

struct Reminder: Identifiable, Codable, Equatable {
    let id: UUID
    var plantID: UUID?     // optional reference to your Plant.id
    var title: String
    var date: Date

    init(id: UUID = .init(), plantID: UUID? = nil, title: String, date: Date) {
        self.id = id
        self.plantID = plantID
        self.title = title
        self.date = date
    }
}

enum ReminderStorage {
    private static let key = "aquamate_reminders_v1"

    static func save(reminders: [Reminder]) {
        do {
            let data = try JSONEncoder().encode(reminders)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Failed to save reminders:", error)
        }
    }

    static func load() -> [Reminder] {
        guard let data = UserDefaults.standard.data(forKey: key) else { return [] }
        do {
            return try JSONDecoder().decode([Reminder].self, from: data)
        } catch {
            print("Failed to load reminders:", error)
            return []
        }
    }
}

final class NotificationManager {
    static let shared = NotificationManager()
    private init() {}

    private let center = UNUserNotificationCenter.current()
    private var requested = false

    func requestAuthorizationIfNeeded() {
        guard !requested else { return }
        requested = true
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, err in
            if let err = err { print("Notif permission err:", err) }
            print("Notification permission granted:", granted)
        }
    }

    func scheduleNotification(for reminder: Reminder, plantName: String?) {
        requestAuthorizationIfNeeded()

        let content = UNMutableNotificationContent()
        content.title = reminder.title
        if let plantName = plantName {
            content.subtitle = plantName
        }
        content.sound = .default

        let comps = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminder.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
        let request = UNNotificationRequest(identifier: reminder.id.uuidString, content: content, trigger: trigger)

        center.add(request) { error in
            if let error = error { print("Failed to schedule notification:", error) }
            else { print("Scheduled notif:", reminder.title, "at", reminder.date) }
        }
    }

    func cancelNotification(id: String) {
        center.removePendingNotificationRequests(withIdentifiers: [id])
        center.removeDeliveredNotifications(withIdentifiers: [id])
    }
}

// MARK: - 🏠 HomeViewModel (Vista Principal con Sidebar + búsqueda funcional)

struct HomeViewModel: View {
    @State private var selectedTab: HomeTab = .home
    @State private var plants: [Plant] = Plant.samplePlants
    @State private var isSidebarOpen: Bool = false
    @State private var activeLink: SidebarTag? = nil

    // Texto de búsqueda centralizado
    @State private var searchText: String = ""

    // NEW: reminders state (load from storage)
    @State private var reminders: [Reminder] = ReminderStorage.load()

    // Filtrado por nombre (case-insensitive)
    private var filteredPlants: [Plant] {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return plants
        } else {
            return plants.filter { plant in
                plant.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .trailing) {

                // 1. Contenido Principal (con NavigationStack)
                NavigationStack {
                    ZStack {
                        AquaUI.background.ignoresSafeArea()

                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(alignment: .leading, spacing: 24) {

                                HomeTopHeader(isSidebarOpen: $isSidebarOpen)
                                HomeSegmentedControl(selectedTab: $selectedTab)

                                // Contenido según la pestaña
                                Group {
                                    switch selectedTab {
                                    case .home:
                                        HomeMainSection(plants: $plants, searchText: $searchText, filteredPlants: filteredPlants, reminders: $reminders)
                                    case .myPlants:
                                        MyPlantsListView(plants: $plants, filteredPlants: filteredPlants)
                                    case .tips:
                                        TipsScreen()
                                    }
                                }
                            }
                            .padding(.horizontal, 24)
                            .padding(.top, 24)
                            .padding(.bottom, 24)
                        }

                        // NavigationLinks ocultos que son activados al setear activeLink
                        ForEach(SidebarTag.allCases) { tag in
                            NavigationLink(destination: tag.view(), tag: tag, selection: $activeLink) {
                                EmptyView()
                            }
                        }
                        .opacity(0)
                    }
                }
                // Aplicamos offset negativo para mover la vista principal a la izquierda cuando abre sidebar
                .offset(x: isSidebarOpen ? -geometry.size.width * 0.75 : 0)
                .disabled(isSidebarOpen)
                .onTapGesture {
                    if isSidebarOpen {
                        withAnimation(.easeOut) { isSidebarOpen = false }
                    }
                }

                // 2. Barra Lateral (Sidebar)
                if isSidebarOpen {
                    SidebarView(isSidebarOpen: $isSidebarOpen, activeLink: $activeLink)
                        .frame(width: geometry.size.width * 0.75)
                        .transition(.move(edge: .trailing))
                }
            }
        }
    }
}

// MARK: - 👤 Sidebar y Componentes

struct SidebarView: View {
    @Binding var isSidebarOpen: Bool
    @Binding var activeLink: SidebarTag?

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("Opciones")
                    .font(.largeTitle.bold())
                    .foregroundColor(AquaUI.primaryGreen)
                Spacer()
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

            SidebarButton(title: "Mi Perfil", icon: "person.circle.fill") {
                activeLink = .profile
                withAnimation { isSidebarOpen = false }
            }

            SidebarButton(title: "Ajustes", icon: "gear") {
                activeLink = .settings
                withAnimation { isSidebarOpen = false }
            }

            SidebarButton(title: "Ayuda (FAQ)", icon: "questionmark.circle.fill") {
                activeLink = .helpFAQ
                withAnimation { isSidebarOpen = false }
            }

            Spacer()

            SidebarButton(title: "Cerrar Sesión", icon: "arrow.backward.to.line") {
                // Aquí podés implementar logout real
                print("Cerrar Sesión")
                withAnimation { isSidebarOpen = false }
            }
            .foregroundColor(.red)

            Spacer().frame(height: 30)
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(AquaUI.background)
        .shadow(color: .black.opacity(0.2), radius: 10, x: -5, y: 0)
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

// MARK: - 📍 Vistas de Destino (Placeholders)

struct SettingsView: View {
    var body: some View {
        ZStack {
            AquaUI.background.ignoresSafeArea()
            VStack {
                Image(systemName: "gearshape.fill")
                    .font(.largeTitle)
                    .foregroundColor(AquaUI.primaryGreen)
                Text("Ajustes")
                    .font(.title.bold())
                Text("Aquí irían las opciones de configuración de la app.")
                    .font(.subheadline)
            }
            .padding()
        }
        .navigationTitle("Ajustes")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct HelpFAQView: View {
    var body: some View {
        ZStack {
            AquaUI.background.ignoresSafeArea()
            VStack {
                Image(systemName: "questionmark.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(AquaUI.primaryGreen)
                Text("Ayuda (FAQ)")
                    .font(.title.bold())
                Text("Aquí irían las preguntas frecuentes y el soporte.")
                    .font(.subheadline)
            }
            .padding()
        }
        .navigationTitle("Ayuda")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - El resto de tu código con búsqueda funcional

// Home header con botón que abre sidebar
struct HomeTopHeader: View {
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

            Button {
                withAnimation(.easeOut) {
                    isSidebarOpen.toggle()
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

// SearchBar ahora recibe binding al searchText centralizado
struct SearchBar: View {
    @Binding var searchText: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)

            TextField("Search your plants", text: $searchText)
                .font(.subheadline)
                .textInputAutocapitalization(.never)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(Color.white.opacity(0.6))
        .cornerRadius(14)
    }
}

// MARK: - ✅ TodayCareSection + AddReminderView (integrado sin redefinir Plant ni TipCard)

// TodayCareSection ahora recibe bindings para plants y reminders
struct TodayCareSection: View {
    @Binding var plants: [Plant]
    @Binding var reminders: [Reminder]

    @State private var showAddSheet: Bool = false

    private var todaysReminders: [Reminder] {
        let calendar = Calendar.current
        return reminders.filter { calendar.isDateInToday($0.date) }.sorted(by: { $0.date < $1.date })
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Today’s care")
                    .font(.title3.weight(.semibold))
                    .foregroundColor(.black)
                Spacer()
                Button {
                    showAddSheet = true
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "plus.circle.fill").font(.system(size: 16, weight: .semibold))
                        Text("Add reminder").font(.subheadline.weight(.semibold))
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .background(RoundedRectangle(cornerRadius: 12).fill(AquaUI.blue))
                    .foregroundColor(.white)
                }
            }

            if todaysReminders.isEmpty {
                HStack(spacing: 16) {
                    RoundedRectangle(cornerRadius: 18).fill(AquaUI.secondaryGreen).frame(height: 90).overlay(cardContent(title: "Water", subtitle: "No reminders today"))
                    RoundedRectangle(cornerRadius: 18).fill(AquaUI.softYellow).frame(height: 90).overlay(cardContent(title: "Fertilize", subtitle: "Monthly"))
                    RoundedRectangle(cornerRadius: 18).fill(AquaUI.lightBlue).frame(height: 90).overlay(cardContent(title: "Inspect", subtitle: "Check leaves"))
                }
            } else {
                VStack(spacing: 10) {
                    ForEach(todaysReminders) { rem in
                        TodayReminderRow(
                            reminder: rem,
                            plant: plantFor(reminder: rem),
                            onDelete: { removeReminder(rem) }
                        )
                    }
                }
            }
        }
        .sheet(isPresented: $showAddSheet) {
            AddReminderView(plants: plants, onSave: { newReminder in
                addReminder(newReminder)
                showAddSheet = false
            })
        }
    }

    private func cardContent(title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title).font(.headline).foregroundColor(.black)
            Text(subtitle).font(.subheadline).foregroundColor(.black.opacity(0.7))
            Spacer()
        }
        .padding(14)
    }

    private func plantFor(reminder: Reminder) -> Plant? {
        guard let pid = reminder.plantID else { return nil }
        return plants.first(where: { $0.id == pid })
    }

    private func addReminder(_ reminder: Reminder) {
        reminders.append(reminder)
        reminders.sort { $0.date < $1.date }
        ReminderStorage.save(reminders: reminders)
        NotificationManager.shared.scheduleNotification(for: reminder, plantName: plantFor(reminder: reminder)?.name)
    }

    private func removeReminder(_ reminder: Reminder) {
        reminders.removeAll { $0.id == reminder.id }
        ReminderStorage.save(reminders: reminders)
        NotificationManager.shared.cancelNotification(id: reminder.id.uuidString)
    }
}

// Compact row for today's reminder
struct TodayReminderRow: View {
    let reminder: Reminder
    let plant: Plant?
    let onDelete: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            VStack(spacing: 4) {
                Text(reminder.title).font(.subheadline.weight(.semibold)).foregroundColor(.black)
                Text(timeString(from: reminder.date)).font(.caption).foregroundColor(.black.opacity(0.7))
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 10)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.03), radius: 4, x: 0, y: 2)

            VStack(alignment: .leading, spacing: 6) {
                Text(plant?.name ?? "General").font(.subheadline).foregroundColor(.black)
                if let p = plant {
                    Text(p.nextWateringText).font(.caption).foregroundColor(.black.opacity(0.6))
                } else {
                    Text("—").font(.caption).foregroundColor(.black.opacity(0.6))
                }
            }
            Spacer()
            Button {
                onDelete()
            } label: {
                Image(systemName: "trash").foregroundColor(.red)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 6)
    }

    private func timeString(from date: Date) -> String {
        let fmt = DateFormatter()
        fmt.dateStyle = .none
        fmt.timeStyle = .short
        return fmt.string(from: date)
    }
}

// Sheet for adding a reminder
struct AddReminderView: View {
    @Environment(\.dismiss) private var dismiss

    let plants: [Plant]
    let onSave: (Reminder) -> Void

    @State private var selectedPlantID: UUID? = nil
    @State private var title: String = ""
    @State private var date: Date = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date()
    @State private var error: String? = nil

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Form {
                    Section(header: Text("Reminder")) {
                        TextField("Title (e.g. Water Monstera)", text: $title)
                    }

                    Section(header: Text("Plant (optional)")) {
                        Picker("Plant", selection: $selectedPlantID) {
                            Text("General").tag(Optional<UUID>.none)
                            ForEach(plants) { p in
                                Text(p.name).tag(Optional(p.id))
                            }
                        }
                        .pickerStyle(.menu)
                    }

                    Section(header: Text("Date & Time")) {
                        DatePicker("Date", selection: $date, displayedComponents: [.date, .hourAndMinute])
                            .datePickerStyle(.compact)
                    }

                    if let error = error {
                        Text(error).foregroundColor(.red).font(.footnote)
                    }
                }

                Button {
                    handleSave()
                } label: {
                    Text("Save reminder")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AquaUI.blue)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
            }
            .navigationTitle("Add Reminder")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .onAppear {
                NotificationManager.shared.requestAuthorizationIfNeeded()
            }
        }
    }

    private func handleSave() {
        error = nil
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            error = "Please add a title for the reminder."
            return
        }
        let reminder = Reminder(plantID: selectedPlantID, title: trimmed, date: date)
        onSave(reminder)
        dismiss()
    }
}

// MARK: - MyPlantsSection usa filteredPlants (no todos)
struct MyPlantsSection: View {
    @Binding var plants: [Plant]
    let filteredPlants: [Plant]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("My Plants")
                    .font(.title2.weight(.semibold))
                    .foregroundColor(.black)

                Spacer()

                NavigationLink {
                    MyPlantsListView(plants: $plants, filteredPlants: filteredPlants)
                } label: {
                    Text("See all")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(AquaUI.blue)
                }
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(filteredPlants) { plant in
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

// MyPlantsListView recibe binding de plants (para add) y la lista filtrada para mostrar
struct MyPlantsListView: View {
    @Binding var plants: [Plant]
    let filteredPlants: [Plant]

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
                ForEach(filteredPlants) { plant in
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
        .padding(.horizontal, -24)
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
                                .background(statusBackground(for: plant))
                                .foregroundColor(statusTextColor(for: plant))
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

    private func statusBackground(for plant: Plant) -> Color {
        if plant.status.lowercased().contains("water") {
            return AquaUI.softYellow
        } else {
            return AquaUI.secondaryGreen
        }
    }

    private func statusTextColor(for plant: Plant) -> Color {
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

// MARK: - HomeMainSection actualizado para recibir reminders

struct HomeMainSection: View {
    @Binding var plants: [Plant]
    @Binding var searchText: String
    let filteredPlants: [Plant]

    // New binding for reminders
    @Binding var reminders: [Reminder]

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            GreetingBlock()
            SearchBar(searchText: $searchText)
            TodayCareSection(plants: $plants, reminders: $reminders)
            MyPlantsSection(plants: $plants, filteredPlants: filteredPlants)
        }
    }
}

// MARK: - TipsScreen (usa TipCard ya existente)
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



#Preview {
    HomeViewModel()
}
