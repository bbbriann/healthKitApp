//
//  NotificationExtensions.swift
//  healthKitt
//
//  Created by brian on 8/26/24.
//

import Foundation

extension Notification.Name {
    static let loggedIn = Notification.Name("loggedIn")
    static let loggedOut = Notification.Name("loggedOut")
    static let showTabBar = Notification.Name("showTabBar")
    static let hideTabBar = Notification.Name("hideTabBar")
    static let dataRefresh = Notification.Name("dataRefresh")
}
