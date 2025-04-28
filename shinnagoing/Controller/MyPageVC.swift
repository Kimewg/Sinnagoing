import UIKit
import SnapKit

class MyPageVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue
        setupUI()
    }
    
    private func setupUI() {
        // 예시로 간단한 레이블 추가
        let label = UILabel()
        label.text = "Third Tab"
        label.textColor = .white
        label.textAlignment = .center
        view.addSubview(label)
        
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
