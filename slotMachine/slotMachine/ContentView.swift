//
//  ContentView.swift
//  slotMachine
//
//  Created by emil kurbanov on 10.04.2022.
//

import SwiftUI
import Combine
// Первая версия без Timer!


private var cancellables: Set<AnyCancellable> = []
struct ContentView: View {
   // private var cancellables: Set<AnyCancellable> = []
    @State private var text1: String = "🤡"
    @State private var text2: String = "🤡"
    @State private var text3: String = "🤡"
    @State private var alertAnswer: Bool = false
     var timer = Timer.publish(every: 5.0, on: .main, in: .common)
    let arrayEmoji = ["🤪", "😎", "😜", "🥶", "😷", "🤯"]
   
       
    var body: some View {
        NavigationView {
            ZStack {
                GeometryReader { forms in
                    Image("theme2")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                        .frame(width: forms.size.width, height: forms.size.height)
                   
                    VStack {
                       
                        
                        Text(text1)
                            
                            .font(.system(size: 50))
                            .frame(width: 50, height: 50)
                            .foregroundColor(.blue)
                            .foregroundColor(.teal)
                            .padding(EdgeInsets(top: 50, leading: 150, bottom: 10, trailing: 10))
                          
                            //.frame(width: 1, height: 1)
                      //  Spacer()
                        Text(text2)
                            .font(.system(size: 50))
                            .frame(width: 50, height: 50)
                            .foregroundColor(.teal)
                            .padding(EdgeInsets(top: 50, leading: 150, bottom: 5, trailing: 10))
                            //Spacer()
                        Text(text3)
                            .font(.system(size: 50))
                            .frame(width: 50, height: 50)
                            .foregroundColor(.teal)
                            .padding(EdgeInsets(top: 50, leading: 150, bottom: 80, trailing: 10))
                        //Spacer()
                            
                        
                        Button(action: startGame) {
                            Text("Начать игру")
                                
                        }
                        
                        
                        .background(.blue)
                        .foregroundColor(.black)
                        .padding(EdgeInsets(top: 10, leading: 150, bottom: 150, trailing: 10))
                        Spacer()
                            .frame(width: 50, height: 50, alignment: .center)
                            
                           // .frame( maxWidth: 150)
                           // .textInputAutocapitalization
                
                    }
                    
                     
                    
                   
                }
            }
            .alert(isPresented: $alertAnswer) {
                Alert(title: Text("Победа!"), message: Text("Поздравляем, вы победили!!!"), dismissButton: .cancel())
            }
            .navigationBarHidden(true)
        }
       
    }
    private func startGame() {
       // DispatchQueue.main.asyncAfter(deadline: .now() + 1){
        
        text1 = arrayEmoji.randomElement() ?? " "
        text2 = arrayEmoji.randomElement() ?? " "
        text3 = arrayEmoji.randomElement() ?? " "
    if text1 == text2 && text1 == text3 {
        alertAnswer = true
        print("победа")
    } else {
        print("поражение")
    }
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
