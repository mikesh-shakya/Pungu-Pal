import SwiftUI

struct FoodRow: View {

    let entry: FoodEntry

    var body: some View {
        HStack {

            Text(entry.name)

            Spacer()

            Text("\(entry.calories)")
                .fontWeight(.medium)
        }
    }
}
