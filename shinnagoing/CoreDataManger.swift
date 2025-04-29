import CoreData
import UIKit

final class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
                print("저장 성공")
            } catch {
                print("저장 실패: \(error)")
            }
        }
    }
}
