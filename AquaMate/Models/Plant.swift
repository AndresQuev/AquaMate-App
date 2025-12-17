import SwiftUI

struct Plant: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
    let status: String
    let wateringFrequencyDays: Int
    let nextWateringText: String
}

extension Plant {
    static let samplePlants: [Plant] = [
        Plant(
            name: "Monstera",
            imageName: "PlantExample",
            status: "Hydrated",
            wateringFrequencyDays: 3,
            nextWateringText: "In 3 days"
        ),
        Plant(
            name: "Cactus",
            imageName: "PlantExample2",
            status: "In 3 days",
            wateringFrequencyDays: 7,
            nextWateringText: "In 3 days"
        ),
        Plant(
            name: "Fern",
            imageName: "PlantExample3",
            status: "Water now!",
            wateringFrequencyDays: 2,
            nextWateringText: "Today"
        )
    ]
}
