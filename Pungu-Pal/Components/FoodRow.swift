//
//  FoodRow.swift
//  Pungu-Pal
//
//  Created by Mikesh on 30/05/26.
//


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