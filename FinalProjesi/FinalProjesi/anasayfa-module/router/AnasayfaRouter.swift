//
//  AnasayfaRouter.swift
//  FinalProjesi
//
//  Created by Mehmet Dolasan on 24.03.2022.
//

import Foundation

class AnasayfaRouter : PresenterToRouterAnasayfaProtocol{
    static func createModule(ref: AnasayfaVC) {
        
        let presenter = AnasayfaPresenter()
        
        //View
        ref.anasayfaPresenterNesnesi = presenter
        //Presenter
        ref.anasayfaPresenterNesnesi?.anasayfaView = ref
        ref.anasayfaPresenterNesnesi?.anasayfaInteractor = AnasayfaInteractor()
        //Interactor
        ref.anasayfaPresenterNesnesi?.anasayfaInteractor?.anasayfaPresenter = presenter
        
        
        
    }
}
