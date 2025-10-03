//
//  TittleView.swift
//  lobo1
//
//  Created by alumno on 16/1/25.
//


import SwiftUI

struct EncabezadoApp: View {
    var body: some View {
        HStack {
            Spacer()
            
            Text("Crypto")
                .font(.custom("Avenir-Black", size: 28))
                .foregroundColor(.red)
                +
            Text("Tracker")
                .font(.custom("Avenir-Black", size: 28))
                .foregroundColor(.black)
                
            Spacer()
        }
        .padding()
        Divider()
        Spacer()
    }
}
