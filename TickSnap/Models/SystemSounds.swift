import AudioToolbox

enum SystemSounds: UInt32, CaseIterable, Identifiable {
    case chime = 1005
    case glass = 1054
    case horn = 1110
    case bell = 1013
    case anticipate = 1020
    case bloom = 1021
    case calypso = 1022
    case chooChoo = 1023
    case descent = 1024
    case fanfare = 1025
    case ladder = 1026
    case minuet = 1027
    case newsFlash = 1028
    case noir = 1029
    case sherwood = 1030
    case spell = 1031
    case suspense = 1032
    case telegraph = 1033
    case tidy = 1034
    case typewriters = 1035
    case update = 1036
    
    var id: UInt32 { rawValue }
    
    var displayName: String {
        switch self {
        case .chime: return "Chime"
        case .glass: return "Glass"
        case .horn: return "Horn"
        case .bell: return "Bell"
        case .anticipate: return "Anticipate"
        case .bloom: return "Bloom"
        case .calypso: return "Calypso"
        case .chooChoo: return "Choo Choo"
        case .descent: return "Descent"
        case .fanfare: return "Fanfare"
        case .ladder: return "Ladder"
        case .minuet: return "Minuet"
        case .newsFlash: return "News Flash"
        case .noir: return "Noir"
        case .sherwood: return "Sherwood"
        case .spell: return "Spell"
        case .suspense: return "Suspense"
        case .telegraph: return "Telegraph"
        case .tidy: return "Tidy"
        case .typewriters: return "Typewriters"
        case .update: return "Update"
        }
    }
}
