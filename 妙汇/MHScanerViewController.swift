//
//  MHScanerViewController.swift
//  妙汇
//
//  Created by 韩威 on 2016/11/3.
//  Copyright © 2016年 韩威. All rights reserved.
//

import UIKit
import AVFoundation



/// 扫一扫页面
class MHScanerViewController: UIViewController {

    
    /// 按钮以及，扫描线等等的背景视图
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var scanBg: UIImageView!
    @IBOutlet weak var scanLine: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    /// 从结果界面返回需要继续扫描
    var isNeedStartScanning = false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isNeedStartScanning {
            startScanning()
        }
    }
    
    fileprivate func setup() {
        title = "扫一扫"
        setupNavBackItem()
        
        let state = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        
        switch state {
        case .denied, .restricted:
            print("用户拒绝使用相机")
        case .authorized:
            // 初始化相机
            self.setupCapture()
        case .notDetermined: //用户还没有选择
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (allow) in
                if allow {
                    // 初始化相机
                    self.setupCapture()
                }
                else {
                    print("用户拒绝使用相机")
                }
            })
        }
    }
    
    var captureSession: AVCaptureSession?
    
    func setupCapture() {
        
        // init
        captureSession = AVCaptureSession.init()
        if captureSession!.canSetSessionPreset(AVCaptureSessionPresetHigh) {
            captureSession!.sessionPreset = AVCaptureSessionPresetHigh
        }
        
        // input
        do {
            let input = try AVCaptureDeviceInput.init(device: AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo))
            if !captureSession!.canAddInput(input) {
                print("captureSession add input failed")
                return
            }
            captureSession!.addInput(input)
            
            // output
            let output = AVCaptureMetadataOutput.init()
            if !captureSession!.canAddOutput(output) {
                print("captureSession add output failed")
                return
            }
            captureSession!.addOutput(output)
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            output.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            
            // previewLayer
            let previewLayer = AVCaptureVideoPreviewLayer.init(session: captureSession)
            previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            previewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(previewLayer!)
            view.bringSubview(toFront: coverView)
            addHollowOutView()
            
            // scan frame
            NotificationCenter.default.addObserver(forName: .AVCaptureInputPortFormatDescriptionDidChange, object: nil, queue: OperationQueue.main, using: { (notification) in
                output.rectOfInterest = previewLayer!.metadataOutputRectOfInterest(for: self.QRFrame)
            })
            startScanning()

        } catch {
            print("input init failed")
        }
    }

    @IBAction func cancleScan(_ sender: AnyObject) {
        stopScanning()
        _ = navigationController?.popViewController(animated: true)
    }
    
    func startScanning() {
        
        stopScanning()
        
        captureSession!.startRunning()
        
        let scanning = CABasicAnimation.init(keyPath: "position.y")
        scanning.repeatCount = MAXFLOAT
        scanning.duration = 2.0
        scanning.fromValue = QRFrame.origin.y
        scanning.toValue = QRFrame.origin.y + QRFrame.size.height
        scanning.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear)
        scanning.autoreverses = true
        scanLine.layer.add(scanning, forKey: "scanning")
    }
    
    func stopScanning() {
        captureSession?.stopRunning()
        scanLine.layer.removeAnimation(forKey: "scanning")
    }
    
    /// 添加镂空效果
    func addHollowOutView() {
        
        /// 镂空view
        let hollowOutView = UIView.init(frame: view.bounds)
        hollowOutView.translatesAutoresizingMaskIntoConstraints = false
        hollowOutView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.insertSubview(hollowOutView, belowSubview: coverView)
        
        //中间镂空
        let qrLayer = CAShapeLayer.init()
        let path = UIBezierPath.init(rect: hollowOutView.bounds)
        let revPath = UIBezierPath.init(rect: QRFrame).reversing()
        path.append(revPath)
        qrLayer.path = path.cgPath
        hollowOutView.layer.mask = qrLayer
    }
    
    
    /// 二维码识别区域（扫描框的frame）
    var QRFrame: CGRect {
        return CGRect.init(x: 50.0, y: 64, width: SCREEN_WIDTH - 50.0 * 2, height: SCREEN_WIDTH - 50.0 * 2)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MHScanerViewController: AVCaptureMetadataOutputObjectsDelegate {
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!)
    {
        guard metadataObjects.count > 0 else {
            return
        }
        
        stopScanning()
        
        let obj = metadataObjects.first as! AVMetadataMachineReadableCodeObject
        
        if obj.type == AVMetadataObjectTypeQRCode {
            
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            
            print("scan result is:\(obj.stringValue!)")
            
            let result = MHScanResultViewController.init(resultString: obj.stringValue!)
            
            navigationController?.pushViewController(result, animated: true)
            
            isNeedStartScanning = true
        }
    }
}


