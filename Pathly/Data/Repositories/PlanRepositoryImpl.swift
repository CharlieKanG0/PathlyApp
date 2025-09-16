import Foundation

class PlanRepositoryImpl: PlanRepository {
    private let userDefaults = UserDefaults.standard
    private let planKey = "user_plan"
    
    func savePlan(_ plan: Plan) async throws {
        let data = try JSONEncoder().encode(plan)
        userDefaults.set(data, forKey: planKey)
    }
    
    func getPlan(for userId: UUID) async throws -> Plan? {
        guard let data = userDefaults.data(forKey: planKey) else {
            return nil
        }
        let plan = try JSONDecoder().decode(Plan.self, from: data)
        return plan.userId == userId ? plan : nil
    }
    
    func updatePlan(_ plan: Plan) async throws {
        try await savePlan(plan)
    }
}