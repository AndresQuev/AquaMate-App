import SwiftUI

// MARK: - Paleta (aprox. Figma)

struct AquaUI {
    static let background      = Color(red: 0.94, green: 0.97, blue: 0.90) // verde muy claro
    static let primaryGreen    = Color(red: 0.48, green: 0.63, blue: 0.24) // verde tab contenedor
    static let secondaryGreen  = Color(red: 0.77, green: 0.85, blue: 0.52) // verde tab seleccionado / cards
    static let blue            = Color(red: 0.35, green: 0.50, blue: 0.75) // botón / avatar
    static let lightBlue       = Color(red: 0.84, green: 0.89, blue: 0.97)
    static let softYellow      = Color(red: 0.98, green: 0.93, blue: 0.70)
}

// MARK: - Tabs

enum HomeTab: String, CaseIterable {
    case myPlants = "My plants"
    case home = "Home"
    case tips = "Tips"
}

// MARK: - Home (vista principal)

struct HomeViewModel: View {   // dejo el nombre tal cual lo tenías
    @State private var selectedTab: HomeTab = .home
    
    var body: some View {
        NavigationStack {
            ZStack {
                AquaUI.background.ignoresSafeArea()
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        HomeTopHeader()
                        
                        HomeSegmentedControl(selectedTab: $selectedTab)
                        
                        GreetingBlock()
                        
                        SearchBar()
                        
                        TodayCareSection()
                        
                        MyPlantsSection()
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                }
            }
        }
    }
}

// MARK: - Header superior

struct HomeTopHeader: View {
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Aqua Mate")
                    .font(.title2.weight(.semibold))
                    .foregroundColor(AquaUI.primaryGreen)
                
                Text("Don’t let your plants dry out")
                    .font(.subheadline)
                    .foregroundColor(.black.opacity(0.7))
            }
            
            Spacer()
            
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
    }
}

// MARK: - Segmented control

struct HomeSegmentedControl: View {
    @Binding var selectedTab: HomeTab
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(HomeTab.allCases, id: \.self) { tab in
                Button {
                    selectedTab = tab
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
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("My Plants")
                .font(.title2.weight(.semibold))
                .foregroundColor(.black)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    PlantCard(
                        imageName: "PlantExample",
                        name: "Monstera",
                        status: "Hydrated"
                    )
                    PlantCard(
                        imageName: "PlantExample2",
                        name: "Cactus",
                        status: "In 3 days"
                    )
                    PlantCard(
                        imageName: "PlantExample3",
                        name: "Fern",
                        status: "Water now!"
                    )
                }
                .padding(.vertical, 4)
            }
        }
    }
}

struct PlantCard: View {
    let imageName: String
    let name: String
    let status: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.white)
                
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .padding(14)
            }
            .frame(width: 140, height: 140)
            
            Text(name)
                .font(.headline)
                .foregroundColor(.black)
            
            Text(status)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(8)
        .background(Color.white.opacity(0.9))
        .cornerRadius(18)
        .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 3)
    }
}

// MARK: - Preview

#Preview {
    HomeViewModel()
}
