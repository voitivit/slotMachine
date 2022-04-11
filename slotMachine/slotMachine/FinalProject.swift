//
//  FinalProject.swift
//  slotMachine
//
//  Created by emil kurbanov on 11.04.2022.
//

import SwiftUI
import Combine

// Версия с таймером!
class GamesModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
   private let arrayEmoji = ["🤪", "😎", "😜", "🥶", "😷", "🤯"]
    private var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    init() {
        timer
            .receive(on: RunLoop.main)
            .sink { _ in self.random() }
            .store(in: &cancellables)
        
        $run
            .receive(on: RunLoop.main)
            .map {
                guard !$0 && self.startGame else {return "Давайте играть!"}
                return self.textSlot1 == self.textSlot2 && self.textSlot1 == self.textSlot3 ? "Поздравялем, вы победили" : "Попробуйте еще раз!"
            }
            .assign(to: \.textTitle, on: self)
            .store(in: &cancellables)
        
        $run
            .receive(on: RunLoop.main)
            .map { $0 == true ? "⏹" : "▶️" }
            .assign(to: \.buttonText, on: self)
            .store(in: &cancellables)
    }
    private func random() {
        // поставить guard,чтобы  он был остановлен !!! 
        guard run else {return}
        textSlot1 = arrayEmoji.randomElement() ?? ""
        textSlot2 = arrayEmoji.randomElement() ?? ""
        textSlot3 = arrayEmoji.randomElement() ?? ""
        // второй способ подглючивает?? проверить позже
        /*textSlot1 = arrayEmoji[Int.random(in: 0...arrayEmoji.count - 1)]
        textSlot2 = arrayEmoji[Int.random(in: 0...arrayEmoji.count - 1)]
        textSlot3 = arrayEmoji[Int.random(in: 0...arrayEmoji.count - 1)]*/
    }
    
    @Published var run: Bool = false
    @Published var startGame = false
    
    @Published var textSlot1: String = "🤡"
    @Published var textSlot2: String = "🤡"
    @Published var textSlot3: String = "🤡"
    @Published var textTitle = ""
    @Published var buttonText = ""
        
    
    
}
struct Slot <Content: View>: View {
    var content: () -> Content
    init(@ViewBuilder content: @escaping () -> Content) { self.content = content }
    
    var body: some View {
        content()
            .font(.system(size: 80))
        // посмотреть про новые анимации
            .animation(.easeIn(duration: 1.5))
            .id(UUID())
    }
}

struct FinalProject: View {
    @ObservedObject private var gameMod = GamesModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                GeometryReader { forms in
                    Image("theme2")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                        .frame(width: forms.size.width, height: forms.size.height)
                   
                   
    }
                VStack {
                    Spacer()
                    Text(gameMod.textTitle)
                    Spacer()
                    
                    HStack {
                        Slot { Text(gameMod.textSlot1) }
                        Slot { Text(gameMod.textSlot2) }
                        Slot { Text(gameMod.textSlot3) }
                    }
                    Spacer()
                    Button(action: {gameMod.run.toggle(); gameMod.startGame = true}, label: {
                        Text(gameMod.buttonText)
                    })
                        .font(.system(size: 80))
                        //.frame(width: 84, height: 84, alignment: .top)
                        //.background(.clear)
                       // .foregroundColor(.black)
                        // .background().shadow(color: .red, radius: 20.0, x: 10, y: 10)
                }
            }
        }
    }
}
struct FinalProject_Previews: PreviewProvider {
    static var previews: some View {
        FinalProject()
    }
}
