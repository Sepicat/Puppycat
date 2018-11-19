//
//  ViewController.swift
//  PuppycatSample
//
//  Created by Gua on 2018/8/28.
//  Copyright © 2018 Gua. All rights reserved.
//

import UIKit
import Puppycat
import Straycat
import SnapKit

class ViewController: UIViewController {

    var count = [String]()
    var repos = [String]()

    var aaChartView: AAChartView = {
        let view = AAChartView()
        return view
    }()
    var chartModel: AAChartModel = AAChartModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(aaChartView)
        aaChartView.snp.makeConstraints { make in
            make.right.left.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(150)
            make.bottom.equalToSuperview().offset(-50)
        }
        test_aa()
    }
}

// MARK: - AAInfographics
extension ViewController {
    func test_aa() {
        StrayAnalysis.shared.fetchUserAnalysis(type: .psfg, login: "Desgard") { success, analysis in
            guard let topRepos = analysis?.topStarRepos else { return }
            let count = topRepos.enumerated().filter { $0.0 < 10 }.map { Int($0.1.starCount ?? 0) }
            let repos = topRepos.enumerated().filter { $0.0 < 10 }.map { $0.1.name }

            self.chartModel.categories(repos)
                .chartType(.bar)
                .legendEnabled(true)
                .colorsTheme(["#fe117c"])
                .animationType(.easeFrom)
                .animationDuration(1200)
                .series([
                    AASeriesElement()
                        .name("Star")
                        .data(count)
                        .toDic()!,
                ])

            DispatchQueue.main.async {
                self.aaChartView.aa_drawChartWithChartModel(self.chartModel)
            }
        }
    }
}

// MARK: - Charts
extension ViewController {}

func generateRandomColor() -> UIColor {
    let hue : CGFloat = CGFloat(arc4random() % 256) / 256 // use 256 to get full range from 0.0 to 1.0
    let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from white
    let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from black

    return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
}

