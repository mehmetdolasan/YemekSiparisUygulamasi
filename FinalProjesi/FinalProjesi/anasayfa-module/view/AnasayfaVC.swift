//
//  ViewController.swift
//  FinalProjesi
//
//  Created by Mehmet Dolasan on 24.03.2022.
//

import UIKit
import Kingfisher
import Alamofire
import Lottie

class AnasayfaVC: UIViewController {
    
    @IBOutlet weak var yemeklerCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var yemeklerListe = [Yemekler]()
    var yemeklerListeAra = [Yemekler]()
    
    //sepetteki yemek sayisini badge'e aktarmak için
    var gelenSepetListesi : [SepetYemekler] = []
    var gelenSepetSayisi = 0
    
    
    //Lottie
    var animationView : AnimationView?
    
    var anasayfaPresenterNesnesi : ViewToPresenterAnasayfaProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        yemeklerCollectionView.delegate = self
        yemeklerCollectionView.dataSource = self
        
        //MARK: Lottie
        yemeklerCollectionView.isHidden = true
        searchBar.isHidden = true
        animationView = .init(name: "loading-animation")
        animationView?.frame = view.bounds
        animationView?.loopMode = .playOnce
        animationView?.animationSpeed = 0.8
        animationView?.play(fromProgress: 0, toProgress: 1, loopMode: .playOnce){ (finished) in
            self.yemeklerCollectionView.isHidden = false
            self.searchBar.isHidden = false
            self.animationView?.removeFromSuperview()
        }
        view.addSubview(animationView!)
        //MARK: Lottie end
        
        
        AnasayfaRouter.createModule(ref: self)
        
        let tasarim = UICollectionViewFlowLayout()
        tasarim.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        tasarim.minimumLineSpacing = 20
        tasarim.minimumInteritemSpacing = 10
        let genislik = yemeklerCollectionView.frame.width
        let hucreGenislik = (genislik - 30) / 2
        tasarim.itemSize = CGSize(width: hucreGenislik, height: hucreGenislik*1.3)
        yemeklerCollectionView!.collectionViewLayout = tasarim
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Anasayfa ilk açıldığında ve anasayfayı geri dödüğümüzde çalışır.
        anasayfaPresenterNesnesi?.yemekleriListele()
        anasayfaPresenterNesnesi?.sepetiGetir()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetay" {
            let yemek = sender as? Yemekler
            let gidilecekVC = segue.destination as! YemekDetayVC
            gidilecekVC.yemek = yemek
        }
    }
    
}

extension AnasayfaVC : PresenterToViewAnasayfaProtocol {

    func vieweVeriGondor(yemeklerListesi: Array<Yemekler>) {
        self.yemeklerListe = yemeklerListesi

        //Searchbar'ın çalışması için yapıldı.
        self.yemeklerListeAra = self.yemeklerListe
        //anasayfada yemekleri isme göre sıralamak için 
        self.yemeklerListeAra.sort {
            $0.yemek_adi! < $1.yemek_adi!
        }
        DispatchQueue.main.async {
            self.yemeklerCollectionView.reloadData()
        }
    }
    //Anasayfa açılır açılmaz sepetteki yemek sayısı badge olarak gözükmesi için
    func vieweSepetListesiGonder(sepetListesi: Array<SepetYemekler>) {
        self.gelenSepetListesi = sepetListesi
        DispatchQueue.main.async {
         
            self.gelenSepetSayisi = sepetListesi.count
            
            if let tabBarItems = self.tabBarController?.tabBar.items {
                let tabItem = tabBarItems[1]
                tabItem.badgeValue = String(self.gelenSepetSayisi)
            }
            
        }
    }
}

extension AnasayfaVC : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        yemeklerListeAra  = []
        if searchText == "" {
            yemeklerListeAra = yemeklerListe
        }else {
            for yemek in yemeklerListe {
                if yemek.yemek_adi!.lowercased().contains(searchText.lowercased()){
                    yemeklerListeAra.append(yemek)
                }
            }
        }
     
        self.yemeklerCollectionView.reloadData()
    }
}

extension AnasayfaVC : UICollectionViewDelegate, UICollectionViewDataSource,YemeklerCollectionViewCellToAnasayfaVCProtocol {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return yemeklerListeAra.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let yemek = yemeklerListeAra[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hucreYemek", for: indexPath) as! YemeklerCollectionViewCell
        
        
        //Resim alma
        if let url = URL(string: "http://kasimadalan.pe.hu/yemekler/resimler/\(yemek.yemek_resim_adi!)"){
            DispatchQueue.main.async {
                cell.yemekImage.kf.setImage(with:url)
            }
        }
        
        cell.yemekAdLabel.text = yemek.yemek_adi
        cell.yemekFiyatLabel.text = "\(yemek.yemek_fiyat!) ₺"
        
        //yetkilendirme
        cell.cellToAnasayfaVC = self
        cell.indexPath = indexPath

        cell.layer.cornerRadius = 20
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let yemek = yemeklerListe[indexPath.row]
        performSegue(withIdentifier: "toDetay", sender: yemek)
        collectionView.deselectItem(at: indexPath, animated: true)
        
    }
    
    func butonaTiklandi(indexPath: IndexPath) {
        let yemek = yemeklerListeAra[indexPath.row]
        
        let yemek_siparis_adet = "1"
        let kullanici_adi = "mehmet_dolasan"
        
        //print("\(yemek.yemek_adi!) tiklandi")
        let alertController = UIAlertController(title: "\(yemek.yemek_adi!)", message: "Sepete eklensin mi?", preferredStyle: .alert)
        let iptalAction = UIAlertAction(title: "İptal", style: .cancel){ action in
            print("İptal Seçildi")
            
           
        }
        alertController.addAction(iptalAction)
        
        
        let tamamAction = UIAlertAction(title: "Tamam", style: .destructive){ action in
            print("Tamam Seçildi")
            let liste = self.gelenSepetListesi
            var tempList = [String]()
            for indx in stride(from: 0, to: liste.count, by: 1){
                tempList.append(liste[indx].yemek_adi!)
            }
            print("\(tempList)")
            
            var indis = 0 // listede halihazırada bulunan yemeğin indisini öğrenmek için
            if tempList.contains(yemek.yemek_adi!){
                print("içeriyor")
                for ind in stride(from: 0, to: tempList.count, by: 1){
                    if yemek.yemek_adi == tempList[ind] {
                         indis = ind
                    }
                }
                
                let sepettekiYemek = self.gelenSepetListesi[indis]
                self.anasayfaPresenterNesnesi?.sepettenYemekSil(sepet_yemek_id: sepettekiYemek.sepet_yemek_id!)
                
                
                self.anasayfaPresenterNesnesi?.sepeteYemekEkle(yemek_adi: yemek.yemek_adi!, yemek_resim_adi: yemek.yemek_resim_adi!, yemek_fiyat: yemek.yemek_fiyat!, yemek_siparis_adet: String(Int(sepettekiYemek.yemek_siparis_adet!)! + Int(yemek_siparis_adet)!), kullanici_adi: kullanici_adi)
                
            }else{
                print("içermiyor")
                //sepete yemek ekleme
                self.anasayfaPresenterNesnesi?.sepeteYemekEkle(yemek_adi: yemek.yemek_adi!, yemek_resim_adi: yemek.yemek_resim_adi!, yemek_fiyat: yemek.yemek_fiyat!, yemek_siparis_adet:yemek_siparis_adet, kullanici_adi:kullanici_adi)
                
                //Sepet Badge
                let sepetSayisi = self.gelenSepetListesi.count
                if let tabBarItems = self.tabBarController?.tabBar.items {
                    let tabItem = tabBarItems[1]
                    if tabItem.badgeValue == "0" {
                        tabItem.badgeValue = nil
                    }
                    tabItem.badgeValue = String(sepetSayisi)
                    
                }
            }
        }
        //
        alertController.addAction(tamamAction)
        self.present(alertController,animated: true)
    }
}



