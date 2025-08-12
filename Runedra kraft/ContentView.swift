import SwiftUI


@available(iOS 15.0, *)
struct ContentView: View {
    let systems = [
        ("Ironhollow Frostshriek", "snowflake", Color.blue, "frostshriek"),
        ("Jewelcrest Sylverwane", "diamond.fill", Color.teal, "sylverwane"),
        ("Nightveil Duskwhisper", "moon.stars.fill", Color.purple, "duskwhisper"),
        ("Quantum Infusion Nexus", "atom", Color.indigo, "quantum")
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient (works since iOS 13)
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.purple.opacity(0.2)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)
                
                // Main content
                ScrollView {
                    VStack(spacing: 20) {
                        HeaderView()
                        
                        ForEach(systems, id: \.0) { system in
                            NavigationLink(destination: destinationView(for: system.3)) {
                                SystemCard(name: system.0, icon: system.1, color: system.2)
                            }
                            .buttonStyle(ScaleButtonStyle())
                        }
                    }
                    .padding()
                }
            }
            .navigationBarTitle("", displayMode: .inline)
        }
    }
    
    @ViewBuilder
    private func destinationView(for identifier: String) -> some View {
        switch identifier {
        case "frostshriek":
            IronhollowFrostshriekView()
        case "sylverwane":
            JewelcrestSylverwaneView()
        case "duskwhisper":
            NightveilDuskwhisperView()
        case "quantum":
            QuantumInfusionView()
        default:
            EmptyView()
        }
    }
}

// Supporting Views

struct HeaderView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Runedra Kraft")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary) // Simple color for iOS 13
            
            Text("Select a system to interface")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 20)
    }
}

struct SystemCard: View {
    let name: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(
                    Circle()
                        .fill(color)
                        .shadow(color: color.opacity(0.5), radius: 5, x: 0, y: 3)
                )
                .padding(.trailing, 10)
            
            Text(name)
                .font(.headline) // Using headline instead of title3 for iOS 13
                .fontWeight(.medium)
                .foregroundColor(.primary)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemBackground)) // Solid background for iOS 13
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.primary.opacity(0.1), lineWidth: 1)
        )
    }
}

struct ScaleButtonStyle1: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .opacity(configuration.isPressed ? 0.9 : 1)
            .animation(.easeInOut(duration: 0.2)) // Simple animation for iOS 13
    }
}
@available(iOS 15.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
