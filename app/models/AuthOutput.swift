//
//  AuthOutput.swift
//  App
//
//  Created by Amir Hossein on 6/15/19.
//

import Foundation

final class AuthOutput : Codable {
    let token: Token
    let isAdmin: Bool
}
