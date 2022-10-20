import Foundation
import Swinject

extension Assembler {
    static let shared: Assembler = {
        let container = Container()
        let assembler = Assembler([
            AppAssembly()
        ], container: container)
        
        return assembler
    }()
    
    static func inject<Service>(_ serviceType: Service.Type, name: String? = nil) -> Service {
        Assembler.shared.resolver.resolve(serviceType, name: name)!
    }
}

@propertyWrapper struct Inject<Service> {
    private var service: Service
    
    init(named name: String? = nil) {
        self.service = Assembler.inject(Service.self, name: name)
    }
    
    var wrappedValue: Service {
        get { service }
        mutating set { service = newValue }
    }
    
    var projectedValue: Inject<Service> {
        get { self }
        mutating set { self = newValue }
    }
}
