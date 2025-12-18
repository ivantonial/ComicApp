//
//  Coordinator.swift
//  Core
//
//  Created by Ivan Tonial IP.TV on 07/10/25.
//

//import SwiftUI
//
///// Protocolo base para implementação do padrão Coordinator
//public protocol Coordinator: AnyObject {
//    associatedtype Route
//
//    func navigate(to route: Route)
//    func start() -> AnyView
//}
//
///// Protocolo para coordenadores filhos
//public protocol ChildCoordinator: Coordinator {
//    var parent: (any Coordinator)? { get set }
//}
//
///// Enum base para rotas de navegação
//public protocol NavigationRoute {
//    associatedtype Destination: View
//    func destination() -> Destination
//}
import SwiftUI

// MARK: - Coordinator Protocol

/// Protocolo base para implementação do padrão Coordinator
public protocol Coordinator: AnyObject {
    associatedtype Route

    func navigate(to route: Route)
    func start() -> AnyView
}

// MARK: - Weak Coordinator Reference

/// Wrapper para referência fraca a um Coordinator
/// Evita retain cycles na relação parent-child
///
/// Uso:
/// ```swift
/// class MyChildCoordinator: ChildCoordinator {
///     var parentRef = WeakCoordinatorRef(nil)
///
///     var parent: (any Coordinator)? {
///         get { parentRef.value }
///         set { parentRef.value = newValue }
///     }
/// }
/// ```
public final class WeakCoordinatorRef: @unchecked Sendable {
    /// Referência fraca ao coordinator
    public weak var value: (any Coordinator)?

    /// Inicializa com um coordinator opcional
    /// - Parameter coordinator: O coordinator a ser referenciado (weak)
    public init(_ coordinator: (any Coordinator)? = nil) {
        self.value = coordinator
    }

    /// Verifica se a referência ainda é válida
    public var isValid: Bool {
        value != nil
    }
}

// MARK: - Child Coordinator Protocol

/// Protocolo para coordenadores filhos
///
/// ⚠️ IMPORTANTE: Implementações DEVEM usar `WeakCoordinatorRef` para a propriedade `parentRef`
/// para evitar retain cycles. A propriedade `parent` é um computed property que acessa `parentRef.value`.
///
/// Exemplo de implementação correta:
/// ```swift
/// final class DetailCoordinator: ChildCoordinator {
///     typealias Route = DetailRoute
///
///     // ✅ Usa WeakCoordinatorRef para evitar retain cycle
///     public var parentRef = WeakCoordinatorRef(nil)
///
///     // Computed property para acesso conveniente
///     public var parent: (any Coordinator)? {
///         get { parentRef.value }
///         set { parentRef.value = newValue }
///     }
///
///     func navigate(to route: DetailRoute) { ... }
///     func start() -> AnyView { ... }
/// }
/// ```
public protocol ChildCoordinator: Coordinator {
    /// Referência fraca ao coordinator pai
    /// Use `WeakCoordinatorRef` na implementação para evitar retain cycles
    var parentRef: WeakCoordinatorRef { get set }

    /// Acesso conveniente ao parent coordinator
    /// Implementação padrão fornecida via extension
    var parent: (any Coordinator)? { get set }
}

// MARK: - ChildCoordinator Default Implementation

public extension ChildCoordinator {
    /// Implementação padrão que acessa o valor do WeakCoordinatorRef
    var parent: (any Coordinator)? {
        get { parentRef.value }
        set { parentRef.value = newValue }
    }
}

// MARK: - Navigation Route Protocol

/// Enum base para rotas de navegação
public protocol NavigationRoute {
    associatedtype Destination: View
    func destination() -> Destination
}
