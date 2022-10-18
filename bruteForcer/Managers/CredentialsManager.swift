import Foundation

protocol CredentialsManager {
    func persist(words: [String], alphabet: [String])
    func loadWordsAlphabet() -> ([String], [String])
}

struct CredentialsManagerImpl: CredentialsManager {
    enum Constants {
        static let userDefaultsKey = "brute.force.task."
        static let userDefaultsWordsKey = userDefaultsKey + "words"
        static let userDefaultsAlphabetKey = userDefaultsKey + "alphabet"
    }

    func persist(words: [String], alphabet: [String]) {
        UserDefaults.standard.set(words, forKey: Constants.userDefaultsWordsKey)
        UserDefaults.standard.set(alphabet, forKey: Constants.userDefaultsAlphabetKey)
    }

    func loadWordsAlphabet() -> ([String], [String]) {
        let words = UserDefaults.standard.object(forKey: Constants.userDefaultsWordsKey) as? [String]
        let alphabet = UserDefaults.standard.object(forKey: Constants.userDefaultsAlphabetKey) as? [String]
        return (words ?? [], alphabet ?? [])
    }
}
