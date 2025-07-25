//

import Factory
import SwiftData
import Testing

// MARK: - BaseTestCase
class BaseTestCase: @unchecked Sendable {
    // MARK: Properties
    var mockAuthManager: MockAuthManager!
    var mockUserService: MockUserService!
    var mockAuthService: MockAuthService!

    // MARK: Lifecycle
    @MainActor
    init() {
        setupDoubles()
        setUpFactoryContainers()
    }

    deinit {
        tearDownDoubles()
    }
}

// MARK: - Doubles
extension BaseTestCase {
    private func setupDoubles() {
        mockUserService = MockUserService()
        mockAuthService = MockAuthService(user: mockUserService)
        mockAuthManager = MockAuthManager()
    }

    private func setUpFactoryContainers() {
        Container.shared.reset()
        Container.shared.authManager.register { self.mockAuthManager }
        Container.shared.authService.register { self.mockAuthService }
    }

    /// Clear all doubles present in the project.
    private func tearDownDoubles() {
        mockAuthManager = .none
        mockUserService = .none
        mockAuthService = .none
    }
}
