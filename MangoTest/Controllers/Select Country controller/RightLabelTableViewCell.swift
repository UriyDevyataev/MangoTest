//
//  RightLabelTableViewCell.swift
//  PlantingPlaner
//
//  Created by yurii.devyataev on 17.06.2022.
//

import UIKit

class StandartTableViewCell: UITableViewCell {

    var leftTitle = UILabel()
    var rightTitle = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configCell()
        configConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configCell() {
        contentView.backgroundColor = .white
        
//        leftTitle.font = CustomFont.murechoRegular()
        leftTitle.textColor = .black
        leftTitle.textAlignment = .left

//        rightTitle.font = CustomFont.murechoRegular()
//        rightTitle.textColor = Constant.unSelectedColor
        rightTitle.textAlignment = .right

        self.selectionStyle = .none

        contentView.addSubview(leftTitle)
        contentView.addSubview(rightTitle)
    }

    func configConstraint() {
        leftTitle.translatesAutoresizingMaskIntoConstraints = false
        leftTitle.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        leftTitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        leftTitle.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        leftTitle.rightAnchor.constraint(equalTo: rightTitle.leftAnchor).isActive = true

        rightTitle.translatesAutoresizingMaskIntoConstraints = false
        rightTitle.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        rightTitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        rightTitle.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20).isActive = true

    }

    func setCell(leftText: String, rightText: String) {
        leftTitle.text = leftText
        rightTitle.text = rightText
    }
}
