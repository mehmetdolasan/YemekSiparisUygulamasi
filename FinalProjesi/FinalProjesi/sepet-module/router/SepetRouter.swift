//
//  SepetRouter.swift
//  FinalProjesi
//
//  Created by Mehmet Dolasan on 26.03.2022.
//

import Foundation
import Alamofire

class SepetRouter : PresenterToRouterSepetProtocol {
    
    static func createModule(ref: SepetVC) {
        
        let presenter = SepetPresenter()
        
        ref.sepetPresenterNesnesi = presenter
        ref.sepetPresenterNesnesi?.sepetView = ref
        ref.sepetPresenterNesnesi?.sepetInteractor = SepetInteractor()
        ref.sepetPresenterNesnesi?.sepetInteractor?.sepetPresenter = presenter
    
    }
}
