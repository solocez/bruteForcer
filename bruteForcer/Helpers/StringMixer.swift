import Foundation

struct StringMixer {

    private let initial: String

    init(initial: String) {
        self.initial = initial
    }

    func mixWith(content: [String], variantHandler: (String) -> Bool ) {
        content.forEach { item in
            if mixWith(word: item, variantHandler: variantHandler) { return }
        }
    }
}

private extension StringMixer {
    func mixWith(word: String, variantHandler: (String) -> Bool) -> Bool {
        for (index, _) in initial.enumerated() {
            for (_, charInner) in word.enumerated() {
                let variant = initial.replace(index, charInner)
                if variantHandler(variant) { return true }
            }
        }
        return false
    }
}
