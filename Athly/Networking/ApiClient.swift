//
//  ApiClient.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import Foundation

//public typealias CustomClient = ProViewHockeyClient
//
//class ApiClient {
//    static var shared = ApiClient()
//
//    var client: CustomClient
//
//    init() {
//#if DEVELOPMENT
//        client = CustomClient(target: .development)
//#elseif STAGING
//        client = CustomClient(target: .staging)
//#elseif PRODUCTION
//        client = CustomClient(target: .production)
//#else
//        client = CustomClient(target: .development)
//#endif
//    }
//
//    // MARK: - Authentication
//    func isAuthenticated() -> Bool {
//        guard let authTokens = KeychainHelper.retrieve(AuthTokens.self, forKey: KeychainKeys.authTokens) else { return false }
//        client.authTokens = authTokens
//        return true
//    }
//
//    func deAuthenticate() {
//        client.authTokens = nil
//        UserProfile.removeFromUserDefaults()
//        let success = KeychainHelper.delete(forKey: KeychainKeys.authTokens)
//        print(success ? "Tokens deleted successfully" : "Failed to delete tokens")
//    }
//
//}
//
//extension Error {
//    var customErrorMessage: String? {
//        guard let error = self as? CustomError else { return nil }
//        return error.message
//    }
//
//    var customErrorCode: TRPCErrorCode? {
//        guard let error = self as? CustomError else { return nil }
//        return error.code
//    }
//
//    var customErrorData: DecodableValue? {
//        guard let error = self as? CustomError else { return nil }
//        return error.data
//    }
//}
//
//public typealias CustomError = TRPCError
//
//extension AuthTokens: Jsonable, Storable {
//    static var key: UserDefaultConstants.UserDefaultKey { .authTokens }
//}
//
//extension UserProfile: Jsonable, Storable {
//    static var key: UserDefaultConstants.UserDefaultKey { .currentUser }
//}
