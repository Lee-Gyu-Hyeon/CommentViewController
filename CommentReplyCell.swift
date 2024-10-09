import UIKit

class CommentReplyCell: UITableViewCell {
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var repleshowButton: UIButton = {
        let musicClass: UIImage = UIImage(named: "img_btn_reply_display")!
        
        let button = UIButton()
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.black, for: .normal)
        button.contentHorizontalAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.setImage(musicClass, for: .normal)
        
        button.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        button.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        button.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        return button
    }()
    
    lazy var replehideButton: UIButton = {
        let musicClass: UIImage = UIImage(named: "img_btn_reply_hide")!
        
        let button = UIButton()
        button.setTitle("숨기기", for: .normal)
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.black, for: .normal)
        button.contentHorizontalAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.setImage(musicClass, for: .normal)
        
        let titleWidth = button.titleLabel?.intrinsicContentSize.width ?? 0
        let imageWidth = button.imageView?.intrinsicContentSize.width ?? 0
        
        let spacing: CGFloat = 8.0
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth - spacing / 2, bottom: 0, right: imageWidth + spacing / 2)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: titleWidth + spacing / 2, bottom: 0, right: -titleWidth - spacing / 2)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: spacing / 2, bottom: 0, right: spacing / 2)
        
        return button
    }()
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(isExpanded: Bool, totalReplyCount: Int, shownReplies: Int) {
        
        //답글 추가
        let remainingReplies = totalReplyCount - shownReplies
        
        if totalReplyCount == 0 {
            
            repleshowButton.setTitle("답글 보기 (0)", for: .normal)
            repleshowButton.setImage(UIImage(named: "img_btn_reply_hide"), for: .normal)
            
        } else if isExpanded {
            repleshowButton.isHidden = shownReplies >= totalReplyCount
            
            if remainingReplies == 0 {
                repleshowButton.setTitle("답글 보기 (0)", for: .normal)
                repleshowButton.setImage(UIImage(named: "img_btn_reply_hide"), for: .normal)
            } else {
                repleshowButton.setTitle("답글 보기 (\(remainingReplies))", for: .normal)
                repleshowButton.setImage(UIImage(named: "img_btn_reply_display"), for: .normal)
            }
            
        } else {
            repleshowButton.setTitle("답글 보기 (\(totalReplyCount))", for: .normal)
            repleshowButton.setImage(UIImage(named: "img_btn_reply_display"), for: .normal)
        }
        
        if !isExpanded {
            repleshowButton.setTitle("답글 보기 (\(remainingReplies))", for: .normal)
            repleshowButton.setImage(UIImage(named: "img_btn_reply_display"), for: .normal)
            
        } else {
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
  
    func updateReplyButton(isExpanded: Bool, replyCount: Int) {
        if replyCount == 0 {
            repleshowButton.setImage(UIImage(named: "img_btn_reply_display"), for: .normal)
            repleshowButton.setTitle("답글 보기(0)", for: .normal)
            return
        }

        let displayedReplies = isExpanded ? replyCount : min(replyCount, 10)
        let remainingReplies = replyCount - displayedReplies
        
        if isExpanded {
            if remainingReplies == 0 {
                repleshowButton.setImage(UIImage(named: "img_btn_reply_hide"), for: .normal)
                repleshowButton.setTitle("답글 보기(0)", for: .normal)
            } else {
                repleshowButton.setImage(UIImage(named: "img_btn_reply_display"), for: .normal)
                repleshowButton.setTitle("답글 보기(\(remainingReplies))", for: .normal)
            }
        } else {
            repleshowButton.setImage(UIImage(named: "img_btn_reply_display"), for: .normal)
            repleshowButton.setTitle("답글 보기(\(replyCount))", for: .normal)
        }
    }
}

extension CommentReplyCell {
    func setupUI() {
        
        containerView.subviews.forEach { $0.removeFromSuperview() }
        contentView.subviews.forEach { $0.removeFromSuperview() }
        
        self.contentView.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(65)
            make.height.equalTo(2)
            make.width.equalTo(20)
            
        }
        
        self.contentView.addSubview(repleshowButton)
        repleshowButton.snp.makeConstraints { (make) in
            //make.edges.equalToSuperview().inset(5)
            make.centerY.equalToSuperview()
            make.leading.equalTo(containerView.snp.trailing).offset(4)
            make.height.equalTo(30)
        }
        
        self.contentView.addSubview(replehideButton)
        replehideButton.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            //make.leading.equalTo(repleshowButton.snp.trailing)
            make.trailing.equalTo(-16)
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
        }
    }
}
