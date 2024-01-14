import SwiftUI

struct ContentView: View {
    @State private var currentStage = 0
    
    let titleGradient = LinearGradient(colors: [.pink,.cyan,.mint], startPoint: .bottomLeading, endPoint: .topTrailing)
    
    
    let backgroundGradient = LinearGradient(colors: [.indigo, .accentColor], startPoint: .topLeading, endPoint: .bottomTrailing)
    @State private var animateGradient = false
    
    
    
    var body: some View {
        
        ZStack{
            
            backgroundGradient
                .ignoresSafeArea()
                .hueRotation(.degrees(animateGradient ? 0 : 45))
                .animation(.easeInOut(duration: 5.0).repeatForever(autoreverses: true), value: animateGradient)
                .onAppear {
                    withAnimation {
                        animateGradient.toggle()
                    }
                }
            
            
            VStack {
                Text("Let's Make You The Best!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle( titleGradient )
                    .padding()
                
                
                Text("Presenting, Public Speaking and Communicating can be hard (and scary) but we're going to make it a bit easier")
                    .font(.title2)
                    .padding()
                
                VStack{
                    Text("What Are We Doing?")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                    
                    Text("Your voice is an instrument")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding([.top,.leading,.trailing])
                    
                    Text("Likewise, practice makes perfect!")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding([.top,.leading,.trailing])
                    
                    Text("Let's Polish Up Those Fundamentals or Would You Like To Dive Straight Into Practice")
                        .font(.title2)
                        .padding()
                    
                    HStack{
                        FundamentalsButtonView()
                        
                        Image(systemName: "arrow.left.circle.fill")
                        Text("Please Pick One")
                        Image(systemName: "arrow.right.circle.fill")
                        
                        PracticeButtonView()
                    }.padding()
                    
                }
            }
            
        }
    }
}
