import SwiftUI

struct HomeViewModel: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    HomeHeader()       // Estilo parecido al LoginHeader
                    SearchBar()        // Igual estilo que tus inputs
                    TodayCareCard()    // Reemplaza al calendario
                    MyPlantsSection()  // Carrusel de plantas
                    HomeTip()          // Tip al estilo de tu componente Tip
                }
                .padding()
            }
            .background(Color(.systemBackground))
        }
    }
}

// MARK: - Header de la Home (similar a LoginHeader)

struct HomeHeader: View {
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Aqua Mate")
                    .bold()
                    .font(.title)
                    .foregroundStyle(.green)

                Text("Don't let your plants dry out")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Text("Hi, User 👋")
                    .font(.headline)
                    .foregroundColor(.black)
            }

            Spacer()

            Image("AquaMateLogo") // Puedes usar "AquaMateLogo" o "Cactus"
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 70, height: 70)
        }
    }
}

// MARK: - Barra de búsqueda (mismo estilo que LoginForm)

struct SearchBar: View {
    @State private var searchText: String = ""

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)

            TextField("Search your plants...", text: $searchText)
                .foregroundColor(.black)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

// MARK: - Tarjeta de cuidados de hoy (reemplazo del calendario)

struct TodayCareCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            Text("Today's care")
                .font(.title3)
                .bold()
                .foregroundColor(.black)

            HStack(spacing: 16) {
                TodayCareItem(
                    icon: "drop.fill",
                    title: "Water today",
                    value: "3 plants",
                    tint: .green
                )

                TodayCareItem(
                    icon: "exclamationmark.triangle.fill",
                    title: "Overdue",
                    value: "1 plant",
                    tint: .orange
                )

                TodayCareItem(
                    icon: "leaf.fill",
                    title: "Fertilize",
                    value: "in 5 days",
                    tint: .blue
                )
            }

            Button {
                print("Add reminder tapped.")
            } label: {
                Text("Add reminder")
                    .bold()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(Color.green.opacity(0.8))
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct TodayCareItem: View {
    let icon: String
    let title: String
    let value: String
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Image(systemName: icon)
                .foregroundColor(tint)
                .font(.headline)

            Text(title)
                .font(.caption)
                .foregroundColor(.gray)

            Text(value)
                .font(.subheadline)
                .bold()
                .foregroundColor(.black)
        }
        .padding(8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(tint.opacity(0.08))
        .cornerRadius(10)
    }
}

// MARK: - Mis plantas (ajustada)

struct MyPlantsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("My Plants")
                .font(.title2)
                .bold()
                .foregroundColor(.black)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    PlantCard(
                        imageName: "PlantExample",
                        name: "Monstera",
                        status: "Hydrated",
                        statusColor: .green
                    )
                    PlantCard(
                        imageName: "PlantExample2",
                        name: "Cactus",
                        status: "In 3 days",
                        statusColor: .orange
                    )
                    PlantCard(
                        imageName: "PlantExample3",
                        name: "Fern",
                        status: "Water now!",
                        statusColor: .red
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
    let statusColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Contenedor para que todas las imágenes tengan mismo tamaño
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))

                Image(imageName)
                    .resizable()
                    .scaledToFit()                // No recorta la planta
                    .padding(10)                  // Deja aire dentro del cuadro
            }
            .frame(width: 130, height: 130)       // Tamaño fijo
            .clipped()

            Text(name)
                .font(.headline)
                .foregroundColor(.black)

            Text(status)
                .font(.caption)
                .bold()
                .foregroundColor(statusColor)
        }
        .padding(8)
        .frame(width: 140, alignment: .leading)   // Todas las cards mismo ancho
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Tip de la Home (inspirado en tu Tip)

struct HomeTip: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Did you know?")
                .bold()
                .font(.title3)
                .foregroundStyle(.orange)

            Text("Keeping a consistent watering schedule helps your plants grow stronger and healthier.")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Preview

#Preview {
    HomeViewModel()
}
