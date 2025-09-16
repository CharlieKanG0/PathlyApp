import SwiftUI

struct FrequencySelectionView: View {
    @Binding var selectedFrequency: Frequency
    var onNext: () -> Void
    var onBack: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Text("How often do you want to run?")
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(.center)
            
            Text("Choose how many days per week you can commit to running.")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 15) {
                ForEach(Frequency.allCases, id: \.self) { frequency in
                    FrequencyOptionView(frequency: frequency, isSelected: selectedFrequency == frequency) {
                        selectedFrequency = frequency
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
                
                Button(action: onNext) {
                    Text("Next")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .disabled(selectedFrequency == nil)
            }
        }
        .padding()
    }
}

struct FrequencyOptionView: View {
    let frequency: Frequency
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                Text(frequency.displayName)
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
    FrequencySelectionView(selectedFrequency: .constant(.threeDays)) {
        print("Next")
    } onBack: {
        print("Back")
    }
}