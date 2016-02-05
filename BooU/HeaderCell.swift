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
        let shiftInX:CGFloat = (bounds.width - 365) / 3.0
        
        
        let viewSteps = UIView(frame: CGRect(x: 1, y: 0, width: 120, height: 130))
        let viewMiles = UIView(frame: CGRect(x: 60 + shiftInX/2 , y: 0, width: 120, height: 130))
        let viewFloors = UIView(frame: CGRect(x: 120 + shiftInX, y: 0, width: 120, height: 130))
        
     
   
   
        
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
            progress.text = "steps cut"
            progress.value = CGFloat (YayMgr.currentSteps) / CGFloat (YayMgr.userSettings.maxSteps)
            needed.value = 1 - progress.value
            pieChart.title = "Steps"
            
        case 2:
            progress.text = "miles cut"
            progress.value = CGFloat (YayMgr.currentMiles) / CGFloat (YayMgr.userSettings.maxMiles)
            needed.value = 1 - progress.value
            pieChart.title = "Miles"
            
        default:
            progress.text = "floors cut"
            progress.value = CGFloat (YayMgr.currentFloors) / CGFloat (YayMgr.userSettings.maxFloors)
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
