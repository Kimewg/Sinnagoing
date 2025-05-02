//
//  SplashView.swift
//  shinnagoing
//
//  Created by 최영락 on 4/30/25.
//

import UIKit

class SplashView: UIView {

    private let ImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "splashView")

        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(hex: "915B5B")
        setUpUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpUI()
    }

    private func setUpUI() {
        self.addSubview(ImageView)

        ImageView.translatesAutoresizingMaskIntoConstraints = false

        ImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
