import Foundation

protocol PlanRepository {
    func savePlan(_ plan: Plan) async throws
    func getPlan(for userId: UUID) async throws -> Plan?
    func updatePlan(_ plan: Plan) async throws
}