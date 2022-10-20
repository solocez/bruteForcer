import Foundation

protocol CredentialsManager {
    func persist(target host: URL)
    func persist(words: [String], alphabet: [String])

    func loadHost() -> URL?
    func loadWordsAlphabet() -> ([String], [String])

    func wipeAllRecords()
}

struct CredentialsManagerImpl: CredentialsManager {
    enum Constants {
        static let userDefaultsKey = "brute.force.task."
        static let userDefaultsHostKey = userDefaultsKey + "host"
        static let userDefaultsWordsKey = userDefaultsKey + "words"
        static let userDefaultsAlphabetKey = userDefaultsKey + "alphabet"
    }

    func persist(target host: URL) {
        UserDefaults.standard.set(host, forKey: Constants.userDefaultsHostKey)
        UserDefaults.standard.synchronize()
    }

    func loadHost() -> URL? {
        UserDefaults.standard.url(forKey: Constants.userDefaultsHostKey)
    }

    func persist(words: [String], alphabet: [String]) {
        UserDefaults.standard.set(words, forKey: Constants.userDefaultsWordsKey)
        UserDefaults.standard.set(alphabet, forKey: Constants.userDefaultsAlphabetKey)
        UserDefaults.standard.synchronize()
    }

    func loadWordsAlphabet() -> ([String], [String]) {
        let words = UserDefaults.standard.object(forKey: Constants.userDefaultsWordsKey) as? [String]
        let alphabet = UserDefaults.standard.object(forKey: Constants.userDefaultsAlphabetKey) as? [String]
        return (words ?? [], alphabet ?? [])
    }

    func wipeAllRecords() {
        UserDefaults.standard.removeObject(forKey: Constants.userDefaultsHostKey)
        UserDefaults.standard.removeObject(forKey: Constants.userDefaultsWordsKey)
        UserDefaults.standard.removeObject(forKey: Constants.userDefaultsAlphabetKey)
        UserDefaults.standard.synchronize()
    }
}
