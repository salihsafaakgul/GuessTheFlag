//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by salih on 14.02.2024.
//

import SwiftUI

struct FlagImage:View{
    var number:Int
    var countries:[String]
    var body: some View {
        Image(countries[number])
            .clipShape(.capsule)
            .shadow(radius: 10)
            .padding(10)
    }
}

struct ContentView: View {
    @State var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"]
    
    @State var correctAnswer = Int.random(in: 0...2)
    @State var Score = 0
    @State var scoreTitle = ""
    @State var showAlert = false
    @State var newGameAlert = false
    @State var rotationDegree = 0.0

    @State var round = 0
    
    var body: some View {
        
        ZStack {
            RadialGradient(stops: [
                Gradient.Stop(color: .blue, location: 0.3),
                Gradient.Stop(color: .red, location: 0.3)
                                  
            ], center: .top ,startRadius: 100,endRadius: 700)
            
            VStack {
                Spacer()
                Text("Guess the Flag").font(.largeTitle.bold()).foregroundStyle(.white)
                
                VStack {
                    Text("Tap the flag of")
                        .foregroundStyle(.black)
                        .font(.subheadline.weight(.heavy))
                    Text("\(countries[correctAnswer])")
                        .foregroundStyle(.black)
                        .font(.largeTitle.weight(.semibold))
                    
                    VStack {
                        ForEach(0..<3){ number in
                            Button{
                                CheckCorrection(number)
                                withAnimation{
                                    rotationDegree += 360
                                }
                            }label: {
                                FlagImage(number: number, countries: countries)
                                    .rotation3DEffect( .degrees(rotationDegree), axis: (x:0.0,y:1.0,z:0.0))
    
                            }.alert(scoreTitle,isPresented: $showAlert){
                                Button("Continue",action: newGame)
                            }
                            }.alert("Your score is \(Score)", isPresented: $newGameAlert){
                                Button("Start a new game",action: newGame)
                            }
                    }
                    
                }.frame(maxWidth: .infinity)
                    .padding(.vertical, 30)
                    .background(.regularMaterial)
                    .clipShape(.rect(cornerRadius: 30))
                    .padding(.horizontal, 10)
                Spacer()
                Text("\(round)/8").font(.largeTitle.weight(.bold)).foregroundStyle(.white)
                Spacer()
                
            }
        }
    }
    func CheckCorrection(_ number:Int){
        round += 1
        if round == 9 {
            newGameAlert = true
            round = 0
        }
        if(number == correctAnswer){
            scoreTitle = "Correct"
            Score += 1
        }
        else {
            scoreTitle = "Wrong! \n That’s the flag of \(countries [number])"
            Score = 0
        }
        showAlert = true
    }
    
    func newGame(){
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        showAlert = false
    }
}

#Preview {
    ContentView()
}
