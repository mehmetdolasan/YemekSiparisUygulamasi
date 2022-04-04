//
//  YemekDetayRouter.swift
//  FinalProjesi
//
//  Created by Mehmet Dolasan on 24.03.2022.
//

import Foundation

class YemekDetayRouter : presenterToRouterYemekDetay {
    
    static func creatModule(ref: YemekDetayVC) {
        
        let presenter = YemekDetayPresenter()
        
        ref.yemekDetayPresenterNesnesi = presenter
        ref.yemekDetayPresenterNesnesi?.yemekDetayInteractor = YemekDetayInteractor()
        ref.yemekDetayPresenterNesnesi?.yemekDetayView = ref
        ref.yemekDetayPresenterNesnesi?.yemekDetayInteractor?.yemekDetayPresenter = presenter
        
    }
}
