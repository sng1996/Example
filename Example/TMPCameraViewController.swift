//
//  TMPCameraViewController.swift
//  Example
//
//  Created by Сергей Гаврилко on 26.09.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import ImageSource
import Paparazzo
import UIKit

class TMPCameraViewController: UIViewController {

    private var photos = [ImageSource]()
    
    private func updateUI() {
        imageView.setImage(fromSource: photos.first)
    }
    
    // MARK: - Outlets and actions
    
    @IBOutlet private var imageView: UIImageView!
    
    @IBAction private func showMediaPicker() {
        
        let assemblyFactory = Paparazzo.AssemblyFactory(theme: PaparazzoUITheme.appSpecificTheme())
        let assembly = assemblyFactory.mediaPickerAssembly()
        
        let data = MediaPickerData(items: [], selectedItem: nil, maxItemsCount: 20, cropEnabled: true, autocorrectEnabled: true, cropCanvasSize: CGSize(width: 1280, height: 960))
        
        let mediaPickerController = assembly.module(
            data: data,
            configure: { [weak self] module in
                weak var module = module
                
                module?.setContinueButtonTitle("Done")
                
                module?.onFinish = { mediaPickerItems in
                    module?.dismissModule()
                    
                    // storing picked photos in instance var and updating UI
                    self?.photos = mediaPickerItems.map { $0.image }
                    self?.updateUI()
                }
                module?.onCancel = {
                    module?.dismissModule()
                }
            }
        )
        
        navigationController?.pushViewController(mediaPickerController, animated: true)
    }
    
    @IBAction private func showPhotoLibrary() {
        
        let assemblyFactory = Paparazzo.AssemblyFactory(theme: PaparazzoUITheme.appSpecificTheme())
        let assembly = assemblyFactory.photoLibraryAssembly()
        
        let data = PhotoLibraryData(selectedItems: [], maxSelectedItemsCount: 5)
        
        let galleryController = assembly.module(
            data: data,
            configure: { [weak self] module in
                weak var module = module
                module?.onFinish = { result in
                    module?.dismissModule()
                    
                    if case let .selectedItems(photoLibraryItems) = result {
                        self?.photos = photoLibraryItems.map { $0.image }
                        self?.updateUI()
                    }
                }
            }
        )
        
        let navigationController = UINavigationController(rootViewController: galleryController)
        
        present(navigationController, animated: true, completion: nil)
    }
    

}
