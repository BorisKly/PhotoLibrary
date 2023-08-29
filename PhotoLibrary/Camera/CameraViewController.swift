//
//  MakePhotoViewController.swift
//  PhotoLibrary
//
//  Created by Borys Klykavka on 21.08.2023.
//


import AVFoundation
import UIKit

protocol  CameraViewControllerDelegate: AnyObject {
    func shutterButtonPressed()
    func dismissCamera()
}

class CameraViewController: UIViewController {
    
    public var camera: CameraService {
        resolve(CameraService.self)
    }
            
    var currentPhotoSettings: AVCapturePhotoSettings?
    
    private var mainView: CameraView? {
        return self.view as? CameraView
    }
    
    override func loadView() {
        let mainView = CameraView(frame: CGRect.zero)
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView?.delegate = self
        camera.checkCameraPermissions()
        mainView?.previewLayer.session = camera.session
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if camera.session?.isRunning == true {
            camera.session?.stopRunning()
        }
    }
}

extension CameraViewController: CameraViewControllerDelegate {
   
    func dismissCamera() {
        self.dismiss(animated: true)
    }
   
    func shutterButtonPressed() {
        let settings = AVCapturePhotoSettings()
        camera.output.capturePhoto(with: settings,
                             delegate: self)
         currentPhotoSettings = settings
    }
}

