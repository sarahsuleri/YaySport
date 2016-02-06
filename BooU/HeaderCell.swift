//
//  HeaderCell.swift
//  BooU
//
//  Created by Omar Tawfik on 04/02/16.
//  Copyright © 2016 Daria. All rights reserved.
//

import UIKit

class HeaderCell: UITableViewCell, PiechartDelegate {
    
    
    func createViews () {
        
      
        
        for view in self.subviews{
            view.removeFromSuperview()
        }
        
        let bounds = UIScreen.mainScreen().bounds
        let shiftInX:CGFloat = (bounds.width - 270) / 3.0
        
        
        let viewSteps = UIView(frame: CGRect(x: 10 + shiftInX/3, y: -5, width: 80, height: 130))
        let viewMiles = UIView(frame: CGRect(x: 50 + 2*shiftInX/3 , y: -5, width: 80, height: 130))
        let viewFloors = UIView(frame: CGRect(x: 90 + shiftInX, y: -5, width: 80, height: 130))
        
     
   
   
        
        createChart(viewSteps, chartID: 1)
        createChart(viewMiles, chartID: 2)
        createChart(viewFloors, chartID: 3)
        
        self.addSubview(viewSteps)
        self.addSubview(viewMiles)
        self.addSubview(viewFloors)
        
     
    
    }
    
    func createChart(view:UIView, chartID:Int){
        
        var progress = Piechart.Slice()
        progress.color = UIColor.Yay()
        
        var needed = Piechart.Slice()
        
        let pieChart = Piechart (frame: view.frame)
        pieChart.delegate = self
        
        
        switch chartID
        {
        case 1:
            progress.text = ""
            progress.value = CGFloat (YayMgr.currentStats.numberOfSteps) / CGFloat (YayMgr.userSettings.maxSteps)
            if progress.value > 1 {progress.value = 1}
            needed.value = 1 - progress.value
            pieChart.title = "Steps"
            
        case 2:
            progress.text = ""
            progress.value = CGFloat (YayMgr.currentStats.numberOfMiles) / CGFloat (YayMgr.userSettings.maxMiles)
            if progress.value > 1 {progress.value = 1}
            needed.value = 1 - progress.value
            pieChart.title = "Miles"
            
        default:
            progress.text = ""
            progress.value = CGFloat (YayMgr.currentStats.numberOfFloors) / CGFloat (YayMgr.userSettings.maxFloors)
            if progress.value > 1 {progress.value = 1}
            needed.value = 1 - progress.value
            pieChart.title = "Floors"
            
        }
        
        pieChart.slices = [progress,needed]
        view.addSubview(pieChart)
        
        
    }
    
    func setSubtitle(total: CGFloat, slice: Piechart.Slice) -> String {
        return "\(Int(slice.value / total * 100))% \(slice.text)"
    }
    
   

}
