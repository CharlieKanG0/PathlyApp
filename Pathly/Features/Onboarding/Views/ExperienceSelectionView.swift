import SwiftUI

struct ExperienceSelectionView: View {
    @Binding var selectedExperience: Experience
    var onFinish: () -> Void
    var onBack: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Text("What's your running experience?")
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(.center)
            
            Text("This helps us create the right starting point for you.")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 15) {
                ForEach(Experience.allCases, id: \.self) { experience in
                    ExperienceOptionView(experience: experience, isSelected: selectedExperience == experience) {
                        selectedExperience = experience
                    }
                }
            }
            
            Spacer()
            
            HStack {
                Button(action: onBack) {
                    Text("Back")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                }
                
                Button(action: onFinish) {
                    Text("Finish")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .disabled(selectedExperience == nil)
            }
        }
        .padding()
    }
}

struct ExperienceOptionView: View {
    let experience: Experience
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(experience.displayName)
                        .font(.headline)
                        .foregroundColor(isSelected ? .blue : .primary)
                    
                    Spacer()
                    
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.blue)
                    }
                }
                
                Text(experience.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(isSelected ? Color.blue.opacity(0.1) : Color.clear)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? Color.blue : Color.gray.opacity(0.3), lineWidth: 1)
            )
        }
    }
}

extension Experience {
    var description: String {
        switch self {
        case .beginner:
            return "I'm new to running or getting back into it"
        case .intermediate:
            return "I run regularly but want to improve"
        case .advanced:
            return "I'm an experienced runner with specific goals"
        }
    }
}

#Preview {
    ExperienceSelectionView(selectedExperience: .constant(.beginner)) {
        print("Finish")
    } onBack: {
        print("Back")
    }
}