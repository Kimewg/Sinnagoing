import UIKit

class TabBarVC: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
        setupTabBarAppearance()
    }

    private func configureTabBar() {
        // Map
        let mapVC = MapVC()
        let nav1 = UINavigationController(rootViewController: mapVC)
        nav1.tabBarItem = UITabBarItem(title: "Map", image: nil, selectedImage: nil)

        // Second
        let addBoardVC = AddBoardVC()
        let nav2 = UINavigationController(rootViewController: addBoardVC)
        nav2.tabBarItem = UITabBarItem(title: "Second", image: nil, selectedImage: nil)

        // Third
        let myPageVC = MyPageVC()
        let nav3 = UINavigationController(rootViewController: myPageVC)
        nav3.tabBarItem = UITabBarItem(title: "Third", image: nil, selectedImage: nil)

        viewControllers = [nav1, nav2, nav3]
    }

    private func setupTabBarAppearance() {
        tabBar.backgroundColor = .white
        tabBar.tintColor = .systemBlue // 선택된 탭 아이템 색상
        tabBar.unselectedItemTintColor = .gray // 선택 안된 탭 아이템 색상
    }
}

