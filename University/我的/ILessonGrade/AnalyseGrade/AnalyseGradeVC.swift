//
//  AnalyseGradeVC.swift
//  University
//
//  Created by 肖权 on 2018/11/20.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit
import Charts

class AnalyseGradeVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    // 成绩
    var lessonGrades: [LessonGrade] = []
    private var passValue = 50.0
    private var points: [Float] = []
    
    var sectionTitles = ["通过率", "绩点图"]
    var sectionOneCell = "sectionOneCell"
//    var sectionTwoCell = "sectionTwoCell"
    var sectionThreeCell = "sectionThreeCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    
    private func initData() {
        var passCount = 0
        for lesson in lessonGrades {
            if lesson.grade >= 60 {
                passCount += 1
            }
            points.append(lesson.gradePoint)
        }
        passValue = Double(passCount) * 100.0 / Double(lessonGrades.count)
    }
    
    private func initUI() {
        title = "成绩分析"
        setupTableView()
    }
    
    private func setupTableView() {
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        tableView.tableFooterView = UIView()
    }
    
    // MARK: 图标样式
    // 设置柱状图
    private func setup(barLineChartView chartView: BarLineChartViewBase) {
        chartView.chartDescription?.enabled = false
        
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = false
        
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        
        chartView.rightAxis.enabled = false
    }
    
    // 设置饼状图
    private func setup(pieChartView chartView: PieChartView) {
        // 1. 设置样式
        chartView.usePercentValuesEnabled = true
        chartView.drawSlicesUnderHoleEnabled = false
        chartView.holeRadiusPercent = 0.58
        chartView.transparentCircleRadiusPercent = 0.61
        chartView.chartDescription?.enabled = false
        chartView.setExtraOffsets(left: 5, top: 10, right: 5, bottom: 5)
        
        chartView.drawCenterTextEnabled = true
        
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = .center
        
        
        chartView.drawHoleEnabled = true
        chartView.rotationAngle = 0
        chartView.rotationEnabled = true
        chartView.highlightPerTapEnabled = true
        
        // 表格样式
        let l = chartView.legend
        l.horizontalAlignment = .right
        l.verticalAlignment = .top
        l.orientation = .vertical
        l.drawInside = false
        l.xEntrySpace = 7
        l.yEntrySpace = 0
        l.yOffset = 0
    }
    
    // MARK: 图标数据
    // 设置饼状图数据
    func setDataCount(pieChartView chartView: PieChartView) {
        // 1. 设置DataEntry
        let entries = [
            PieChartDataEntry(value: Double(passValue), label: "通过"),
            PieChartDataEntry(value: Double(100 - passValue), label: "失败")
        ]
        
        // 2. 设置数据集合
        let set = PieChartDataSet(values: entries, label: "通过率")
        set.drawIconsEnabled = false
        set.sliceSpace = 2
        
        // 3. 设置显示颜色(春天绿色、红色)
        set.colors = [
            UIColor(red: 60/255, green: 179/255, blue: 113/255, alpha: 1),
            UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)
        ]
        
        // 4. 设置数据
        let data = PieChartData(dataSet: set)
        
        // 5. 设置数据格式
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        
        data.setValueFont(.systemFont(ofSize: 11, weight: .light))
        data.setValueTextColor(.white)
        
        // 6. 设置数据
        chartView.data = data
        chartView.highlightValues(nil)
    }
    
    func setDataCount(lineChartView chartView: LineChartView) {
        // [1, 2, 3]为设设置数据的基本步骤
        // 1. 设置DataEntry
        var values: [ChartDataEntry] = []
        for (index, point) in points.enumerated() {
            values.append(ChartDataEntry(x: Double(index), y: Double(point)))
        }
        
        // 2. 设置数据集合
        let set1 = LineChartDataSet(values: values, label: "绩点")
        set1.drawIconsEnabled = false
        
        // 3. 设置数据样式
        set1.lineDashLengths = [5, 2.5]
        set1.highlightLineDashLengths = [5, 2.5]
        set1.setColor(.black)
        set1.setCircleColor(.black)
        set1.lineWidth = 1
        set1.circleRadius = 3
        set1.drawCircleHoleEnabled = false
        set1.valueFont = .systemFont(ofSize: 9)
        set1.formLineDashLengths = [5, 2.5]
        set1.formLineWidth = 1
        set1.formSize = 15
        
        // 4.设置数据颜色(透明度 & 颜色)
        let gradientColors = [ChartColorTemplates.colorFromString("#ff0098A3").cgColor,
                              ChartColorTemplates.colorFromString("#000098A3").cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        
        set1.fillAlpha = 1
        set1.fill = Fill(linearGradient: gradient, angle: 90)
        set1.drawFilledEnabled = true
        
        // 5. 设置数据
        let data = LineChartData(dataSet: set1)
        chartView.data = data
    }
        
}

extension AnalyseGradeVC: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        NSLog("chartValueSelected");
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        NSLog("chartValueNothingSelected");
    }
    
    func chartScaled(_ chartView: ChartViewBase, scaleX: CGFloat, scaleY: CGFloat) {
        
    }
    
    func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat) {
        
    }
}

extension AnalyseGradeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
        
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let tipsHeaderView = Bundle.main.loadNibNamed("TipsHeaderView", owner: nil, options: nil)?[0] as! TipsHeaderView
        switch section {
        case 0:
            tipsHeaderView.setTips(title: sectionTitles[section], icon: #imageLiteral(resourceName: "pie"))
        case 1:
            tipsHeaderView.setTips(title: sectionTitles[section], icon: #imageLiteral(resourceName: "line"))
        default:
            print("NOT Here")
        }
        
        return tipsHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

// MARK: 数据源代理
extension AnalyseGradeVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: sectionOneCell) ?? UITableViewCell(style: .default, reuseIdentifier: sectionOneCell)
            if cell.contentView.subviews.count == 0 {
                let chartView = PieChartView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 300))
                setup(pieChartView: chartView)
                
                chartView.delegate = self
                
                // 设置表格
                let l = chartView.legend
                l.horizontalAlignment = .right
                l.verticalAlignment = .top
                l.orientation = .vertical
                l.xEntrySpace = 7
                l.yEntrySpace = 0
                l.yOffset = 0
                
                
                // 图标内字体样式
                chartView.entryLabelColor = .white
                chartView.entryLabelFont = .systemFont(ofSize: 14, weight: .light)
                
                chartView.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
                
                setDataCount(pieChartView: chartView)
                cell.contentView.addSubview(chartView)
            }
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: sectionThreeCell) ?? UITableViewCell(style: .default, reuseIdentifier: sectionThreeCell)
            if cell.contentView.subviews.count == 0 {
                let chartView = LineChartView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 300))
                chartView.delegate = self
                
                chartView.chartDescription?.enabled = false
                chartView.dragEnabled = true
                chartView.setScaleEnabled(true)
                chartView.pinchZoomEnabled = true
                
                // 绩点下限
                let limitlLine = ChartLimitLine(limit: 1.0, label: "及格线")
                limitlLine.lineWidth = 4
                limitlLine.lineDashLengths = [5,5]
                limitlLine.labelPosition = .rightTop
                limitlLine.valueFont = .systemFont(ofSize: 10)
                
                let leftAxis = chartView.leftAxis
                leftAxis.removeAllLimitLines()
                leftAxis.axisMaximum = 5
                leftAxis.axisMinimum = 0
                leftAxis.addLimitLine(limitlLine)
                leftAxis.gridLineDashLengths = [5, 5]
                leftAxis.drawLimitLinesBehindDataEnabled = true
                
                chartView.rightAxis.enabled = false
                
                // 点击显示的标记
                let marker = BalloonMarker(color: UIColor(white: 180/255, alpha: 1),
                                           font: .systemFont(ofSize: 12),
                                           textColor: .white,
                                           insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
                marker.chartView = chartView
                marker.minimumSize = CGSize(width: 80, height: 40)
                chartView.marker = marker
                
                chartView.legend.form = .line
                chartView.animate(xAxisDuration: 2.5)
                
                // 设置数据
                setDataCount(lineChartView: chartView)
                cell.contentView.addSubview(chartView)
            }
            cell.selectionStyle = .none
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
            cell.selectionStyle = .none
            return cell
        }
        
    }
}
