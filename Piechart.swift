
import UIKit


public protocol PiechartDelegate {
    func setSubtitle(total: CGFloat, slice: Piechart.Slice) -> String
 
}



/**
 * Piechart
 */
public class Piechart: UIControl {
    
    /**
     * Slice
     */
    public struct Slice {
        public var color: UIColor!
        public var value: CGFloat!
        public var text: String!
    }
    
    /**
     * Radius
     */
    public struct Radius {
        public var inner: CGFloat = 40
        public var outer: CGFloat = 60
    }
    
    /**
     * private
     */
    private var titleLabel: UILabel!
    private var subtitleLabel: UILabel!
    private var total: CGFloat!
    
    
    /**
     * public
     */
    public var radius: Radius = Radius()
    public var activeSlice: Int = 0
    public var delegate: PiechartDelegate?
    
    public var title: String = "title" {
        didSet {
            titleLabel.text = title
        }
    }
    
    public var subtitle: String = "subtitle" {
        didSet {
            subtitleLabel.text = subtitle
        }
    }
    

    
    public var slices: [Slice] = [] {
        didSet {
            total = 0
            for slice in slices {
                total = slice.value + total
            }
        }
    }
    
    
    
    /**
     * methods
     */
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        
   
        
        titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        titleLabel.textAlignment = .Center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
        
        subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
        subtitleLabel.textColor = UIColor.grayColor()
        subtitleLabel.textAlignment = .Center
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(subtitleLabel)
        
     
        
        self.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: subtitleLabel, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: subtitleLabel, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))
        
       
    }
    
    convenience init() {
        self.init(frame: CGRectZero)
    }
    
    public override func drawRect(rect: CGRect) {
        super.drawRect(rect)

        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        var startValue: CGFloat = 0
        var startAngle: CGFloat = 0
        var endValue: CGFloat = 0
        var endAngle: CGFloat = 0
        
        for (index, slice) in slices.enumerate() {
            
            startAngle = (startValue * 2 * CGFloat(M_PI)) - CGFloat(M_PI_2)
            endValue = startValue + (slice.value / self.total)
            endAngle = (endValue * 2 * CGFloat(M_PI)) - CGFloat(M_PI_2)
            
            let path = UIBezierPath()
            path.moveToPoint(center)
            path.addArcWithCenter(center, radius: radius.outer, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            
            var color = UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1)
            if (index == activeSlice) {
                color = slice.color
                subtitle = delegate?.setSubtitle(self.total, slice: slice) ?? "subtitle"
          
            }
            color.setFill()
            path.fill()
            
            // add white border to slice
            UIColor.whiteColor().setStroke()
            path.stroke()
            
            // increase start value for next slice
            startValue += slice.value / self.total
        }
        
        // create center donut hole
        let innerPath = UIBezierPath()
        innerPath.moveToPoint(center)
        innerPath.addArcWithCenter(center, radius: radius.inner, startAngle: 0, endAngle: CGFloat(M_PI) * 2, clockwise: true)
        UIColor.whiteColor().setFill()
        innerPath.fill()
    }
    

    
}