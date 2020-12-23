//
//  HKAlbumCameraVC.swift
//  Taoyuejia
//
//  Created by AhriLiu on 2020/10/19.
//  Copyright © 2020 zxw. All rights reserved.
//

import UIKit
import Photos
import YXKitOC

class HKAlbumCameraVC: UIViewController  {
    var device      :      AVCaptureDevice!
    var input       :      AVCaptureDeviceInput!
    var photoOutput :      AVCapturePhotoOutput!
    var output      :      AVCaptureMetadataOutput!
    var session     :      AVCaptureSession!
    var previewLayer:      AVCaptureVideoPreviewLayer!
    var setting     :      AVCapturePhotoSettings?
    var isJurisdiction:    Bool?
    var videoConnection:   AVCaptureConnection?
    var isflash     :      Bool = false
    var imageSelectBlock   : ((_ imageArr: [UIImage]) -> Void)?

    // MARK: - life cycle
    
    override func viewDidLoad() {
        customCamera()
        customUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - method
    
    func customCamera(){
        guard let devices = AVCaptureDevice.devices(for: AVMediaType.video) as? [AVCaptureDevice] else { return }
        guard let devic = devices.filter({ return $0.position == .back }).first else{ return}
        device = devic

        self.input = try? AVCaptureDeviceInput(device: device)
        self.photoOutput = AVCapturePhotoOutput.init()
        self.output = AVCaptureMetadataOutput.init()
        self.session = AVCaptureSession.init()
        
        if(self.session.canSetSessionPreset(AVCaptureSession.Preset(rawValue: "AVCaptureSessionPreset1280x720"))){
            self.session.sessionPreset = AVCaptureSession.Preset(rawValue: "AVCaptureSessionPreset1280x720")
        }
        
        if(self.session.canAddInput(self.input)){
            self.session.addInput(self.input)
        }
        
        if(self.session.canAddOutput(self.photoOutput)){
            self.session.addOutput(self.photoOutput)
        }
        
        self.previewLayer = AVCaptureVideoPreviewLayer.init(session: self.session)
        self.previewLayer.frame  = self.view.bounds
        self.previewLayer.videoGravity = AVLayerVideoGravity(rawValue: "AVLayerVideoGravityResizeAspectFill")
        self.view.layer.addSublayer(self.previewLayer)
        
        if device.isWhiteBalanceModeSupported(.autoWhiteBalance) {
            device.whiteBalanceMode = .autoWhiteBalance
        }
        device.unlockForConfiguration()
        self.session.startRunning()
    }
    
    @objc func changeCamera(){
        guard var position = input?.device.position else { return }
        position = position == .front ? .back : .front
        let devices = AVCaptureDevice.devices(for: AVMediaType.video) as [AVCaptureDevice]
        for devic in devices{
            if devic.position==position{
                device = devic
            }
        }
        guard let videoInput = try? AVCaptureDeviceInput(device: device!) else { return }
        session.beginConfiguration()
        session.removeInput(input)
        if(self.session.canAddInput(videoInput)){
            self.session.addInput(videoInput)
        }
        session.commitConfiguration()
        self.input = videoInput
    }
    
    @objc func shutterCamera(){
        videoConnection = photoOutput.connection(with: AVMediaType.video)
        if videoConnection == nil {
            print("take photo failed!")
            return
        }
        if #available(iOS 11.0, *) {
            setting = AVCapturePhotoSettings.init(format: [AVVideoCodecKey:AVVideoCodecType.jpeg])
        } else {
            setting = AVCapturePhotoSettings()
        }
        photoOutput.capturePhoto(with: setting!, delegate: self)
    }
    
    func takePhotoDone(_ image : UIImage) {
        if self.imageSelectBlock != nil {
            self.imageSelectBlock!([image])
        }
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Action
    @objc func flashAction(){
        isflash = !isflash
        try? device.lockForConfiguration()
        if(isflash){
            device.torchMode = .on
        } else {
            if device.hasTorch {
                device.torchMode = .off
            }
        }
        device.unlockForConfiguration()
    }
    
    @objc func cancelActin(){
        if(!session.isRunning){
            session.startRunning()
        }
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK:- UI
    func customUI(){
        self.view.backgroundColor = .black
        
        let changeBtn = UIButton.init()
        changeBtn.frame = CGRect.init(x: Int(YX_AppW() - 70), y:32, width: 57, height: 48)
        changeBtn.setImage(UIImage(named: "camera_turn"), for: .normal)
        changeBtn.addTarget(self, action: #selector(changeCamera), for: .touchUpInside)
        view.addSubview(changeBtn)
        
        let photoButton = UIButton.init(frame: CGRect(x: YX_AppW() * 1 / 2.0 - 40, y: YX_AppH() - 100, width: 80, height: 80))
        photoButton.setImage(UIImage(named: "takePhoto_btn"), for: .normal)
        photoButton.addTarget(self, action: #selector(shutterCamera), for: .touchUpInside)
        view.addSubview(photoButton)
        
        let cancelBtn = UIButton.init()
        cancelBtn.frame = CGRect.init(x: photoButton.left - 110, y: photoButton.centerY-25, width: 50, height: 50)
        cancelBtn.setImage(UIImage(named: "back_white"), for: .normal)
        cancelBtn.addTarget(self, action: #selector(cancelActin), for: .touchUpInside)
        view.addSubview(cancelBtn)
    }
    
    
}
//MARK: - AVCapturePhotoCaptureDelegate
extension HKAlbumCameraVC: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingLivePhotoToMovieFileAt outputFileURL: URL, duration: CMTime, photoDisplayTime: CMTime, resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {


    }
    
    // <ios10
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        session.stopRunning()
        let imagedata  =  AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer!, previewPhotoSampleBuffer: previewPhotoSampleBuffer)
        if imagedata != nil {
            let image: UIImage = UIImage.init(data: imagedata!) ?? UIImage()
            self.takePhotoDone(image)
        }
    }
    
    @available(iOS 11.0, *)
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        session.stopRunning()
        let data = photo.fileDataRepresentation();
        if data != nil  {
            let image: UIImage = UIImage.init(data: data!) ?? UIImage()
            self.takePhotoDone(image)
        }
    }
    

    
}
