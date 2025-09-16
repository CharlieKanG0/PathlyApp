import SwiftUI

struct WorkoutDetailView: View {
    @ObservedObject var coordinator: AppCoordinator
    
    var body: some View {
        VStack(spacing: 20) {
            // Tab view for workout sections
            TabView {
                WarmUpView()
                    .tabItem {
                        Image(systemName: "figure.walk")
                        Text("Warm-Up")
                    }
                
                RunView()
                    .tabItem {
                        Image(systemName: "figure.run")
                        Text("Run")
                    }
                
                CoolDownView()
                    .tabItem {
                        Image(systemName: "figure.walk.motion")
                        Text("Cool-Down")
                    }
            }
            .padding(.top)
            
            Spacer()
        }
        .navigationTitle("Today's Workout")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct WarmUpView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(0..<2, id: \.self) { index in
                    ExerciseCard(
                        title: index == 0 ? "Leg Swings" : "Arm Circles",
                        description: index == 0 ? "Stand upright and swing one leg forward and backward, then side to side. Repeat with the other leg." : "Extend your arms out to the sides and make small circles, gradually increasing the size.",
                        duration: "1 min"
                    )
                }
            }
            .padding()
        }
    }
}

struct RunView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Walk/Run Intervals")
                    .font(.title2)
                    .bold()
                
                Text("Repeat 3 times:")
                    .font(.headline)
                
                VStack(spacing: 10) {
                    IntervalRow(type: "Walk", duration: "2 min", color: .blue)
                    IntervalRow(type: "Run", duration: "1 min", color: .red)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                
                Text("Total time: 9 min")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
    }
}

struct CoolDownView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(0..<2, id: \.self) { index in
                    ExerciseCard(
                        title: index == 0 ? "Hamstring Stretch" : "Calf Stretch",
                        description: index == 0 ? "Sit on the ground with one leg extended and reach toward your toes. Hold for 30 seconds and switch legs." : "Stand facing a wall and place one foot behind you, pressing the heel down. Hold for 30 seconds and switch legs.",
                        duration: "1 min"
                    )
                }
            }
            .padding()
        }
    }
}

struct ExerciseCard: View {
    let title: String
    let description: String
    let duration: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(title)
                    .font(.headline)
                
                Spacer()
                
                Text(duration)
                    .font(.subheadline)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(5)
            }
            
            Text(description)
                .font(.body)
                .foregroundColor(.secondary)
            
            // Placeholder for GIF
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.2))
                .frame(height: 150)
                .overlay(
                    VStack {
                        Image(systemName: "play.circle")
                            .font(.largeTitle)
                        Text("Exercise GIF")
                            .font(.caption)
                    }
                )
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

struct IntervalRow: View {
    let type: String
    let duration: String
    let color: Color
    
    var body: some View {
        HStack {
            Text(type)
                .font(.headline)
                .foregroundColor(color)
            
            Spacer()
            
            Text(duration)
                .font(.subheadline)
        }
    }
}

#Preview {
    WorkoutDetailView(coordinator: AppCoordinator(container: AppContainer()))
}