import Foundation

struct Workout: Codable, Hashable {
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

    public static func == (lhs: Workout, rhs: Workout) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct RunSegment: Codable, Hashable {
    let intervals: [Interval]
    
    init(intervals: [Interval]) {
        self.intervals = intervals
    }
}

struct Interval: Codable, Hashable {
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

struct Exercise: Codable, Hashable {
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

    public static func == (lhs: Exercise, rhs: Exercise) -> Bool {
        lhs.name == rhs.name && lhs.duration == rhs.duration
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(duration)
    }
}