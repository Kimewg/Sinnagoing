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
            title: "",
            image: UIImage(named: "map"),
            selectedImage: UIImage(named: "map_fill.png"))

        // Second
        let addBoardVC = AddBoardVC()
        let nav2 = UINavigationController(rootViewController: addBoardVC)
        nav2.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "addBoard"),
            selectedImage: UIImage(named: "addBoard_fill.png")
        )

        // Third
        let myPageVC = MyPageVC()
        let nav3 = UINavigationController(rootViewController: myPageVC)
        nav3.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "myPage.png"),
            selectedImage: UIImage(named: "myPage_fill.png")
            
        )
        viewControllers = [nav1, nav2, nav3]
    }

    private func setupTabBarAppearance() {
        tabBar.backgroundColor = .white
        tabBar.tintColor = UIColor(hex: "#C89F43") // 선택된 탭 아이템 색상
        tabBar.unselectedItemTintColor = .gray // 선택 안된 탭 아이템 색상
        tabBar.isTranslucent = false
        tabBar.layer.shadowOpacity = 0 // 그림자 없애기
    }
}
class CustomTabBar: UITabBar {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
    var sizeThatFits = super.sizeThatFits(size)
    sizeThatFits.height = 115 // 원하는 길이
    return sizeThatFits
   }
}

