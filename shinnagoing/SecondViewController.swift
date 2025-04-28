import UIKit
import SnapKit

class SecondViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        setupUI()
    }
    
    private func setupUI() {
        // 예시로 간단한 레이블 추가
        let label = UILabel()
        label.text = "Second Tab"
        label.textColor = .white
        label.textAlignment = .center
        view.addSubview(label)
        
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
