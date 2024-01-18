import SwiftUI

struct ContentView: View {
    @State private var currentStage = 0
    
    let titleGradient = LinearGradient(colors: [.pink, .brown, .red], startPoint: .bottomLeading, endPoint: .topTrailing)
    
    
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
                Text("Welcome to Better Talk!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle( titleGradient )
                    .padding()
                
                
                Text("Presenting, Public Speaking and Communicating can be hard (and scary) but we're going to make it a bit easier")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding()
                
                VStack{
                    Text("\(welcomeMessage())")
                        .font(.title2)
                       // .fontWeight(.bold)
                        .padding([.top,.leading,.trailing])

                    
                    Text("Polish Up Those Fundamentals? or Dive Straight Into Practice?")
                        .font(.title3)
                        .fontWeight(.bold)
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
            .padding()
            .glass(cornerRadius: 20.0)
            
        }
    }
    
    private func welcomeMessage() -> String {
        return """
        This interactive playground is designed to help you enhance your public speaking and communication skills. Here's how you can use it:

        - Explore the Voice Fundamentals: Learn about key elements like filler words, rate of speech, volume, pitch, and pauses.
        - Practice Makes Perfect: Record your speech and get instant feedback on your speaking style.
        - Customize Your Experience: Tailor the speech analysis to focus on specific areas you want to improve.

        Dive in and start improving your speaking skills today!
        """
    }

    
}

