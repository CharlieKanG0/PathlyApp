import SwiftUI

struct HomeView: View {
    @ObservedObject var coordinator: AppCoordinator
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Text("Today's Run")
                    .font(.largeTitle)
                    .bold()
                
                // Next workout card
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Text("Next Workout")
                            .font(.headline)
                        
                        Spacer()
                        
                        Text("Today")
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(5)
                    }
                    
                    Text("Run/Walk Intervals")
                        .font(.title2)
                        .bold()
                    
                    Text("25 min • Beginner")
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Spacer()
                        Image(systemName: "figure.run")
                            .font(.largeTitle)
                            .foregroundColor(.blue)
                        Spacer()
                    }
                    .padding(.vertical)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                .onTapGesture {
                    coordinator.navigate(to: .workoutDetail)
                }
                
                Spacer()
                
                // Progress section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Your Progress")
                        .font(.headline)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("0")
                                .font(.title)
                                .bold()
                            Text("Runs Completed")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("0")
                                .font(.title)
                                .bold()
                            Text("Total Days")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
            }
            .padding()
            .navigationTitle("Pathly")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        coordinator.navigate(to: .settings)
                    }) {
                        Image(systemName: "gear")
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView(coordinator: AppCoordinator(container: AppContainer()))
}