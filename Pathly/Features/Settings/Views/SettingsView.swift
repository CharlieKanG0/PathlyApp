import SwiftUI

struct SettingsView: View {
    @ObservedObject var coordinator: AppCoordinator
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Settings")
                .font(.largeTitle)
                .bold()
            
            List {
                Section("Account") {
                    NavigationLink("Profile") {
                        Text("Profile Settings")
                    }
                    
                    NavigationLink("Subscription") {
                        Text("Subscription Details")
                    }
                }
                
                Section("Data") {
                    NavigationLink("Health Integration") {
                        Text("Health Integration Settings")
                    }
                    
                    Button("Export Data") {
                        // Export data action
                    }
                }
                
                Section("Support") {
                    Button("Contact Support") {
                        // Contact support action
                    }
                    
                    Button("FAQ") {
                        // FAQ action
                    }
                }
                
                Section("About") {
                    NavigationLink("Privacy Policy") {
                        Text("Privacy Policy")
                    }
                    
                    NavigationLink("Terms of Service") {
                        Text("Terms of Service")
                    }
                    
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                }
                
                Section("Debug") {
                    Button("Reset Onboarding", role: .destructive) {
                        resetOnboarding()
                    }
                }
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Settings")
    }
    
    private func resetOnboarding() {
        // Clear saved user and plan
        UserDefaults.standard.removeObject(forKey: "currentUser")
        UserDefaults.standard.removeObject(forKey: "user_plan")
        
        // Mark onboarding as incomplete
        coordinator.container.isFirstLaunch = true
        
        // Navigate to the onboarding screen
        coordinator.popToRoot()
    }
}

#Preview {
    SettingsView(coordinator: AppCoordinator(container: AppContainer()))
}