//
//  MoreViewModel.swift
//  app
//
//  Created by Hamed Ghadirian on 27.10.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation
import KeychainSwift
import Apollo

class MoreViewModel {
    let keychain = KeychainSwift()

    func isLogedin() -> Bool {
        if let _=keychain.get(AppConst.KeyChain.Authorization) {
            return true
        }
        return false
    }

    func isAdmin() -> Bool {
        return keychain.getBool(AppConst.KeyChain.IsAdmin) ?? false
    }

    func getVersionBuildNo() -> String {
        let dic = Bundle.main.infoDictionary!
        let version = (dic["CFBundleShortVersionString"] as? String) ?? "get version failed"
        let buildNumber = (dic["CFBundleVersion"] as? String) ?? "get buildNumber failed"

        return version+"("+buildNumber+")"
    }

    // MARK: : GraphQL
    let apollo: ApolloClient = {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Authorization": "Bearer \(GithubConstants.Token)"]

        let endPointUrl = URL(string: GithubConstants.EndPoint)

        return ApolloClient(networkTransport: HTTPNetworkTransport(url: endPointUrl!, configuration: config))
    }()

    func getRepoInfo() {
        let userInfo = UserInfoQuery()
        apollo.fetch(query: userInfo) { (result, error) in
            print("RepoInfo:")
            if let error = error {
                print(error)
                return
            }

            guard let name = result?.data?.user?.name else {
                print("no name")
                return
            }
            print("name: \(name)")

            guard let repos = result?.data?.user?.repositories.edges else {
                print("no repo")
                return
            }
            print("Repositories:")
            for rep in repos {
                if let name = rep?.node?.name {
                    print(name)
                }
            }
        }
    }
}
