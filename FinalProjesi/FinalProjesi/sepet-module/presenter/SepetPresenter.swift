//
//  SepetPresenter.swift
//  FinalProjesi
//
//  Created by Mehmet Dolasan on 26.03.2022.
//

import Foundation
import Alamofire

class SepetPresenter : ViewToPresenterSepetProtocol, InteractorToPresenterSepetProtocol {
  
    var sepetView: PresenterToViewSepetProtocol?
    var sepetInteractor: PresenterToInteractorSepetProtocol?
    
    func sepetiListele() {
        sepetInteractor?.listele()
    }
    
    func sepettenYemekSil(sepet_yemek_id: String) {
        sepetInteractor?.yemekSil(sepet_yemek_id: sepet_yemek_id)
    }
    
    func presenteraVeriGonder(sepetYemekListesi: Array<SepetYemekler>) {
        sepetView?.vieweVeriGonder(sepetYemekListesi: sepetYemekListesi)
    }
    

}
