import Foundation
import UserNotifications

final class NotificationManager {
    private let center = UNUserNotificationCenter.current()

    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            completion(granted)
        }
    }

    func getAuthorizationStatus(completion: @escaping (Bool) -> Void) {
        center.getNotificationSettings { settings in
            completion(settings.authorizationStatus == .authorized)
        }
    }

    func scheduleDaily(hour: Int, minute: Int) {
        cancelDaily()
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute

        let content = UNMutableNotificationContent()
        content.title = "体重记录提醒"
        content.body = "别忘了记录今天的体重。"
        content.sound = UNNotificationSound.default

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let req = UNNotificationRequest(identifier: "daily_weight_reminder", content: content, trigger: trigger)

        center.add(req) { error in
            if let e = error { print("通知调度错误: \(e)") }
        }
    }

    func cancelDaily() {
        center.removePendingNotificationRequests(withIdentifiers: ["daily_weight_reminder"])
    }
}
