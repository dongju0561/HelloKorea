import UIKit
extension ContentListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // cell의 갯수 결정
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1 {
            return 5
        }
        else if(collectionView.tag == 2){
            return 5
        }
        else if(collectionView.tag == 3){
            return 5
        }
        else{
            return 5
        }
    }
    
    //cell별 특성 정의
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CSCollectionViewCell
        // UICollectionViewCell의 subclass인 CSCollectionViewCellfh 타입캐스팅
        
        if collectionView.tag == 1 {
            cell.contentView.backgroundColor = .black
        }
        else if(collectionView.tag == 2){
            cell.contentView.backgroundColor = .red
        }
        else if(collectionView.tag == 3){
            cell.contentView.backgroundColor = .yellow
        }
        else{
            cell.contentView.backgroundColor = .blue
        }
                
        return cell
    }
    
    //collectionView cell 크기 설정 함수
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{

        let width = collectionView.bounds.width
        let height = collectionView.bounds.height
        
        if collectionView.tag == 1 {
            
            return CGSize(width: width/1.9, height: height)
        }
        else{
            return CGSize(width: width/3.5, height: height)
        }
    }
    
    }
