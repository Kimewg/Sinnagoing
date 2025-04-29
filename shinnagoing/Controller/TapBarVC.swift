import UIKit

class TabBarVC: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setValue(CustomTabBar(), forKey: "tabBar")
        configureTabBar()
        setupTabBarAppearance()
    }

    private func configureTabBar() {
        // Map
        let mapVC = MapVC()
        let nav1 = UINavigationController(rootViewController: mapVC)
        nav1.tabBarItem = UITabBarItem(
            title: "지도",
            image: UIImage(systemName: "map"),
            selectedImage: UIImage(systemName: "map.fill"))

        // Second
        let addBoardVC = AddBoardVC()
        let nav2 = UINavigationController(rootViewController: addBoardVC)
        nav2.tabBarItem = UITabBarItem(
            title: "킥보드 추가",
            image: UIImage(systemName: "scooter"),
            selectedImage: UIImage(systemName: "scooter.fill")
        )

        // Third
        let myPageVC = MyPageVC()
        let nav3 = UINavigationController(rootViewController: myPageVC)
        nav3.tabBarItem = UITabBarItem(
            title: "마이페이지",
            image: UIImage (systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
            
        )
        viewControllers = [nav1, nav2, nav3]
    }

    private func setupTabBarAppearance() {
        tabBar.tintColor = UIColor(hex: "915B5B") // 선택된 탭 아이템 색상
        tabBar.unselectedItemTintColor = .gray // 선택 안된 탭 아이템 색상
        tabBar.isTranslucent = true
        tabBar.backgroundColor = UIColor(hex: "F6F6F6").withAlphaComponent(0.7) // 밝은 반투명 배경
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
    }
}
class CustomTabBar: UITabBar {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
    var sizeThatFits = super.sizeThatFits(size)
    sizeThatFits.height = 85 // 원하는 길이
    return sizeThatFits
   }
}



//1. 이미지 배치,  주소 입력창 가운데 X
//2. 저장 뷰컨 지도 깔기 , 지도위에 뷰를 추가 *허전함
//3. 마이페이지에서 라벨을 위로 빼기
