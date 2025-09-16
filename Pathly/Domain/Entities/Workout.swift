import Foundation

struct Workout: Codable {
    let id: UUID
    let date: Date
    let warmUp: [Exercise]
    let run: RunSegment
    let coolDown: [Exercise]
    let isCompleted: Bool
    
    init(date: Date, warmUp: [Exercise], run: RunSegment, coolDown: [Exercise]) {
        self.id = UUID()
        self.date = date
        self.warmUp = warmUp
        self.run = run
        self.coolDown = coolDown
        self.isCompleted = false
    }
}

struct RunSegment: Codable {
    let intervals: [Interval]
    
    init(intervals: [Interval]) {
        self.intervals = intervals
    }
}

struct Interval: Codable {
    let duration: TimeInterval
    let type: IntervalType
    
    init(duration: TimeInterval, type: IntervalType) {
        self.duration = duration
        self.type = type
    }
}

enum IntervalType: String, Codable {
    case walk
    case run
}

struct Exercise: Codable {
    let name: String
    let description: String
    let duration: TimeInterval
    let gifName: String? // Name of the GIF asset
    
    init(name: String, description: String, duration: TimeInterval, gifName: String? = nil) {
        self.name = name
        self.description = description
        self.duration = duration
        self.gifName = gifName
    }
}