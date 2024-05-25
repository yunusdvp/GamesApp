import Foundation

enum Platforms: Int, CaseIterable {
    case pc = 4
    case playstation5 = 187
    case playstation4 = 18
    case playstation3 = 16
    case playstation2 = 15
    case playstation1 = 27
    case psVita = 19
    case psp = 17
    case xboxOne = 1
    case xboxSeriesSX = 186
    case xbox360 = 14
    case xbox = 80
    case nintendoSwitch = 7
    case nintendo3DS = 8
    case nintendoDS = 9
    case nintendoDSi = 13
    case wiiU = 10
    case wii = 11
    case gameCube = 105
    case nintendo64 = 83
    case gameBoyAdvance = 24
    case gameBoyColor = 43
    case gameBoy = 26
    case snes = 79
    case nes = 49
    case ios = 3
    case android = 21
    case mac = 5
    case linux = 6
    case atari7800 = 28
    case atari5200 = 31
    case atari2600 = 23
    case atariFlashback = 22
    case atari8Bit = 25
    case atariST = 34
    case atariLynx = 46
    case atariXEGS = 50
    case jaguar = 112
    case commodoreAmiga = 166
    case segaGenesis = 167
    case segaSaturn = 107
    case segaCD = 119
    case sega32X = 117
    case segaMasterSystem = 74
    case dreamcast = 106
    case gameGear = 77
    case threeDO = 111
    case neoGeo = 12
    case web = 171

    var name: String {
        switch self {
        case .pc: return "PC"
        case .playstation5: return "PlayStation 5"
        case .playstation4: return "PlayStation 4"
        case .playstation3: return "PlayStation 3"
        case .playstation2: return "PlayStation 2"
        case .playstation1: return "PlayStation 1"
        case .psVita: return "PS Vita"
        case .psp: return "PSP"
        case .xboxOne: return "Xbox One"
        case .xboxSeriesSX: return "Xbox Series S/X"
        case .xbox360: return "Xbox 360"
        case .xbox: return "Xbox"
        case .nintendoSwitch: return "Nintendo Switch"
        case .nintendo3DS: return "Nintendo 3DS"
        case .nintendoDS: return "Nintendo DS"
        case .nintendoDSi: return "Nintendo DSi"
        case .wiiU: return "Wii U"
        case .wii: return "Wii"
        case .gameCube: return "GameCube"
        case .nintendo64: return "Nintendo 64"
        case .gameBoyAdvance: return "Game Boy Advance"
        case .gameBoyColor: return "Game Boy Color"
        case .gameBoy: return "Game Boy"
        case .snes: return "SNES"
        case .nes: return "NES"
        case .ios: return "iOS"
        case .android: return "Android"
        case .mac: return "Mac"
        case .linux: return "Linux"
        case .atari7800: return "Atari 7800"
        case .atari5200: return "Atari 5200"
        case .atari2600: return "Atari 2600"
        case .atariFlashback: return "Atari Flashback"
        case .atari8Bit: return "Atari 8-bit"
        case .atariST: return "Atari ST"
        case .atariLynx: return "Atari Lynx"
        case .atariXEGS: return "Atari XEGS"
        case .jaguar: return "Jaguar"
        case .commodoreAmiga: return "Commodore / Amiga"
        case .segaGenesis: return "Sega Genesis"
        case .segaSaturn: return "Sega Saturn"
        case .segaCD: return "Sega CD"
        case .sega32X: return "Sega 32X"
        case .segaMasterSystem: return "Sega Master System"
        case .dreamcast: return "Dreamcast"
        case .gameGear: return "Game Gear"
        case .threeDO: return "3DO"
        case .neoGeo: return "Neo Geo"
        case .web: return "Web"
        }
    }

    static func name(for id: Int) -> String? {
        return Platforms(rawValue: id)?.name
    }
}
