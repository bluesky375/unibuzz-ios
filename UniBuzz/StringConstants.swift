//
//  StringConstants.swift
//  UniBuzz
//
//  Created by MobikasaNight on 29/10/19.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
  

struct StringConstants {
    static let appName = "UniBuzz"
    static let notifications = "Notifications"
    static let titleMessage = "Please enter title"
    static let titleLength = "Please provide tile with 5 or more characters"
    static let eventType = "Please select event type"
    static let eventDate = "Please select event date"
    static let noteType = "Please select Note"
    static let selectFile = "Please select File"
    static let selectIcon = "Please select Icon"
}

extension String {
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    func isBlank() -> Bool {
        return self.trim().isEmpty
    }
}

enum GroupOptionType {
    case MyGroup
    case leaveGroup
    case JoinGroup
    case CancelRequest
}
