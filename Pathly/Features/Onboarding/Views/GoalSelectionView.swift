import SwiftUI

struct GoalSelectionView: View {
    @Binding var selectedGoal: Goal
    var onNext: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Text("What's your running goal?")
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(.center)
            
            Text("We'll create a plan to help you reach it.")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 15) {
                ForEach(Goal.allCases, id: \.self) { goal in
                    GoalOptionView(goal: goal, isSelected: selectedGoal == goal) {
                        selectedGoal = goal
                    }
                }
            }
            
            Spacer()
            
            Button(action: onNext) {
                Text("Next")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .disabled(selectedGoal == nil)
        }
        .padding()
    }
}

struct GoalOptionView: View {
    let goal: Goal
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                Text(goal.displayName)
                    .foregroundColor(isSelected ? .blue : .primary)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                }
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

#Preview {
    GoalSelectionView(selectedGoal: .constant(.buildEndurance)) {
        print("Next")
    }
}