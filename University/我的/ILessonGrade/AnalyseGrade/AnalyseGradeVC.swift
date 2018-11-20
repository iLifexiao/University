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
    
    var sectionTitles = ["成绩柱状图", "绩点折线图", "通过率"]
    var sectionOneCell = "sectionOneCell"
    var sectionTwoCell = "sectionTwoCell"
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
        // 清空-空Cell
        tableView.tableFooterView = UIView()
    }
    
    // 设置柱状图
    private func setup(barLineChartView chartView: BarLineChartViewBase) {
        chartView.chartDescription?.enabled = false
        
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = false
        
        // ChartYAxis *leftAxis = chartView.leftAxis;
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        
        chartView.rightAxis.enabled = false
    }
    
    // 设置饼状图
    private func setup(pieChartView chartView: PieChartView) {
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
        
        let centerText = NSMutableAttributedString(string: "Charts\nby Daniel Cohen Gindi")
        centerText.setAttributes([.font : UIFont(name: "HelveticaNeue-Light", size: 13)!,
                                  .paragraphStyle : paragraphStyle], range: NSRange(location: 0, length: centerText.length))
        centerText.addAttributes([.font : UIFont(name: "HelveticaNeue-Light", size: 11)!,
                                  .foregroundColor : UIColor.gray], range: NSRange(location: 10, length: centerText.length - 10))
        centerText.addAttributes([.font : UIFont(name: "HelveticaNeue-Light", size: 11)!,
                                  .foregroundColor : UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)], range: NSRange(location: centerText.length - 19, length: 19))
        chartView.centerAttributedText = centerText;
        
        chartView.drawHoleEnabled = true
        chartView.rotationAngle = 0
        chartView.rotationEnabled = true
        chartView.highlightPerTapEnabled = true
        
        let l = chartView.legend
        l.horizontalAlignment = .right
        l.verticalAlignment = .top
        l.orientation = .vertical
        l.drawInside = false
        l.xEntrySpace = 7
        l.yEntrySpace = 0
        l.yOffset = 0
        //        chartView.legend = l
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
        tipsHeaderView.setTips(title: sectionTitles[section])
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
                
                let l = chartView.legend
                l.horizontalAlignment = .right
                l.verticalAlignment = .top
                l.orientation = .vertical
                l.xEntrySpace = 7
                l.yEntrySpace = 0
                l.yOffset = 0
                //        chartView.legend = l
                
                // entry label styling
                chartView.entryLabelColor = .white
                chartView.entryLabelFont = .systemFont(ofSize: 12, weight: .light)
                
                chartView.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
            }
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: sectionTwoCell) ?? UITableViewCell(style: .default, reuseIdentifier: sectionTwoCell)
            if cell.contentView.subviews.count == 0 {
                let chartView = BarChartView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 300))
                setup(barLineChartView: chartView)
                
                chartView.delegate = self
                
                chartView.drawBarShadowEnabled = false
                chartView.drawValueAboveBarEnabled = false
                
                chartView.maxVisibleCount = 60
                
                let xAxis = chartView.xAxis
                xAxis.labelPosition = .bottom
                xAxis.labelFont = .systemFont(ofSize: 10)
                xAxis.granularity = 1
                xAxis.labelCount = 7
                xAxis.valueFormatter = DayAxisValueFormatter(chart: chartView)
                
                let leftAxisFormatter = NumberFormatter()
                leftAxisFormatter.minimumFractionDigits = 0
                leftAxisFormatter.maximumFractionDigits = 1
                leftAxisFormatter.negativeSuffix = " $"
                leftAxisFormatter.positiveSuffix = " $"
                
                let leftAxis = chartView.leftAxis
                leftAxis.labelFont = .systemFont(ofSize: 10)
                leftAxis.labelCount = 8
                leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
                leftAxis.labelPosition = .outsideChart
                leftAxis.spaceTop = 0.15
                leftAxis.axisMinimum = 0 // FIXME: HUH?? this replaces startAtZero = YES
                
                let rightAxis = chartView.rightAxis
                rightAxis.enabled = true
                rightAxis.labelFont = .systemFont(ofSize: 10)
                rightAxis.labelCount = 8
                rightAxis.valueFormatter = leftAxis.valueFormatter
                rightAxis.spaceTop = 0.15
                rightAxis.axisMinimum = 0
                
                let l = chartView.legend
                l.horizontalAlignment = .left
                l.verticalAlignment = .bottom
                l.orientation = .horizontal
                l.drawInside = false
                l.form = .circle
                l.formSize = 9
                l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
                l.xEntrySpace = 4
                //        chartView.legend = l
                
                let marker = XYMarkerView(color: UIColor(white: 180/250, alpha: 1),
                                          font: .systemFont(ofSize: 12),
                                          textColor: .white,
                                          insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8),
                                          xAxisValueFormatter: chartView.xAxis.valueFormatter!)
                marker.chartView = chartView
                marker.minimumSize = CGSize(width: 80, height: 40)
                chartView.marker = marker
            }
            cell.selectionStyle = .none
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: sectionThreeCell) ?? UITableViewCell(style: .default, reuseIdentifier: sectionThreeCell)
            if cell.contentView.subviews.count == 0 {
                let chartView = LineChartView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 300))
                chartView.delegate = self
                
                chartView.chartDescription?.enabled = false
                chartView.dragEnabled = true
                chartView.setScaleEnabled(true)
                chartView.pinchZoomEnabled = true
                
                // x-axis limit line
                let llXAxis = ChartLimitLine(limit: 10, label: "Index 10")
                llXAxis.lineWidth = 4
                llXAxis.lineDashLengths = [10, 10, 0]
                llXAxis.labelPosition = .rightBottom
                llXAxis.valueFont = .systemFont(ofSize: 10)
                
                chartView.xAxis.gridLineDashLengths = [10, 10]
                chartView.xAxis.gridLineDashPhase = 0
                
                let ll1 = ChartLimitLine(limit: 150, label: "Upper Limit")
                ll1.lineWidth = 4
                ll1.lineDashLengths = [5, 5]
                ll1.labelPosition = .rightTop
                ll1.valueFont = .systemFont(ofSize: 10)
                
                let ll2 = ChartLimitLine(limit: -30, label: "Lower Limit")
                ll2.lineWidth = 4
                ll2.lineDashLengths = [5,5]
                ll2.labelPosition = .rightBottom
                ll2.valueFont = .systemFont(ofSize: 10)
                
                let leftAxis = chartView.leftAxis
                leftAxis.removeAllLimitLines()
                leftAxis.addLimitLine(ll1)
                leftAxis.addLimitLine(ll2)
                leftAxis.axisMaximum = 200
                leftAxis.axisMinimum = -50
                leftAxis.gridLineDashLengths = [5, 5]
                leftAxis.drawLimitLinesBehindDataEnabled = true
                
                chartView.rightAxis.enabled = false
                
                //[_chartView.viewPortHandler setMaximumScaleY: 2.f];
                //[_chartView.viewPortHandler setMaximumScaleX: 2.f];
                
                let marker = BalloonMarker(color: UIColor(white: 180/255, alpha: 1),
                                           font: .systemFont(ofSize: 12),
                                           textColor: .white,
                                           insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
                marker.chartView = chartView
                marker.minimumSize = CGSize(width: 80, height: 40)
                chartView.marker = marker
                
                chartView.legend.form = .line
                
                chartView.animate(xAxisDuration: 2.5)
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
