//
//  ViewController.swift
//  PuppycatSample
//
//  Created by Gua on 2018/8/28.
//  Copyright © 2018 Gua. All rights reserved.
//

import UIKit
import Puppycat
import XJYChart
import Straycat
import SnapKit
import Charts

class ViewController: UIViewController {

    var chartView: PieChartView = {
        let pieChartView = PieChartView()
        pieChartView.backgroundColor = UIColor.clear
        //基本样式
//        pieChartView.delegate = self
        return pieChartView
    }()
    var count = [Double]()
    var repos = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        test()
        view.addSubview(chartView)

        chartView.snp.makeConstraints { make in
            make.left.equalTo(self.view).offset(5)
            make.top.equalTo(self.view).offset(64)
            make.right.equalTo(self.view).offset(-5)
            make.height.equalTo(300)
        }

    }

    func test() {
        StrayAnalysis.shared.fetchUserAnalysis(type: .psfg, login: "Desgard") { success, analysis in
            guard let toprepos = analysis?.topStarRepos else {
                return
            }
            self.count = toprepos.map { Double($0.starCount ?? 0) }
            self.repos = toprepos.map { $0.name }

            self.setChart(dataPoints: self.repos, values: self.count)
        }
    }

    func setChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let entry = PieChartDataEntry(value: values[i], label: "\(dataPoints[i])") //设置数据 title和对应的值

            dataEntries.append(entry)
        }


        let pichartDataSet = PieChartDataSet(values: dataEntries, label: "Stars Repos Top10") //设置表示
        //设置饼状图字体配置
        setPieChartDataSetConfig(pichartDataSet: pichartDataSet)


        let pieChartData = PieChartData(dataSet: pichartDataSet)
        //设置饼状图字体样式
        setPieChartDataConfig(pieChartData: pieChartData)
        chartView.data = pieChartData //将配置及数据添加到表中


        //设置饼状图样式
        setDrawHoleState()

        var colors: [UIColor] = []
        for _ in 0..<dataPoints.count {
            colors.append(generateRandomColor())
        }

        pichartDataSet.colors = colors//设置区块颜色
    }

    //设置饼状图字体配置
    func setPieChartDataSetConfig(pichartDataSet: PieChartDataSet){
        pichartDataSet.sliceSpace = 0 //相邻区块之间的间距
        pichartDataSet.selectionShift = 8 //选中区块时, 放大的半径
        pichartDataSet.xValuePosition = .insideSlice //名称位置
        pichartDataSet.yValuePosition = .outsideSlice //数据位置
        //数据与区块之间的用于指示的折线样式
        pichartDataSet.valueLinePart1OffsetPercentage = 0.85 //折线中第一段起始位置相对于区块的偏移量, 数值越大, 折线距离区块越远
        pichartDataSet.valueLinePart1Length = 0.5 //折线中第一段长度占比
        pichartDataSet.valueLinePart2Length = 0.4 //折线中第二段长度最大占比
        pichartDataSet.valueLineWidth = 1 //折线的粗细
        pichartDataSet.valueLineColor = UIColor.gray //折线颜色


    }

    //设置饼状图字体样式
    func setPieChartDataConfig(pieChartData: PieChartData){

        pieChartData.setValueTextColor(UIColor.gray) //字体颜色为白色
        pieChartData.setValueFont(UIFont.systemFont(ofSize: 10))//字体大小
    }


    //设置饼状图中心文本
    func setDrawHoleState(){
        ///饼状图距离边缘的间隙
        chartView.setExtraOffsets(left: 30, top: 0, right: 30, bottom: 0)
        //拖拽饼状图后是否有惯性效果
        chartView.dragDecelerationEnabled = true
        //是否显示区块文本
        chartView.drawSlicesUnderHoleEnabled = true
        //是否根据所提供的数据, 将显示数据转换为百分比格式
        chartView.usePercentValuesEnabled = true

        // 设置饼状图描述
        chartView.chartDescription?.text = "饼状年龄库图示例"
        chartView.chartDescription?.font = UIFont.systemFont(ofSize: 10)
        chartView.chartDescription?.textColor = UIColor.gray

        // 设置饼状图图例样式
        chartView.legend.maxSizePercent = 1 //图例在饼状图中的大小占比, 这会影响图例的宽高
        chartView.legend.formToTextSpace = 5 //文本间隔
        chartView.legend.font = UIFont.systemFont(ofSize: 10) //字体大小
        chartView.legend.textColor = UIColor.gray //字体颜色
        chartView.legend.verticalAlignment = .bottom //图例在饼状图中的位置
        chartView.legend.form = .circle //图示样式: 方形、线条、圆形
        chartView.legend.formSize = 12 //图示大小
        chartView.legend.orientation = .horizontal
        chartView.legend.horizontalAlignment = .center

        //        pieChartView.centerText = "平均库龄" //饼状图中心的文本
        ////饼状图中心的富文本文本
//        let attributes = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: CGFloat(15.0)), NSForegroundColorAttributeName: UIColor.gray]
//        let centerTextAttribute = NSAttributedString(string: "平均库龄", attributes: attributes)
//        pieChartView.centerAttributedText = centerTextAttribute



        /*
         ///设置饼状图中心的文本
         if pieChartView.isDrawHoleEnabled {
         ///设置饼状图中间的空心样式
         pieChartView.drawHoleEnabled = true //饼状图是否是空心
         pieChartView.holeRadiusPercent = 0.5 //空心半径占比
         pieChartView.holeColor = UIColor.clear //空心颜色
         pieChartView.transparentCircleRadiusPercent = 0.52 //半透明空心半径占比
         pieChartView.transparentCircleColor = UIColor(r: 210, g: 145, b: 165, 0.3) //半透明空心的颜色
         pieChartView.drawCenterTextEnabled = true //是否显示中间文字
         //普通文本
         //pieChartView.centerText = "平均库龄"
         //富文本
         let attributes = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: CGFloat(15.0)), NSForegroundColorAttributeName: UIColor.red]
         let centerTextAttribute = NSAttributedString(string: "平均库龄", attributes: attributes)
         pieChartView.centerAttributedText = centerTextAttribute
         }
         */

        chartView.setNeedsDisplay()


    }

}

func generateRandomColor() -> UIColor {
    let hue : CGFloat = CGFloat(arc4random() % 256) / 256 // use 256 to get full range from 0.0 to 1.0
    let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from white
    let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from black

    return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
}

