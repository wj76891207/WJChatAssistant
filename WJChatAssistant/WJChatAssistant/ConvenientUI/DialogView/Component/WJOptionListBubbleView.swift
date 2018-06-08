//
//  WJOptionListBubbleView.swift
//  WJChatAssistant
//
//  Created by wangjian on 06/06/2018.
//  Copyright © 2018 wangjian. All rights reserved.
//

import UIKit

class WJOptionListBubbleView: WJTextBubbleView, UITableViewDataSource, UITableViewDelegate {

    /// 暂时给一个固定的值
    private let optionCellH: CGFloat = 44
    
    private lazy var optionList: UITableView = {
        let optionList = UITableView(frame: .zero, style: .plain)
        optionList.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        optionList.dataSource = self
        optionList.delegate = self
        optionList.backgroundColor = UIColor.white
        return optionList
    }()
    
    var optionalTitles: [String] = [] {
        didSet {
            optionList.reloadData()
            setNeedsLayout()
        }
    }
    
    override var skinType: WJBubbleView.SkinType {
        didSet {
            backgroundColor = skinType.color
            textColor = skinType.textColor
            borderColor = skinType.color
        }
    }
    
    var optionSelectHandler: ((Int) -> Void)? = nil
    
    override init(frame: CGRect, position: Position = .left) {
        super.init(frame: frame, position: position)
        borderWidth = 1
        optionList.separatorColor = WJBubbleView.SkinType.gray.color
        addSubview(optionList)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        if isProcessing {
            return super.sizeThatFits(size)
        }
        
        let titleAreaSize = super.sizeThatFits(size)
        let optionAreaH = CGFloat(optionalTitles.count) * optionCellH
        
        return CGSize(width: size.width, height: titleAreaSize.height+optionAreaH)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let optionAreaH = CGFloat(optionalTitles.count) * optionCellH
        optionList.frame = CGRect(x: contentEdgeInsets.left, y: bounds.height-optionAreaH,
                                  width: bounds.width-contentEdgeInsets.horizontal, height: optionAreaH)
        textLabel.sizeToFit()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionalTitles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return optionCellH
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = optionalTitles[indexPath.row]
        cell.textLabel?.numberOfLines = 2
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        cell.textLabel?.textColor = _blueColor
        
        cell.selectedBackgroundView = UIView()
        cell.selectedBackgroundView?.backgroundColor = optionList.separatorColor
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        optionSelectHandler?(indexPath.row)
    }
}
