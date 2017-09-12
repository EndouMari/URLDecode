//: Playground - noun: a place where people can play

import Foundation

extension String {
    public var decodeShiftJIS: String? {
        var byteArray: [UInt8] = []
        let stringArray: [String] = characters.map { String($0) }
        var index: Int = 0
        while index < stringArray.count {
            let char: String = stringArray[index]
            if char == "%" , (index + 2) < stringArray.count {
                // 「%」が来たら続く2文字を16進数として数値に変換してバイト配列に入れる
                let towChar = stringArray[index+1...index+2].joined()
                if let charCode = UInt8(towChar, radix: 16) {
                    byteArray.append(charCode)
                    index += 3
                }
            } else if char == "+", let hexValue = " ".utf8.first {
                //「+」は半角スペース
                byteArray.append(hexValue)
                index += 1
            } else if let charCode = Array(char.utf8).first {
                //「%」ではない場合は文字コードをそのまま配列に入れる
                byteArray.append(charCode)
                index += 1
            }
        }

        if let decodedString = NSString(bytes: UnsafePointer(byteArray),
                                        length: byteArray.count,
                                        encoding: String.Encoding.shiftJIS.rawValue) {
            return String(decodedString)
        }
        return nil
    }
}
