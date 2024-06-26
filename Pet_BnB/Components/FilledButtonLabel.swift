//
//  SwiftUIView.swift
//  Pet_BnB
//
//  Created by Kristian Thun on 2024-05-15.
//

import SwiftUI

struct FilledButtonLabel: View {
    var text: String
    
    var body: some View {
        Text(text)
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .padding(.vertical, 10)
            .background(AppColors.mainAccent)
            .cornerRadius(20)
            .fontWeight(.bold)
          
    }
}

#Preview {
    FilledButtonLabel(text: "test")
}
