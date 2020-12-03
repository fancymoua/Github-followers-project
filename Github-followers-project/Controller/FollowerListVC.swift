

import UIKit

class FollowerListVC: UIViewController {
    
    enum Section {
        case main
    }
    
    var username: String!
    var followersArray: [Follower] = []
    
    var collectionView: UICollectionView!
    var datasource: UICollectionViewDiffableDataSource<Section, Follower>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureVC()
        configureCollectionView()
        getFollowers()
        configureDataSource()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func getFollowers() {
        NetworkManager.shared.getFollowers(for: username, page: 1) { [weak self] (followers, errorMessage) in
            guard let self = self else { return }   // self is optional
            
            guard let followers = followers else {
                self.presentGFAlertOnMainThread(title: "Error!", message: errorMessage!.rawValue, buttonTitle: "Okay")
                return
            }
            
            self.followersArray = followers
            self.updateData()
            
            print(followers.count)
            print(followers)
        }
    }
    
    func configureDataSource() {
        datasource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
            
            cell.set(follower: follower)
            
            return cell
        })
    }
    
    func updateData() {
        // needs section and needs object
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        
        // main is pulling from Section enum
        snapshot.appendSections([.main])
        
        snapshot.appendItems(followersArray)
        
        DispatchQueue.main.async {
            self.datasource.apply(snapshot, animatingDifferences: true)
        }
    }

}

extension FollowerListVC {
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        
        view.addSubview(collectionView)
        
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }
    
    func configureVC() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
