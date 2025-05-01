//렌탈 여부 확인하는 메서드 싱글톤으로 만듦
import CoreData
import UIKit

final class RentalManager {
    static let shared = RentalManager()
    private init() {}

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    func checkUserIsRenting() -> Bool {
        let request: NSFetchRequest<RentalHistoryEntity> = RentalHistoryEntity.fetchRequest()
        let userID = UserDefaults.standard.string(forKey: "userID") ?? ""

        request.predicate = NSPredicate(format: "userID == %@ AND returnDate == nil", userID)

        do {
            let result = try context.fetch(request)
            return !result.isEmpty
        } catch {
            print("대여 상태 확인 실패")
            return false
        }
    }
}
