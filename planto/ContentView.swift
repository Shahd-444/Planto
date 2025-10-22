//
//  ContentView.swift
//  planto
//
//  Created by Shahd Muharrq on 26/04/1447 AH.
//

import SwiftUI

struct ContentView: View {
    
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                Divider()
                    .frame(height: 1)
                    .frame(width: 300)
                
                MainContent()
                
                Spacer().frame(height: 37)
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .preferredColorScheme(.dark)
            .navigationTitle("My Plants 🌱")
        }

        
        
    }
    
    struct MainContent:View {
        @State private var isSheetPresented = false
        
        var body: some View {
            VStack {
                Spacer().frame(height: 37)
                Image("planto")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                Spacer().frame(height: 37)
                VStack{ Text("Start your planto journey!")
                        .font(.title2)
                        .bold()
                    .foregroundColor(Color.white)}
                
                Spacer().frame(height: 20)
                HStack (alignment: .center){ Text("Now all your plants will be in one place and we will help you to take care of them :) 🪴")
                        .font(.subheadline)
                        .foregroundColor(Color.gray)
                        .multilineTextAlignment(.center)
                    .padding(.horizontal)}
                
                Spacer().frame(height: 107)
                GlassEffectContainer{
                    Button( "Set Plant Reminders") {
                        isSheetPresented = true
                        
                    }
                    .font(.headline)
                    .bold()
                    .frame( width: 280, height: 44 )
                    .shadow(radius: 6, y: 3)
                    //                    .background(Color.lightGreen)
                    .foregroundColor(Color.white)
                    .cornerRadius(60)
                    .sheet(isPresented: $isSheetPresented) {
                        RontentView()
                    }
                    
                    
                }.glassEffect(.regular.tint(Color.lightGreen.opacity(0.65)).interactive())
            }
            
        }
    }
}
    #Preview {
        ContentView()
    }
    

