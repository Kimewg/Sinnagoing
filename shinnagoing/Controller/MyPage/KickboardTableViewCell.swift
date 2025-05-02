//
//  TableViewCell.swift
//  shinnagoing
//
//  Created by 최영락 on 4/30/25.
//

import UIKit
import SnapKit

class KickboardTableViewCell: UITableViewCell {

    static let identifier = "KickboardTableViewCell"

    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.backgroundColor = .white
        return view
    }()

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "kickBoard")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    let contentLabel: UILabel = {
        let label = UILabel()
        label.text = "기본 텍스트"
        label.textColor = UIColor(hex: "#915B5B")
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(iconImageView)
        containerView.addSubview(contentLabel)
        

        containerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(6) // 셀 간격
            make.leading.trailing.equalToSuperview().inset(8)
        }

        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }

        contentLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(12)
            make.top.bottom.equalToSuperview().inset(12)
        }
    }
}
