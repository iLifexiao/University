//
//  QuestionVC.swift
//  University
//
//  Created by 肖权 on 2018/10/26.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

class QuestionVC: UIViewController {
    
    private var questions: [QuestionModel] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        initData()
    }
    
    private func setupTableView() {
        tableView.register(UINib.init(nibName: "QuestionCell", bundle: nil), forCellReuseIdentifier: "QuestionCell")
    }
    
    private func initData() {
        let question1 = QuestionModel(id: "1", question: "和猫睡一个被窝，有什么风险？", answerCount: 12)
        let question2 = QuestionModel(id: "2", question: "如何看待 Google 为应对欧盟的反垄断裁决，将在欧洲对 Android 进行收费？", answerCount: 234)
        let question3 = QuestionModel(id: "3", question: "你身边有哪些让你笑到窒息的事？", answerCount: 664)
        questions = [question1, question2, question3]
    }
}

extension QuestionVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 1
        default:
            return 10
        }
    }
}

extension QuestionVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath) as! QuestionCell
        cell.setupData(questions[indexPath.section])
        cell.selectionStyle = .none
        return cell
    }
}

