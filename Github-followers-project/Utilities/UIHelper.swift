
import UIKit


struct UIHelper {
    
    static func createThreeColumnFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let width = view.bounds.width           // total width of screen
        let padding: CGFloat = 12               //insets on left and right of whole collectionView
        let minimumItemSpacing: CGFloat = 10    // between each cell
        
        let availableWidth = width - (padding * 2) - (minimumItemSpacing * 2)
        
        let itemWidth = availableWidth / 3
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)
        
        return flowLayout
    }

    
    
}
