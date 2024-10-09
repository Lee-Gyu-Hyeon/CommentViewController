//
//  CommentViewController.swift
//  BoomClap2-1
//
//  Created by lee on 2021/03/02.
//

import UIKit
import SnapKit
import Alamofire
import Kingfisher
import SwiftyJSON

class CommentViewController: UIViewController, CommentHashTagViewDelegate {
    
    let cellId = "cellId"
    let cellId2 = "cellId2"
    let cellId3 = "cellId3"
    
    let tableView = UITableView()
    let closeButton = UIButton()
    
    var heroes = [RootCommentList]()
    var selectedComment: RootCommentList!
    var heroes2 = [NoRootCommentList]()
    
    var data3: ListContentM!
    
    let token = UserDefaults.standard.string(forKey: "loginID") ?? "" //이메일
    let token2 = UserDefaults.standard.string(forKey: "session") ?? "" //로그인 세션
    
    let headerView = UIView()
    let CommentCountLabel = UILabel()
    
    let containerView = UIView()
    var inputTextField = UITextView()
    let btnDone3 = UIButton()
    
    let newTF = UITextView()
    let viewAcc = UIView()
    let btnDone = UIButton()
    
    let newTF2 = UITextView()
    let viewAcc2 = UIView()
    let btnDone2 = UIButton()
    
    var newTF3 = UITextView()
    var viewAcc3 = UIView()
    var btnDone4 = UIButton()
    
    var hashTagView: CommentHashTagView!
    var attrNSString : NSMutableAttributedString?
  
    var selectedIndexPath: IndexPath?
    var replyCount: Int = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "댓글"
        navigationController?.navigationBar.isTranslucent = false
        
        self.view.backgroundColor = UIColor.white
        
        tableView.register(CommentCell.self, forCellReuseIdentifier: cellId)
        tableView.register(CommentReplyCell.self, forCellReuseIdentifier: cellId2)
        tableView.register(ReplyCell.self, forCellReuseIdentifier: cellId3)
        
        tableView.cellLayoutMarginsFollowReadableWidth = false
        tableView.separatorInset.left = 0
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        
        self.tableView.showsVerticalScrollIndicator = false
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
        
        headerView.frame = CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 30)
        headerView.backgroundColor = UIColor.white
        tableView.tableHeaderView = headerView
        
        
        CommentCountLabel.font = UIFont.systemFont(ofSize: 15)
        CommentCountLabel.textColor = UIColor.black
        headerView.addSubview(CommentCountLabel)
        
        CommentCountLabel.snp.makeConstraints{ (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        
        closeButton.setImage(UIImage(named: "img_btn_ranking_close"), for: .normal)
        closeButton.setImage(UIImage(named: "img_btn_ranking_close"), for: .selected)
        closeButton.addTarget(self, action: #selector(self.closeButtonTapped), for: .touchUpInside)
        headerView.addSubview(closeButton)
        
        closeButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(-10)
            make.width.height.equalTo(14)
            make.top.equalTo(12)
        }
        
        
        containerView.backgroundColor = .red
        self.view.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.width.equalToSuperview()
        }
        
        
        inputTextField.textColor = UIColor.black
        //inputTextField.delegate = self
        inputTextField.delegate = hashTagView
        containerView.addSubview(inputTextField)
        
        inputTextField.snp.makeConstraints { (make) in
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.height.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        
        
        btnDone3.backgroundColor = UIColor(red: 62/255, green: 202/255, blue: 192/255, alpha: 1.0)
        btnDone3.setTitle("작성", for: .normal)
        btnDone3.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        
        containerView.addSubview(btnDone3)
        btnDone3.snp.makeConstraints { make in
            make.width.equalTo(47)
            make.height.equalTo(28)
            make.top.equalTo(10)
            make.right.equalToSuperview().inset(10)
        }
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalTo(self.view)
            make.bottom.equalTo(containerView.snp.top)
        }
        
        
        hashTagView = CommentHashTagView()
        //hashTagView.backgroundColor = UIColor.white
        hashTagView.externalTextView = inputTextField
        hashTagView.inputDelegate = self
        hashTagView.delegate = self
        hashTagView.isHidden = true
        //hashTagView.externalTextView?.delegate = self
        self.view.addSubview(hashTagView)

        hashTagView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalTo(self.view)
            make.bottom.equalTo(containerView.snp.top)
        }
        
        
        //댓글 API
        let url = NetworkProtocol.COMMENT_LIST_REQ
        
        let headers: HTTPHeaders = [
            "Content-type": "application/json",
        ]
        print("headers:", headers)
        
        let parameters: Parameters = [
            "contentMId": data3.contentMID!,
        ]
        print("댓글 parameters:", parameters)
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default ,headers: nil).responseJSON(completionHandler: { response in
            let json = response.data
            
            switch response.result {
            case .success(let res):
                
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted)
                    let json = try JSONDecoder().decode(CommentList.self, from: json!)
                    print("홈-추천 댓글목록 json", json)
                    
                    self.heroes = json.data!.rootCommentList
                    
                    self.heroes.forEach { e in
                    }
                    
                    self.tableView.reloadData()
                    self.tableView.delegate = self
                    
                    if self.heroes.isEmpty {
                        let messageLabel = UILabel(frame: CGRect(x: 20.0, y: 0, width: self.tableView.bounds.size.width - 40.0, height: self.tableView.bounds.size.height))
                        messageLabel.text = "작성된 댓글이 없습니다."
                        messageLabel.numberOfLines = 0
                        messageLabel.textAlignment = NSTextAlignment.center
                        messageLabel.sizeToFit()
                        
                        self.tableView.backgroundView = messageLabel
                        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
                        
                        self.tableView.isScrollEnabled = false
                        
                        self.CommentCountLabel.text = "댓글 0개"
                        
                    } else {
                        self.tableView.backgroundView = nil
                    }
                    
                } catch {
                    print(error)
                }
                
            case .failure(let err):
                if err.localizedDescription == "URLSessionTask failed with error: Could not connect to the server." {
                    let alert = UIAlertController(title: "알림", message: "서버와의 연결이 끊어졌습니다.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }

                if err.localizedDescription == "A data connection is not currently allowed." {
                    let alert = UIAlertController(title: "알림", message: "와이파이 혹은 네트워크 연결상태를 확인해 주세요.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }

                if err.localizedDescription == "The request timed out." {
                    let alert = UIAlertController(title: "알림", message: "서버 응답 시간 초과", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
                if err.localizedDescription == "URLSessionTask failed with error: The Internet connection appears to be offline." {
                    let alert = UIAlertController(title: "알림", message: "원할한 서비스 이용을 위해 인터넷 연결을 확인해 주세요.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
                let alert = UIAlertController(title: "알림", message: err.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    func updateReplies(for indexPath: IndexPath) {
        self.a(indexPath: indexPath) { replyCount in
        }
    }
  
    func a(indexPath: IndexPath, completion: @escaping (Int) -> Void) {
        guard indexPath.section >= 0 && indexPath.section < heroes.count else {
            print("Index out of range: section \(indexPath.section) is out of bounds.")
            return
        }
        
        let url = NetworkProtocol.COMMENT_REPLY_REQ
        
        let headers: HTTPHeaders = [
            "Content-type": "application/json",
        ]
        print("headers:", headers)
        
        let parameters: Parameters = [
            "contentMId": data3.contentMID!,
            "commentId": self.heroes[indexPath.section].id!
        ]
        print("홈-추천 답글 목록 parameters:", parameters)
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default ,headers: nil).responseJSON(completionHandler: { response in
            let json = response.data
            
            switch response.result {
            case .success(let res):
                
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted)
                    let json = try JSONDecoder().decode(CommentReplyList.self, from: json!)
                    print("홈-추천 답글 목록 json", json)
                    print(jsonData)
                
                    self.heroes2 = json.data?.noRootCommentList ?? []
                    self.replyCount = self.heroes2.count
                    completion(self.heroes2.count)
                    
                    self.heroes2.forEach { e in
                    }
                    
                    if self.heroes2.isEmpty {
                        print("self.heroes2.isEmpty")
                    } else {
                        print("self.heroes2.isEmpty else")
                    }
                    
                } catch {
                    print(error)
                }
                
            case .failure(let err):
                if err.localizedDescription == "URLSessionTask failed with error: Could not connect to the server." {
                    let alert = UIAlertController(title: "알림", message: "서버와의 연결이 끊어졌습니다.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }

                if err.localizedDescription == "A data connection is not currently allowed." {
                    let alert = UIAlertController(title: "알림", message: "와이파이 혹은 네트워크 연결상태를 확인해 주세요.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }

                if err.localizedDescription == "The request timed out." {
                    let alert = UIAlertController(title: "알림", message: "서버 응답 시간 초과", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
                if err.localizedDescription == "URLSessionTask failed with error: The Internet connection appears to be offline." {
                    let alert = UIAlertController(title: "알림", message: "원할한 서비스 이용을 위해 인터넷 연결을 확인해 주세요.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
                let alert = UIAlertController(title: "알림", message: err.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("CommentViewController의 view가 Load됨")
        
        // 키보드 알림 등록
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("CommentViewController의 view가 사라지기 전")
        
        // 키보드 알림 해제
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.inputTextField.resignFirstResponder()
        self.newTF.resignFirstResponder()
        self.newTF2.resignFirstResponder()
        self.newTF3.resignFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("CommentViewController의 view가 화면에 나타남")
        
        makeInputAccessoryView()
        
        viewAcc.layer.addBorder([.top, .bottom], color: UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 0.5), width: 1)
        inputTextField.layer.addBorder([.top, .bottom], color: UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 0.5), width: 1)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("CommentViewController의 view가 사라짐")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print("CommentViewController의 SubView를 레이아웃 하려함")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("CommentViewController의 SubView를 레이아웃 함")
    }
    
    func makeInputAccessoryView() {
        viewAcc.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50)
        viewAcc.backgroundColor = UIColor.white
        
        newTF.backgroundColor = UIColor.white
        newTF.font = UIFont.systemFont(ofSize: 15)
        newTF.keyboardType = .twitter
        newTF.delegate = hashTagView
        
        btnDone.backgroundColor = UIColor(red: 62/255, green: 202/255, blue: 192/255, alpha: 1.0)
        //btnDone.isEnabled = false
        btnDone.setTitle("작성", for: .normal)
        btnDone.addTarget(self, action: #selector(self.commentwriteButtonTapped), for: .touchUpInside)
        btnDone.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        
        viewAcc.addSubview(btnDone)
        btnDone.snp.makeConstraints { make in
            make.width.equalTo(47)
            make.height.equalTo(28)
            make.top.equalTo(10)
            make.right.equalToSuperview().inset(10)
        }
        
        viewAcc.addSubview(newTF)
        newTF.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.height.equalTo(50)
            make.trailing.equalTo(btnDone.snp.leading)
        }
        
        
        self.inputTextField.inputAccessoryView = viewAcc
        self.inputTextField.resignFirstResponder()
        self.newTF.becomeFirstResponder()
        
        hashTagView = CommentHashTagView()
        hashTagView.externalTextView = newTF
        hashTagView.inputDelegate = self
        hashTagView.delegate = self
        hashTagView.isHidden = true
        self.view.addSubview(hashTagView)
        
        hashTagView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(self.view)
        }
    }
    
    func CommentListExample() {
        let url = NetworkProtocol.COMMENT_LIST_REQ
        
        let headers: HTTPHeaders = [
            "Content-type": "application/json",
        ]
        print("headers:", headers)
        
        let parameters: Parameters = [
            "contentMId": data3.contentMID as Any,
        ]
        print("댓글 parameters:", parameters)
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default ,headers: nil).responseJSON(completionHandler: { response in
            let json = response.data
            
            switch response.result {
            case .success(let res):
                
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted)
                    print(jsonData)
                    
                    let json = try JSONDecoder().decode(CommentList.self, from: json!)
                    print("홈-추천 댓글 CommentListExample json:", json)
                    
                    self.heroes = json.data!.rootCommentList
                    self.heroes.forEach { e in
                    }
                    
                    self.tableView.reloadData()
                    
                    if self.heroes.isEmpty {
                        let messageLabel = UILabel(frame: CGRect(x: 20.0, y: 0, width: self.tableView.bounds.size.width - 40.0, height: self.tableView.bounds.size.height))
                        messageLabel.text = "작성된 댓글이 없습니다."
                        messageLabel.numberOfLines = 0
                        messageLabel.textAlignment = NSTextAlignment.center
                        messageLabel.sizeToFit()
                        
                        self.tableView.backgroundView = messageLabel
                        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
                        self.tableView.isScrollEnabled = false
                        
                        self.CommentCountLabel.text = "댓글 0개"
                        
                    } else {
                        self.tableView.backgroundView = nil
                    }
                    
                } catch {
                    print(error)
                }
                
            case .failure(let err):
                if err.localizedDescription == "URLSessionTask failed with error: Could not connect to the server." {
                    let alert = UIAlertController(title: "알림", message: "서버와의 연결이 끊어졌습니다.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }

                if err.localizedDescription == "A data connection is not currently allowed." {
                    let alert = UIAlertController(title: "알림", message: "와이파이 혹은 네트워크 연결상태를 확인해 주세요.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }

                if err.localizedDescription == "The request timed out." {
                    let alert = UIAlertController(title: "알림", message: "서버 응답 시간 초과", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
                if err.localizedDescription == "URLSessionTask failed with error: The Internet connection appears to be offline." {
                    let alert = UIAlertController(title: "알림", message: "원할한 서비스 이용을 위해 인터넷 연결을 확인해 주세요.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
                let alert = UIAlertController(title: "알림", message: err.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    func CommentListExample2() {
        let url = NetworkProtocol.COMMENT_LIST_REQ
        
        let headers: HTTPHeaders = [
            "Content-type": "application/json",
        ]
        print("headers:", headers)
        
        let parameters: Parameters = [
            "contentMId": data3.contentMID!,
        ]
        print("댓글 parameters:", parameters)
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default ,headers: nil).responseJSON(completionHandler: { response in
            let json = response.data
            
            switch response.result {
            case .success(let res):
                
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted)
                    let json = try JSONDecoder().decode(CommentList.self, from: json!)
                    print("홈-추천 댓글목록 json", json)
                    
                    self.heroes = json.data!.rootCommentList
                    self.heroes.forEach { e in
                    }
                    
                } catch {
                    print(error)
                }
                
            case .failure(let err):
                if err.localizedDescription == "URLSessionTask failed with error: Could not connect to the server." {
                    let alert = UIAlertController(title: "알림", message: "서버와의 연결이 끊어졌습니다.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }

                if err.localizedDescription == "A data connection is not currently allowed." {
                    let alert = UIAlertController(title: "알림", message: "와이파이 혹은 네트워크 연결상태를 확인해 주세요.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }

                if err.localizedDescription == "The request timed out." {
                    let alert = UIAlertController(title: "알림", message: "서버 응답 시간 초과", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
                if err.localizedDescription == "URLSessionTask failed with error: The Internet connection appears to be offline." {
                    let alert = UIAlertController(title: "알림", message: "원할한 서비스 이용을 위해 인터넷 연결을 확인해 주세요.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
                let alert = UIAlertController(title: "알림", message: err.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    func CommentListExample3() {
        let url = NetworkProtocol.COMMENT_REPLY_REQ
        
        let headers: HTTPHeaders = [
            "Content-type": "application/json",
        ]
        print("headers:", headers)
        
        let parameters: Parameters = [
            "contentMId": data3.contentMID!,
            "commentId": ""
        ]
        print("홈-추천 답글 목록 parameters:", parameters)
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default ,headers: nil).responseJSON(completionHandler: { response in
            let json = response.data
            
            switch response.result {
            case .success(let res):
                
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted)
                    let json = try JSONDecoder().decode(CommentReplyList.self, from: json!)
                    print("홈-추천 답글 목록 json", json)
                    print(jsonData)
                    
                    self.heroes2 = json.data?.noRootCommentList ?? []
                    self.heroes.forEach { e in
                    }
                    self.tableView.reloadData()
                    
                } catch {
                    print(error)
                }
                
            case .failure(let err):
                if err.localizedDescription == "URLSessionTask failed with error: Could not connect to the server." {
                    let alert = UIAlertController(title: "알림", message: "서버와의 연결이 끊어졌습니다.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }

                if err.localizedDescription == "A data connection is not currently allowed." {
                    let alert = UIAlertController(title: "알림", message: "와이파이 혹은 네트워크 연결상태를 확인해 주세요.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }

                if err.localizedDescription == "The request timed out." {
                    let alert = UIAlertController(title: "알림", message: "서버 응답 시간 초과", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
                if err.localizedDescription == "URLSessionTask failed with error: The Internet connection appears to be offline." {
                    let alert = UIAlertController(title: "알림", message: "원할한 서비스 이용을 위해 인터넷 연결을 확인해 주세요.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
                let alert = UIAlertController(title: "알림", message: err.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    func makeInputAccessoryView2() {
        viewAcc2.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50)
        viewAcc2.backgroundColor = UIColor.white
        
        newTF2.backgroundColor = UIColor.white
        newTF2.font = UIFont.systemFont(ofSize: 15)
        newTF2.delegate = hashTagView
        newTF2.keyboardType = .twitter
        
        btnDone2.backgroundColor = UIColor(red: 62/255, green: 202/255, blue: 192/255, alpha: 1.0)
        btnDone2.setTitle("작성", for: .normal)
        btnDone2.addTarget(self, action: #selector(self.commentwrite2ButtonTapped), for: .touchUpInside)
        btnDone2.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        
        viewAcc2.addSubview(btnDone2)
        btnDone2.snp.makeConstraints { make in
            make.width.equalTo(47)
            make.height.equalTo(28)
            make.top.equalTo(10)
            make.right.equalToSuperview().inset(10)
        }
        
        viewAcc2.addSubview(newTF2)
        newTF2.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.height.equalTo(50)
            make.trailing.equalTo(btnDone2.snp.leading)
        }
        
        
        self.inputTextField.inputAccessoryView = viewAcc2
        viewAcc2.layer.addBorder([.top, .bottom], color: UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 0.5), width: 1)
        
        self.inputTextField.becomeFirstResponder()
        self.newTF2.becomeFirstResponder()
        self.newTF.becomeFirstResponder()
      
        hashTagView = CommentHashTagView()
        hashTagView.externalTextView = newTF2
        hashTagView.inputDelegate = self
        hashTagView.delegate = self
        hashTagView.isHidden = true
        self.view.addSubview(hashTagView)
        
        hashTagView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(self.view)
        }
        
        self.inputTextField.resignFirstResponder()
    }
  
    func makeInputAccessoryView3() {
        print("newTF3 added to viewAcc3 and becomeFirstResponder called")
        
        viewAcc3.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50)
        viewAcc3.backgroundColor = UIColor.white
        
        newTF3.backgroundColor = UIColor.white
        newTF3.font = UIFont.systemFont(ofSize: 15)
        //newTF3.delegate = self
        newTF3.delegate = hashTagView //태그 추가
        //newTF3.contentInset = UIEdgeInsets(top: 9, left: 0, bottom: 0, right: 0)
        //newTF3.textContainerInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        newTF3.keyboardType = .twitter
        
        btnDone4.backgroundColor = UIColor(red: 62/255, green: 202/255, blue: 192/255, alpha: 1.0)
        btnDone4.setTitle("작성", for: .normal)
        btnDone4.addTarget(self, action: #selector(self.commentwrite3ButtonTapped), for: .touchUpInside)
        btnDone4.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        
        viewAcc3.addSubview(btnDone4)
        btnDone4.snp.makeConstraints { make in
            make.width.equalTo(47)
            make.height.equalTo(28)
            make.top.equalTo(10)
            make.right.equalToSuperview().inset(10)
        }
        
        viewAcc3.addSubview(newTF3)
        newTF3.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.height.equalTo(50)
            make.trailing.equalTo(btnDone4.snp.leading)
        }
        
        
        self.inputTextField.inputAccessoryView = viewAcc3
        viewAcc3.layer.addBorder([.top, .bottom], color: UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 0.5), width: 1)
        
        self.inputTextField.becomeFirstResponder()
        self.newTF3.becomeFirstResponder()
        
        hashTagView = CommentHashTagView()
        hashTagView.externalTextView = newTF3
        hashTagView.inputDelegate = self
        hashTagView.delegate = self
        hashTagView.isHidden = true
        self.view.addSubview(hashTagView)
        
        hashTagView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(self.view)
        }
        
        self.inputTextField.resignFirstResponder()
    }
    
    func textCountDidChange(to count: Int) {
        self.tableView.isHidden = false
    }
  
    func showAlert(title: String, message: String) {
        self.tableView.isHidden = false
    }
    
    @objc func keyBoardWillShow(notification: NSNotification) {
        if newTF.superview == nil && newTF.isUserInteractionEnabled {
        } else if newTF.superview != nil && newTF.isUserInteractionEnabled {
            newTF.becomeFirstResponder()
        }
      
        if newTF2.superview == nil && newTF2.isUserInteractionEnabled {
        } else if newTF2.superview != nil && newTF2.isUserInteractionEnabled {
        }
      
        if newTF3.superview == nil && newTF3.isUserInteractionEnabled {
        } else if newTF3.superview != nil && newTF3.isUserInteractionEnabled {
        }
    }
    
    @objc func keyBoardWillHide(notification: NSNotification) {
        self.inputTextField.tintColor = .clear
        
        self.inputTextField.resignFirstResponder()
        self.newTF.resignFirstResponder()
        self.newTF2.resignFirstResponder()
        self.newTF3.resignFirstResponder()
        
        if self.inputTextField.text.isEmpty {
            self.inputTextField.text = "댓글을 입력하세요"
            self.inputTextField.textColor = UIColor.lightGray
        }
        
        // 현재 첫 응답자(first responder) 확인
        if newTF.isFirstResponder {
            print(">>>> newTF is first responder")
        } else if newTF2.isFirstResponder {
            print(">>>> newTF2 is first responder")
        } else if newTF3.isFirstResponder {
            print(">>>> newTF3 is first responder")
        } else {
            print(">>>> else first responder")
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        
        let size = textView.sizeThatFits(textView.frame.size)
        inputTextField.resignFirstResponder()
        newTF.becomeFirstResponder()
        
        if size.width >= 301 {
            let subString = textView.text.suffix(1)
            newTF.text.removeLast(1)
            newTF.text.append(contentsOf: "\n" +  subString)
        }
        return true
    }
    
    @objc func commentwriteButtonTapped(_ sender: UIButton) {
        
        if newTF.text == "" {
            
            let alert = UIAlertController(title: "알림", message: "댓글을 입력하세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("확인", comment: "Default action"), style: .default, handler: { _ in
            }))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            if token == "" {
                
                let alert = UIAlertController(title: "로그인이 필요한 서비스 입니다.", message: "로그인 하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: "예", style: .default) { (action) in
                    
                    self.inputTextField.resignFirstResponder()
                    self.newTF.resignFirstResponder()
                    self.newTF2.resignFirstResponder()
                    self.newTF3.resignFirstResponder()
                    self.view.endEditing(true)
                    
                    let vc = EmailLogin3ViewController()
                    
                    let nvc = CustomNavigationController(rootViewController: vc)
                    nvc.modalPresentationStyle = .fullScreen
                    
                    var array = self.navigationController?.viewControllers
                    array?.removeLast()
                    array?.append(vc)
                    
                    self.navigationController?.setViewControllers(array!, animated: true)
                    self.present(nvc, animated: true, completion: nil)
                    
                }
                
                let noAction = UIAlertAction(title: "아니오", style: .default) { (action) in
                    
                }
                alert.addAction(okAction)
                alert.addAction(noAction)
                
                present(alert, animated: false, completion: nil)
                
            } else {
                
                btnDone.isEnabled = true
                
                let url = NetworkProtocol.COMMENT_REGISTER_REQ
                
                let headers: HTTPHeaders = [
                    "SESSION": token2
                ]
                print("홈-추천 댓글 작성 headers:", headers)
                
                let parameters: Parameters = [
                    "contentMId": data3.contentMID!,
                    "description": newTF.text!
                ]
                print("홈-추천 댓글 작성 parameters:", parameters)
                
                AF.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: headers).responseJSON { response in
                    
                    if let JSON = response.value {
                        print("홈-추천 댓글 작성 JSON:", JSON)
                    }
                    
                    if response.value != nil {
                        let jsondata = JSON(response.value!)
                        print("홈-추천 댓글 작성 jsondata:", jsondata)
                    }
                    
                    if response.value != nil {
                        
                        let jsondata = JSON(response.value!)
                        print("홈-추천 댓글 작성 RESN:", jsondata["RESN"])
                        print("홈-추천 댓글 작성 RSLT:", jsondata["RSLT"])
                        
                        if jsondata["RSLT"] == "S" {
                            
                            self.inputTextField.resignFirstResponder()
                            self.newTF.resignFirstResponder()
                            self.view.endEditing(true)
                            
                            let alert = UIAlertController(title: "알림", message: "댓글이 등록되었습니다.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: NSLocalizedString("확인", comment: "Default action"), style: .default, handler: { _ in
                                
                                self.tableView.reloadData()
                                self.view.endEditing(true)
                                self.CommentListExample()
                                self.newTF.text = nil
                                
                                self.hashTagView.snp.removeConstraints()
                                self.hashTagView.removeFromSuperview()
                                
                                //self.hashTagView.addEmptyStringToWords()
                                
                                self.tableView.isHidden = false
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                        
                        if jsondata["RESN"] == "AUTH-FAIL" {
                            
                        }
                    }
                }
            }
        }
    }
    
    @objc func commentwrite2ButtonTapped(_ sender: UIButton) {
        if token == "" {
            
            let alert = UIAlertController(title: "로그인이 필요한 서비스 입니다.", message: "로그인 하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "예", style: .default) { (action) in
                let vc = EmailLogin3ViewController()
                
                let nvc = CustomNavigationController(rootViewController: vc)
                nvc.modalPresentationStyle = .fullScreen
                
                var array = self.navigationController?.viewControllers
                array?.removeLast()
                array?.append(vc)
                
                self.navigationController?.setViewControllers(array!, animated: true)
                self.present(nvc, animated: true, completion: nil)
            }
            
            let noAction = UIAlertAction(title: "아니오", style: .default) { (action) in
                
            }
            alert.addAction(okAction)
            alert.addAction(noAction)
            
            present(alert, animated: false, completion: nil)
            
        } else {
            
            btnDone2.isEnabled = true
            
            let url = NetworkProtocol.COMMENT_UPDATE_REQ
            
            let headers: HTTPHeaders = [
                "SESSION": self.token2
            ]
            print("headers:", headers)
            
            let parameters: Parameters = [
                "id": selectedComment.id!,
                "description": self.newTF2.text!
            ]
            print("홈-추천 댓글 수정 parameters:", parameters)
            
            AF.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: headers).responseJSON { response in
                print(response)
                
                if let JSON = response.value {
                    print("홈-추천 댓글 수정 JSON:", JSON)
                }
                
                if response.value != nil {
                    let jsondata = JSON(response.value!)
                    print("홈-추천 댓글 수정 jsondata:", jsondata)
                }
                
                if response.value != nil {
                    
                    let jsondata = JSON(response.value!)
                    print("홈-추천 댓글 수정 RESN:", jsondata["RESN"])
                    print("홈-추천 댓글 수정 RSLT:", jsondata["RSLT"])
                    
                    if jsondata["RSLT"] == "S" {
                        
                        self.inputTextField.resignFirstResponder()
                        self.newTF2.resignFirstResponder()
                        self.view.endEditing(true)
                        
                        let alert = UIAlertController(title: "알림", message: "댓글이 수정되었습니다.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("확인", comment: "Default action"), style: .default, handler: { _ in
                            
                            self.tableView.reloadData()
                            self.view.endEditing(true)
                            self.CommentListExample()
                            self.newTF2.text = nil
                            
                            self.hashTagView.snp.removeConstraints()
                            self.hashTagView.removeFromSuperview()
                            
                            self.tableView.isHidden = false
                            
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    @objc func commentwrite3ButtonTapped(_ sender: UIButton) {
        if token == "" {
            
            let alert = UIAlertController(title: "로그인이 필요한 서비스 입니다.", message: "로그인 하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "예", style: .default) { (action) in
                
                let vc = EmailLogin3ViewController()
                
                let nvc = CustomNavigationController(rootViewController: vc)
                nvc.modalPresentationStyle = .fullScreen
                
                var array = self.navigationController?.viewControllers
                array?.removeLast()
                array?.append(vc)
                
                self.navigationController?.setViewControllers(array!, animated: true)
                self.present(nvc, animated: true, completion: nil)
            }
            
            let noAction = UIAlertAction(title: "아니오", style: .default) { (action) in
                
            }
            alert.addAction(okAction)
            alert.addAction(noAction)
            
            present(alert, animated: false, completion: nil)
            
        } else {
            btnDone3.isEnabled = true
            guard let indexPath = selectedIndexPath else {
                return
            }
            
            let selectedCellData2 = self.heroes[indexPath.section].id
            print("홈-추천 답글 작성 parameters5", selectedCellData2!)
            
            let url = NetworkProtocol.COMMENT_REGISTER_REQ
            
            let headers: HTTPHeaders = [
                "SESSION": self.token2
            ]
            print("headers:", headers)
            
            let parameters: Parameters = [
                "id": selectedCellData2!,
                "description": self.newTF3.text!,
                "contentMId": data3.contentMID!
            ]
            print("홈-추천 답글 등록 parameters:", parameters)
            
            AF.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: headers).responseJSON { response in
                print(response)
                
                if let JSON = response.value {
                    print("홈-추천 답글 등록 JSON:", JSON)
                }
                
                if response.value != nil {
                    let jsondata = JSON(response.value!)
                    print("홈-추천 답글 등록 jsondata:", jsondata)
                }
                
                if response.value != nil {
                    
                    let jsondata = JSON(response.value!)
                    print("홈-추천 답글 등록 RESN:", jsondata["RESN"])
                    print("홈-추천 답글 등록 RSLT:", jsondata["RSLT"])
                    
                    if jsondata["RSLT"] == "S" {
                        
                        self.inputTextField.resignFirstResponder()
                        self.newTF3.resignFirstResponder()
                        self.view.endEditing(true)
                        
                        let alert = UIAlertController(title: "알림", message: "답글이 등록었습니다.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("확인", comment: "Default action"), style: .default, handler: { _ in
                            
                            self.view.endEditing(true)
                            self.CommentListExample3()
                            self.newTF3.text = nil
                            
                            self.hashTagView.snp.removeConstraints()
                            self.hashTagView.removeFromSuperview()
                            
                            self.tableView.isHidden = false
                            self.updateReplies(for: indexPath)
                        }))
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    @objc func likeButtonTapped(_ sender: UIButton) {
        if token == "" {
            
            let alert = UIAlertController(title: "로그인이 필요한 서비스 입니다.", message: "로그인 하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "예", style: .default) { (action) in
                
                let vc = EmailLogin3ViewController()
                
                let nvc = CustomNavigationController(rootViewController: vc)
                nvc.modalPresentationStyle = .fullScreen
                
                var array = self.navigationController?.viewControllers
                array?.removeLast()
                array?.append(vc)
                
                self.navigationController?.setViewControllers(array!, animated: true)
                self.present(nvc, animated: true, completion: nil)
            }
            
            let noAction = UIAlertAction(title: "아니오", style: .default) { (action) in
                
            }
            alert.addAction(okAction)
            alert.addAction(noAction)
            
            present(alert, animated: false, completion: nil)
            
        } else {
            if self.heroes[sender.tag].likeYn == nil {
                
                let url = NetworkProtocol.COMMENT_LIKE_REQ
                
                let headers: HTTPHeaders = [
                    "SESSION": token2
                ]
                print("headers:", headers)
                
                let parameters: Parameters = [
                    "commentId": self.heroes[sender.tag].id!
                ]
                print("홈-추천 댓글 좋아요 nill -> Y parameters:", parameters)
                
                AF.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: headers).responseJSON { response in
                    print(response)
                    
                    if let JSON = response.value {
                        print("홈-추천 댓글 좋아요 nill -> Y JSON:", JSON)
                    }
                    
                    if response.value != nil {
                        let jsondata = JSON(response.value!)
                        print("홈-추천 댓글 좋아요 nill -> Y jsondata:", jsondata)
                    }
                    
                    if response.value != nil {
                        
                        let jsondata = JSON(response.value!)
                        print("홈-추천 댓글 좋아요 nill -> Y RESN:", jsondata["RESN"])
                        print("홈-추천 댓글 좋아요 nill -> Y RSLT:", jsondata["RSLT"])
                        
                        if jsondata["RSLT"] == "S" {
                            
                            let x: Int? = self.heroes[sender.tag].likeCnt
                            let b1 = x.map(String.init) ?? ""
                            
                            let indexPath = IndexPath(row: sender.tag, section: 0)
                            let cell = self.tableView.cellForRow(at: indexPath) as? CommentCell
                            
                            cell?.RootCommentLikeCountLabel.text = b1
                            self.heroes[sender.tag].likeCnt = x
                            
                            self.tableView.reloadData()
                            self.CommentListExample()
                        }
                        
                        if jsondata["RESN"] == "AUTH-FAIL" {
                            
                            let alert = UIAlertController(title: "세션이 만료 되었습니다.", message: "다시 로그인 해주세요.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: NSLocalizedString("확인", comment: "Default action"), style: .default, handler: { _ in
                                UserDefaults.standard.removeObject(forKey: "loginID")
                                UserDefaults.standard.removeObject(forKey: "session")
                                UserDefaults.standard.removeObject(forKey: "loginStatus")
                                
                                let vc = EmailLogin3ViewController()
                                
                                let nvc = CustomNavigationController(rootViewController: vc)
                                nvc.modalPresentationStyle = .fullScreen
                                
                                var array = self.navigationController?.viewControllers
                                array?.removeLast()
                                array?.append(vc)
                                
                                self.navigationController?.setViewControllers(array!, animated: true)
                                self.present(nvc, animated: true, completion: nil)
                                
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
            
            if self.heroes[sender.tag].likeYn == "Y" {
                
                let url = NetworkProtocol.COMMENT_LIKE_REQ
                
                let headers: HTTPHeaders = [
                    "SESSION": token2
                ]
                print("headers:", headers)
                
                let parameters: Parameters = [
                    "commentId": self.heroes[sender.tag].id!
                ]
                print("홈-추천 댓글 좋아요 Y -> N parameters:", parameters)
                
                AF.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: headers).responseJSON { response in
                    
                    if let JSON = response.value {
                        print("홈-추천 댓글 좋아요 Y -> N JSON:", JSON)
                    }
                    
                    if response.value != nil {
                        let jsondata = JSON(response.value!)
                        print("홈-추천 댓글 좋아요 Y -> N jsondata:", jsondata)
                    }
                    
                    if response.value != nil {
                        
                        let jsondata = JSON(response.value!)
                        print("홈-추천 댓글 좋아요 Y -> N RESN:", jsondata["RESN"])
                        print("홈-추천 댓글 좋아요 Y -> N RSLT:", jsondata["RSLT"])
                        
                        if jsondata["RSLT"] == "S" {
                            
                            let x: Int? = self.heroes[sender.tag].likeCnt
                            let b1 = x.map(String.init) ?? ""
                            
                            let indexPath = IndexPath(row: sender.tag, section: 0)
                            let cell = self.tableView.cellForRow(at: indexPath) as? CommentCell
                            
                            cell?.RootCommentLikeCountLabel.text = b1
                            self.heroes[sender.tag].likeCnt = x
                            
                            self.tableView.reloadData()
                            self.CommentListExample()
                        }
                    }
                }
            }
            
            if self.heroes[sender.tag].likeYn == "N" {
                
                let url = NetworkProtocol.COMMENT_LIKE_REQ
                
                let headers: HTTPHeaders = [
                    "SESSION": token2
                ]
                print("headers:", headers)
                
                let parameters: Parameters = [
                    "commentId": self.heroes[sender.tag].id!
                ]
                print("홈-추천 댓글 좋아요 N -> Y parameters:", parameters)
                
                
                AF.request(url, method: .post, parameters: parameters, encoding:URLEncoding.default, headers: headers).responseJSON { response in
                    print(response)
                    
                    if let JSON = response.value {
                        print("홈-추천 댓글 좋아요 N -> Y JSON:", JSON)
                    }
                    
                    if response.value != nil {
                        let jsondata = JSON(response.value!)
                        print("홈-추천 댓글 좋아요 N -> Y jsondata:", jsondata)
                    }
                    
                    if response.value != nil {
                        
                        let jsondata = JSON(response.value!)
                        print("홈-추천 댓글 좋아요 N -> Y RESN:", jsondata["RESN"])
                        print("홈-추천 댓글 좋아요 N -> Y RSLT:", jsondata["RSLT"])
                        
                        if jsondata["RSLT"] == "S" {
                            
                            let x: Int? = self.heroes[sender.tag].likeCnt
                            let b1 = x.map(String.init) ?? ""
                            
                            let indexPath = IndexPath(row: sender.tag, section: 0)
                            let cell = self.tableView.cellForRow(at: indexPath) as? CommentCell
                            
                            cell?.RootCommentLikeCountLabel.text = b1
                            self.heroes[sender.tag].likeCnt = x
                            
                            self.tableView.reloadData()
                            self.CommentListExample()
                        }
                    }
                }
            }
        }
    }
    
    @objc func closeButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        self.view.endEditing(true)
    }
    
    @objc func touchToPickPhoto(_ sender: UITapGestureRecognizer) {
        
        if self.token == self.heroes[sender.view!.tag].email {
            let vc = CommentMyPageViewController()
            let nvc = CustomNavigationController(rootViewController: vc)
            
            nvc.modalPresentationStyle = .fullScreen
            nvc.hidesBottomBarWhenPushed = true
            nvc.transitioningDelegate = self
            
            var array = self.navigationController?.viewControllers
            array?.removeLast()
            array?.append(vc)
            
            self.navigationController?.setViewControllers(array!, animated: true)
            self.present(nvc, animated: true, completion: nil)
            
        } else {
            let vc = CommentOpponentProfile2ViewController()
            let nvc = CustomNavigationController(rootViewController: vc)
            
            nvc.modalPresentationStyle = .fullScreen
            nvc.hidesBottomBarWhenPushed = true
            nvc.transitioningDelegate = self
            
            var array = self.navigationController?.viewControllers
            array?.removeLast()
            array?.append(vc)
            
            vc.no2receivedValueFromBeforeVC = self.heroes[sender.view!.tag].email!
            vc.no3receivedValueFromBeforeVC = self.heroes[sender.view!.tag].name!
            
            self.navigationController?.setViewControllers(array!, animated: true)
            self.present(nvc, animated: true, completion: nil)
        }
    }
    
    @objc func labelTapped(_ sender: UITapGestureRecognizer) {
        let indexPath = IndexPath(row: sender.view!.tag, section: 0)

        if let cell = tableView.cellForRow(at: indexPath) as? CommentCell {
            if let labelText = cell.commentcontentLabel.text {
                let point = sender.location(in: cell.commentcontentLabel)
                
                // 클릭한 지점의 문자열 인덱스를 찾음
                if let attributedText = cell.commentcontentLabel.attributedText {
                    let layoutManager = NSLayoutManager()
                    let textContainer = NSTextContainer(size: cell.commentcontentLabel.bounds.size)
                    let textStorage = NSTextStorage(attributedString: attributedText)
                    
                    layoutManager.addTextContainer(textContainer)
                    textStorage.addLayoutManager(layoutManager)
                    
                    let characterIndex = layoutManager.characterIndex(for: point, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
                    let hashtagRegex = try! NSRegularExpression(pattern: "#\\p{Emoji_Presentation}+|#[\\p{L}\\p{N}_]+", options: [])
                    
                    let matches = hashtagRegex.matches(in: labelText, options: [], range: NSRange(location: 0, length: labelText.utf16.count))
                    
                    for match in matches {
                        if let range = Range(match.range, in: labelText) {
                            let hashtag = labelText[range]
                            
                            if labelText.index(labelText.startIndex, offsetBy: characterIndex) >= range.lowerBound && labelText.index(labelText.startIndex, offsetBy: characterIndex) <= range.upperBound {
                                
                                let vc = CommentHashTagDetailViewController(collectionViewLayout: UICollectionViewFlowLayout())
                                let nvc = CustomNavigationController(rootViewController: vc)
                                
                                nvc.modalPresentationStyle = .fullScreen
                                nvc.hidesBottomBarWhenPushed = true
                                nvc.transitioningDelegate = self
                                
                                var array = self.navigationController?.viewControllers
                                array?.removeLast()
                                array?.append(vc)
                                
                                vc.noreceivedValueFromBeforeVC = "\(hashtag)"
                                
                                self.navigationController?.setViewControllers(array!, animated: true)
                                self.present(nvc, animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
            
            if let labelText = cell.commentcontentLabel.text, labelText.contains("@") {
                let indexPath = IndexPath(row: sender.view!.tag, section: 0)
                
                if let cell = tableView.cellForRow(at: indexPath) as? CommentCell {
                    let point = sender.location(in: cell.commentcontentLabel)
                    
                    if let attributedText = cell.commentcontentLabel.attributedText {
                        let layoutManager = NSLayoutManager()
                        let textContainer = NSTextContainer(size: cell.commentcontentLabel.bounds.size)
                        let textStorage = NSTextStorage(attributedString: attributedText)
                        
                        layoutManager.addTextContainer(textContainer)
                        textStorage.addLayoutManager(layoutManager)
                        
                        let characterIndex = layoutManager.characterIndex(for: point, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
                        
                        let labelText = attributedText.string
                        let emailRegex = try! NSRegularExpression(pattern: "\\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}\\b", options: [])
                        let matches = emailRegex.matches(in: labelText, options: [], range: NSRange(location: 0, length: labelText.utf16.count))
                        
                        for match in matches {
                            if characterIndex >= match.range.location && characterIndex <= match.range.location + match.range.length {
                                if let range = Range(match.range, in: labelText) {
                                    let email = labelText[range]
                                    
                                    let url = NetworkProtocol.USERPROFILE_REQ
                                    
                                    let parameters: Parameters = [
                                        "email": String(email),
                                        "page": "1",
                                    ]
                                    print("상대방 프로필 parameter:", parameters)
                                    
                                    AF.request(url, method: .post, parameters: parameters, encoding:URLEncoding.queryString, headers: nil).responseJSON { response in
                                        print(response)
                                        
                                        if let JSON = response.value {
                                            print("JSON: \(JSON)")
                                        }
                                        
                                        if response.value != nil {
                                            var jsondata = JSON(response.value!)
                                            print("jsondata:", jsondata)
                                            print("1:", jsondata["RESN"])
                                            print("2:", jsondata["RSLT"])
                                            
                                            if jsondata["RSLT"] == "S" {
                                                let vc = CommentOpponentProfileViewController()
                                                let nvc = CustomNavigationController(rootViewController: vc)
                                                
                                                nvc.modalPresentationStyle = .fullScreen
                                                
                                                var array = self.navigationController?.viewControllers
                                                array?.removeLast()
                                                array?.append(vc)
                                                
                                                vc.no2receivedValueFromBeforeVC = String(email)
                                                vc.no3receivedValueFromBeforeVC = "\(jsondata["DATA"]["userProfileHead"]["name"])"
                                                
                                                self.navigationController?.setViewControllers(array!, animated: true)
                                                self.present(nvc, animated: true, completion: nil)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
        } else {
        }
    }
    
    func getDisplayDateString(_ timePeriod: Int) -> String {
        if timePeriod >= (12 * 30 * 24 * 60) {
            return "\(timePeriod / (12 * 30 * 24 * 60))년전"
        } else if timePeriod >= (30 * 24 * 60) {
            return "\(timePeriod / (30 * 24 * 60))개월전"
        } else if timePeriod >= (24 * 60) {
            return "\(timePeriod / (24 * 60))일전"
        } else if timePeriod >= 60 {
            return "\(timePeriod / 60)시간전"
        } else {
            return "\(timePeriod)분전"
        }
    }
    
    @objc func readMoreTapped(_ sender: UITapGestureRecognizer) {
        guard let label = sender.view as? UILabel,
              let cell = label.superview?.superview as? CommentCell,
              let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        let text = self.heroes[indexPath.row].rootCommentListDescription ?? ""
        cell.commentcontentLabel.attributedText = NSAttributedString(string: text)
        cell.commentcontentLabel.numberOfLines = 0
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }

    @objc func repleshowButtonTapped(_ sender: UIButton) {
        guard let cell = sender.superview?.superview as? UITableViewCell else { return }
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        var comment = self.heroes[indexPath.section]
        
        self.a(indexPath: indexPath) { replyCount in
            DispatchQueue.main.async {
                
                print("replyCount", replyCount)
                
                if replyCount == 0 {
                    print("No replies to show.")
                    return
                }
                
                print("Data source before updates: \(self.heroes.map { $0.expandedReplies })")
                
                if comment.isExpanded {
                    let currentReplies = self.heroes[indexPath.section].expandedReplies
                    comment.expandedReplies = min(comment.rootCommentListDescription!.count, 10)
                    
                    if currentReplies < replyCount {
                        self.heroes[indexPath.section].expandedReplies = min(currentReplies + 10, replyCount)
                        
                    } else {
                        self.heroes[indexPath.section].expandedReplies = 0
                        self.heroes[indexPath.section].isExpanded = false
                    }
                    print("Data source after updates1: \(self.heroes.map { $0.expandedReplies })")
                    
                    
                } else {
                    self.heroes[indexPath.section].expandedReplies = min(replyCount, 10)
                    self.heroes[indexPath.section].isExpanded = true
                }
            }
        }
    }
    
    @objc func replehideButtonTapped(_ sender: UIButton) {
        guard let cell = sender.superview?.superview as? UITableViewCell else {
            return
        }
        
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        guard indexPath.section < self.heroes.count else {
            print("Section out of range: \(indexPath.section)")
            return
        }
        
        let comment = self.heroes[indexPath.section]
        if comment.isExpanded {
            self.collapseComment(at: indexPath.section)
            sender.setImage(UIImage(named: "expand_icon"), for: .normal)
        } else {
            self.collapseComment(at: indexPath.section)
            sender.setImage(UIImage(named: "expand_icon"), for: .normal)
        }
    }
    
    private func collapseComment(at section: Int) {
        self.heroes[section].expandedReplies = 0
        self.heroes[section].isExpanded = false
        self.tableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }
}

extension CommentViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { //답글 추가
        return heroes.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let comment = self.heroes[section]
        if comment.isExpanded {
            let replyCount = min(comment.expandedReplies, replyCount)
            return replyCount + 2
            
        } else {
            return 2
        }
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let comment = heroes[indexPath.section]
        var shownReplies = min(comment.expandedReplies, replyCount)
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! CommentCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            
            if self.heroes[indexPath.section].likeYn == "Y"  {
                cell.likeButton.setImage(UIImage(named: "img_main_comment_like_main_on"), for: UIControl.State.normal)
                cell.WriterCommentLikeProfileImage.isHidden = true
                cell.WriterCommentLikeImage.isHidden = true
                
            } else if self.heroes[indexPath.section].likeYn == "N" || self.heroes[indexPath.section].likeYn == nil {
                cell.likeButton.setImage(UIImage(named: "img_main_comment_like_main_off"), for: UIControl.State.normal)
                
                cell.WriterCommentLikeProfileImage.isHidden = true
                cell.WriterCommentLikeImage.isHidden = true
            }
            
            if self.token == self.heroes[indexPath.section].email {
                if self.heroes[indexPath.section].creatorLikeSign == "Y" {
                    cell.WriterCommentLikeProfileImage.isHidden = false
                    cell.WriterCommentLikeImage.isHidden = false
                } else if self.heroes[indexPath.section].creatorLikeSign == "N" || self.heroes[indexPath.section].creatorLikeSign == nil {
                    cell.WriterCommentLikeProfileImage.isHidden = true
                    cell.WriterCommentLikeImage.isHidden = true
                }
            }
          
            if self.heroes[indexPath.section].creatorLikeSign == "Y" {
                cell.WriterCommentLikeProfileImage.isHidden = false
                cell.WriterCommentLikeImage.isHidden = false
            } else if self.heroes[indexPath.section].creatorLikeSign == "N" || self.heroes[indexPath.section].creatorLikeSign == nil {
                cell.WriterCommentLikeProfileImage.isHidden = true
                cell.WriterCommentLikeImage.isHidden = true
            }
            
            if self.heroes[indexPath.section].creatorSign == "N" || self.heroes[indexPath.section].creatorSign == nil {
                cell.AuthorCommentsTitleLabel.isHidden = true
                
                cell.commentwriternameLabel.snp.removeConstraints()
                cell.commentwriternameLabel.snp.makeConstraints { (make) in
                    make.top.equalToSuperview().offset(3)
                    make.leading.equalTo(cell.commentwriterprofileImage.snp.trailing).offset(10)
                }
                
                cell.dotLabel.snp.removeConstraints()
                cell.dotLabel.snp.makeConstraints { (make) in
                    make.leading.equalTo(cell.commentwriternameLabel.snp.trailing).offset(5)
                    make.top.equalTo(3)
                }
                
                cell.CommentWritingTimeLabel.snp.removeConstraints()
                cell.CommentWritingTimeLabel.snp.makeConstraints { (make) in
                    make.leading.equalTo(cell.dotLabel.snp.trailing).offset(5)
                    make.top.equalTo(5)
                }
                
                cell.contentView.setNeedsLayout()
                cell.contentView.layoutIfNeeded()
            }
          
            if self.heroes[indexPath.section].creatorSign == "Y" {
                cell.AuthorCommentsTitleLabel.isHidden = false
                
                cell.AuthorCommentsTitleLabel.snp.removeConstraints()
                cell.AuthorCommentsTitleLabel.snp.makeConstraints { (make) in
                    make.leading.equalTo(cell.commentwriternameLabel.snp.trailing).offset(5)
                    make.top.equalTo(5)
                }
                
                cell.dotLabel.snp.removeConstraints()
                cell.dotLabel.snp.makeConstraints { (make) in
                    make.leading.equalTo(cell.AuthorCommentsTitleLabel.snp.trailing).offset(5)
                    make.top.equalTo(3)
                }
                
                cell.contentView.setNeedsLayout()
                cell.contentView.layoutIfNeeded()
            }
          
            if self.heroes[indexPath.section].creatorSign == "Y" || self.heroes[indexPath.section].creatorLikeSign == "Y" {
                cell.WriterCommentLikeProfileImage.snp.removeConstraints()
                cell.WriterCommentLikeImage.snp.removeConstraints()
                
                cell.WriterCommentLikeProfileImage.snp.remakeConstraints { (make) in
                    make.width.height.equalTo(10)
                    make.leading.equalTo(cell.CommentWritingTimeLabel.snp.trailing).offset(15)
                    make.top.equalTo(8)
                }
                
                cell.WriterCommentLikeImage.snp.remakeConstraints { (make) in
                    make.width.height.equalTo(5)
                    make.leading.equalTo(cell.WriterCommentLikeProfileImage.snp.trailing).offset(-4)
                    make.top.equalTo(14)
                }
                
                cell.contentView.setNeedsLayout()
                cell.contentView.layoutIfNeeded()
            }
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.touchToPickPhoto))
            cell.commentwriterprofileImage.addGestureRecognizer(tapGesture)
            cell.commentwriterprofileImage.isUserInteractionEnabled = true
            cell.commentwriterprofileImage.tag = indexPath.section
            
            cell.likeButton.addTarget(self, action: #selector(self.likeButtonTapped), for: .touchUpInside)
            cell.likeButton.tag = indexPath.section
            
            DispatchQueue.main.async {
                let imageValue = self.heroes[indexPath.section].profileImg
                let imageURL = imageValue
                
                let url : URL! = URL(string: imageURL!)
                cell.commentwriterprofileImage.kf.setImage(with: url)
                
                
                if self.heroes[indexPath.row].creatorLikeProfImg != nil {
                    let imageValue2 = self.heroes[indexPath.row].creatorLikeProfImg
                    let imageURL2 = imageValue2
                    
                    let url2 : URL! = URL(string: imageURL2!)
                    cell.WriterCommentLikeProfileImage.kf.setImage(with: url2)
                }
            }
            
            cell.commentwriternameLabel.text = self.heroes[indexPath.section].name
            
            let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
            cell.commentcontentLabel.isUserInteractionEnabled = true
            cell.commentcontentLabel.tag = indexPath.row
            cell.commentcontentLabel.addGestureRecognizer(tapGesture2)
            cell.commentcontentLabel.text = self.heroes[indexPath.section].rootCommentListDescription
            cell.commentcontentLabel.sizeToFit()
            cell.commentcontentLabel.lineBreakMode = .byWordWrapping
            cell.commentcontentLabel.layoutIfNeeded()
            cell.commentcontentLabel.numberOfLines = 0
            
            let text = self.heroes[indexPath.section].rootCommentListDescription!
            let maxNumberOfLines = 2
            let size = (text as NSString).boundingRect(with: CGSize(width: cell.commentcontentLabel.bounds.width, height: .greatestFiniteMagnitude),
                                                       options: .usesLineFragmentOrigin,
                                                       attributes: [NSAttributedString.Key.font: cell.commentcontentLabel.font!],
                                                       context: nil)
            let numberOfLines = Int(ceil(size.height / cell.commentcontentLabel.font.lineHeight))
            if numberOfLines <= maxNumberOfLines {
                cell.commentcontentLabel.text = text
                
            } else if numberOfLines > maxNumberOfLines {
                let startIndex = text.startIndex
                let endIndex = text.index(startIndex, offsetBy: min(maxNumberOfLines * 20, text.count))
                //let endIndex = text.index(startIndex, offsetBy: min(maxNumberOfLines * 15, text.count))
                let truncatedText = String(text[startIndex..<endIndex])
                let readMoreText = NSMutableAttributedString(string: truncatedText + "... ")
                let readMoreAction = NSAttributedString(string: "더보기", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
                readMoreText.append(readMoreAction)
                cell.commentcontentLabel.attributedText = readMoreText
                
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(readMoreTapped))
                cell.commentcontentLabel.isUserInteractionEnabled = true
                cell.commentcontentLabel.addGestureRecognizer(tapGesture)
                
            } else {
            }
            
            let ab: Int? = self.heroes[indexPath.section].totCnt
            let bc = ab.map(String.init) ?? ""
            CommentCountLabel.text = "댓글 \(bc)개"
            if bc == "" {
                CommentCountLabel.text = "댓글 0개"
            }
          
            let x: Int? = self.heroes[indexPath.section].likeCnt
            let b = x.map(String.init) ?? ""
            cell.RootCommentLikeCountLabel.text = b
            if b == "" {
                cell.RootCommentLikeCountLabel.text = "0"
            
            let a: Int? = self.heroes[indexPath.section].timeperiod
            cell.CommentWritingTimeLabel.text = getDisplayDateString(a!)
            
            if self.heroes[indexPath.section].deleteYn == "Y" {
                cell.likeButton.isHidden = true
                cell.RootCommentLikeCountLabel.isHidden = true
                cell.dotLabel.isHidden = true
                cell.WriterCommentLikeProfileImage.isHidden = true
                cell.WriterCommentLikeImage.isHidden = true
                cell.AuthorCommentsTitleLabel.isHidden = true
                cell.CommentWritingTimeLabel.isHidden = true
                
                cell.selectionStyle = .none
                cell.isUserInteractionEnabled = false
                
                self.tableView.rowHeight = UITableView.automaticDimension
                self.tableView.estimatedRowHeight = UITableView.automaticDimension
                cell.commentcontentLabel.text = "삭제된 댓글 입니다."
                
            } else {
                cell.likeButton.isHidden = false
                cell.RootCommentLikeCountLabel.isHidden = false
                
                cell.CommentWritingTimeLabel.isHidden = false
                
                cell.selectionStyle = .none
                cell.isUserInteractionEnabled = true
            }
            
            return cell
        }
        
        if comment.isExpanded {
            if indexPath.row > 0 && indexPath.row <= shownReplies {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellId3", for: indexPath) as! ReplyCell
                cell.prepareForReuse() // 셀 초기화
                let adjustedIndex = indexPath.row - 1
                
                if adjustedIndex >= 0 && adjustedIndex < self.heroes2.count {
                    let post = self.heroes2[adjustedIndex]
                    cell.configure(post: post)
                    return cell
                } else {
                    print("Index out of range in self.heroes2 array.")
                    return UITableViewCell()
                }
            }
          
            else if indexPath.row == shownReplies + 1 {
                print("shownReplies", shownReplies)
                print("indexPath.row", indexPath.row)
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellId2", for: indexPath) as! CommentReplyCell
                
                cell.prepareForReuse()
                
                shownReplies = min(comment.expandedReplies, replyCount)
                cell.configure(isExpanded: comment.isExpanded, totalReplyCount: replyCount, shownReplies: shownReplies)
                
                cell.selectionStyle = .none
                cell.repleshowButton.isUserInteractionEnabled = true
                
                cell.repleshowButton.addTarget(self, action: #selector(self.repleshowButtonTapped), for: .touchUpInside)
                cell.replehideButton.addTarget(self, action: #selector(self.replehideButtonTapped), for: .touchUpInside)
                
                return cell
            }
        } else {
            // 답글이 펼쳐지지 않은 경우
            if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellId2", for: indexPath) as! CommentReplyCell
                cell.prepareForReuse()
                
                cell.selectionStyle = .none
                cell.repleshowButton.isUserInteractionEnabled = true
                cell.repleshowButton.addTarget(self, action: #selector(self.repleshowButtonTapped), for: .touchUpInside)

                self.a(indexPath: indexPath) { replyCount in
                    cell.configure(isExpanded: comment.isExpanded, totalReplyCount: replyCount, shownReplies: shownReplies)
                }
                cell.configure(isExpanded: comment.isExpanded, totalReplyCount: replyCount, shownReplies: shownReplies)
                
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        guard indexPath.section < self.heroes.count else {
            print("Index out of bounds. IndexPath.row: \(indexPath.row), heroes.count: \(self.heroes.count)")
            return
        }
        
        let hero = self.heroes[indexPath.section]
        let x = hero.email

        if token == x {
            tableView.allowsSelection = true
            selectedComment = hero
            tableView.deselectRow(at: indexPath, animated: true)
            
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let reportAction = UIAlertAction(title: "댓글 수정", style: .default) { (action) in
                self.makeInputAccessoryView2()
                self.inputTextField.resignFirstResponder()
                self.newTF2.becomeFirstResponder()
                self.inputAccessoryView?.becomeFirstResponder()
                
                self.newTF2.text = hero.rootCommentListDescription
                self.newTF2.textColor = UIColor.black
            }
            
            let blockAction = UIAlertAction(title: "댓글 삭제", style: .destructive) { (action) in
                let url = NetworkProtocol.COMMENT_DELETE_REQ
                let headers: HTTPHeaders = ["SESSION": self.token2]
                print("홈-추천 댓글 댓글 수정 headers:", headers)
                
                let parameters: Parameters = ["commentId": hero.id!]
                print("홈-추천 댓글 댓글 수정 parameters:", parameters)
                
                AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { response in
                    if let JSON = response.value {
                        print("홈-추천 댓글 댓글 수정 목록 JSON:", JSON)
                    }
                    
                    if let value = response.value {
                        let jsondata = JSON(value)
                        print("홈-추천 댓글 댓글 수정 jsondata:", jsondata)
                        print("홈-추천 댓글 댓글 수정 RESN:", jsondata["RESN"])
                        print("홈-추천 댓글 댓글 수정 RSLT:", jsondata["RSLT"])
                        
                        if jsondata["RSLT"] == "S" {
                            self.makeInputAccessoryView()
                            self.viewAcc.layer.addBorder([.top, .bottom], color: UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 0.5), width: 1)
                            self.inputTextField.layer.addBorder([.top, .bottom], color: UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 0.5), width: 1)
                            
                            let alert = UIAlertController(title: "알림", message: "댓글이 삭제되었습니다.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: NSLocalizedString("확인", comment: "Default action"), style: .default) { _ in
                                self.tableView.reloadData()
                                self.view.endEditing(true)
                                self.CommentListExample()
                            })
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
            
            let replyAction = UIAlertAction(title: "답글 달기", style: .default) { (action) in
                self.makeInputAccessoryView3()
                self.inputTextField.resignFirstResponder()
                self.newTF3.becomeFirstResponder()
                self.inputAccessoryView?.becomeFirstResponder()
                
                self.newTF3.text = nil
                self.newTF3.textColor = UIColor.black
            }
            
            let cancelAction = UIAlertAction(title: "취소", style: .cancel) { (action) in }
            
            alert.addAction(reportAction)
            alert.addAction(blockAction)
            alert.addAction(cancelAction)
            alert.addAction(replyAction)
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let reportAction = UIAlertAction(title: "댓글 내용 복사하기", style: .default) { (action) in
                let customlabel1 = hero.rootCommentListDescription
                let pasteboard = UIPasteboard.general
                pasteboard.string = "\(customlabel1 ?? "")"
                
                let alert = UIAlertController(title: "알림", message: "댓글이 복사되었습니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("확인", comment: "Default action"), style: .default) { _ in
                    self.tableView.reloadData()
                    self.view.endEditing(true)
                })
                self.present(alert, animated: true, completion: nil)
            }
            
            let blockAction = UIAlertAction(title: "댓글 신고하기", style: .destructive) { (action) in
                let url = NetworkProtocol.COMMENT_DECLARE_REQ
                
                let headers: HTTPHeaders = [
                    "SESSION": self.token2
                ]
                print("headers:", headers)
                
                let parameters: Parameters = [
                    "commentId": hero.id!
                ]
                print("홈-추천 댓글 댓글 신고 parameters:", parameters)
                
                AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { response in
                    print(response)
                    
                    if let JSON = response.value {
                        print("홈-추천 댓글 댓글 신고 JSON:", JSON)
                    }
                    
                    if let value = response.value {
                        let jsondata = JSON(value)
                        print("홈-추천 댓글 댓글 신고 jsondata:", jsondata)
                        print("홈-추천 댓글 댓글 신고 RESN:", jsondata["RESN"])
                        print("홈-추천 댓글 댓글 신고 RSLT:", jsondata["RSLT"])
                        
                        if jsondata["RSLT"] == "S" {
                             alert = UIAlertController(title: "알림", message: "댓글이 신고되었습니다.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: NSLocalizedString("확인", comment: "Default action"), style: .default) { _ in
                                self.dismiss(animated: true, completion: nil)
                                self.tableView.reloadData()
                                self.view.endEditing(true)
                            })
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
            
            let cancelAction = UIAlertAction(title: "취소", style: .cancel) { (action) in }
            
            alert.addAction(reportAction)
            alert.addAction(blockAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension CommentViewController: UITextViewDelegate {
    
}

extension CommentViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}

//태그 추가
extension CommentViewController: CommentInputHashTagViewProtocol {
    func setUpAttributeString(of string: NSMutableAttributedString) {
        attrNSString = string
    }
    
    func passLastWord(of string: String, type: CommentTagType) {
        switch type {
        case .hashTag:
            let url = NetworkProtocol.SEARCH_TAG_LIST
            
            AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String: Any],
                       let data = json["DATA"] as? [String: Any],
                       let tagList = data["searchTaglist"] as? [[String: String]] {
                        
                        for tagInfo in tagList {
                            if let tagName = tagInfo["tagName"] {
                                if !self.hashTagView.tags.contains(tagName) {
                                    self.hashTagView.tags.insert(tagName, at: 0)
                                    print(tagName)
                                }
                            }
                        }
                        self.hashTagView.isHidden = false
                        self.tableView.isHidden = true
                    }
                    
                case .failure(let error):
                    print("Error: \(error)")
                }
            })
            
        case .mention:
            let url = NetworkProtocol.FOLLOWING_LIST_REQ
            
            let headers: HTTPHeaders = [
                "SESSION": token2
            ]
            
            AF.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String: Any],
                       let data = json["DATA"] as? [String: Any],
                       let tagList = data["followingList"] as? [[String: String]] {
                        
                        for tagInfo in tagList {
                            //userCode, name
                            if let tagName = tagInfo["userCode"] {
                                if !self.hashTagView.tags.contains(tagName) {
                                    self.hashTagView.tags.insert("@" + tagName, at: 0)
                                }
                            }
                        }
                        self.hashTagView.isHidden = false
                        self.tableView.isHidden = true
                    }
                    
                case .failure(let error):
                    print("Error: \(error)")
                }
            })
        }
    }
}
