import CoreData
import UIKit

class DummyDataManager {
    
    //싱글톤 패턴(앱 전체에서 인스턴스를 공유할 수 있도록)
    static let shared = DummyDataManager()
    
    //Core Data 작업을 위해서 context를 가져온다.
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private init() {}
    
    func insertKickboardDummyData() {
        let fetchRequest: NSFetchRequest = KickboardEntity.fetchRequest()
        
        do {
            let count = try context.count(for: fetchRequest)
            if count == 0 {
                let kickboard1 = KickboardEntity(context: context)
                kickboard1.kickboardID = "kickboard_001"
                kickboard1.latitude = 35.836
                kickboard1.longitude = 129.219
                kickboard1.battery = 100
                kickboard1.userID = kickboard1.kickboardID
                
                let kickboard2 = KickboardEntity(context: context)
                kickboard2.kickboardID = "kickboard_002"
                kickboard2.latitude = 35.838
                kickboard2.longitude = 129.216
                kickboard2.battery = 70
                kickboard2.userID = kickboard2.kickboardID

                
                let kickboard3 = KickboardEntity(context: context)
                kickboard3.kickboardID = "kickboard_003"
                kickboard3.latitude = 35.841
                kickboard3.longitude = 129.220
                kickboard3.battery = 90
                kickboard3.userID = kickboard3.kickboardID
                
                let kickboard4 = KickboardEntity(context: context)
                kickboard4.kickboardID = "kickboard_004"
                kickboard4.latitude = 35.829
                kickboard4.longitude = 129.210
                kickboard4.battery = 40
                kickboard4.userID = kickboard4.kickboardID
                
                let kickboard5 = KickboardEntity(context: context)
                kickboard5.kickboardID = "kickboard_005"
                kickboard5.latitude = 35.836
                kickboard5.longitude = 129.215
                kickboard5.battery = 70
                kickboard5.userID = kickboard5.kickboardID
                
                let kickboard6 = KickboardEntity(context: context)
                kickboard6.kickboardID = "kickboard_006"
                kickboard6.latitude = 35.835
                kickboard6.longitude = 129.222
                kickboard6.battery = 85
                kickboard6.userID = kickboard6.kickboardID
                
                let kickboard7 = KickboardEntity(context: context)
                kickboard7.kickboardID = "kickboard_007"
                kickboard7.latitude = 35.834
                kickboard7.longitude = 129.223
                kickboard7.battery = 60
                kickboard7.userID = kickboard7.kickboardID
                
                let kickboard8 = KickboardEntity(context: context)
                kickboard8.kickboardID = "kickboard_008"
                kickboard8.latitude = 35.831
                kickboard8.longitude = 129.214
                kickboard8.battery = 55
                kickboard8.userID = kickboard8.kickboardID
                
                let kickboard9 = KickboardEntity(context: context)
                kickboard9.kickboardID = "kickboard_009"
                kickboard9.latitude = 35.838
                kickboard9.longitude = 129.212
                kickboard9.battery = 30
                kickboard9.userID = kickboard9.kickboardID
                
                try context.save()
                print("더미 데이터 삽입 완료")
            } else {
                print("더미 데이터 이미 존재")
            }
        } catch {
            print("더미 데이터 삽입 실패: \(error)")
        }
    }
    
    
}
