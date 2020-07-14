//
//  CameraViewController.swift
//  VideoRecorder
//
//  Created by Paul Solt on 10/2/19.
//  Copyright © 2019 Lambda, Inc. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    lazy private var captureSession = AVCaptureSession()

    @IBOutlet var recordButton: UIButton!
    @IBOutlet var cameraView: CameraPreviewView!


	override func viewDidLoad() {
		super.viewDidLoad()

		// Resize camera preview to fill the entire screen
		cameraView.videoPreviewLayer.videoGravity = .resizeAspectFill
        setUpCamera()
	}
    
    private func setUpCamera() {
        let camera = bestCamera()
        
        captureSession.beginConfiguration() // starts configuration
        guard let cameraInput = try? AVCaptureDeviceInput(device: camera) else {
            preconditionFailure("Can't create an input from the camera.")
        }
        
        guard captureSession.canAddInput(cameraInput) else { // Returns a Boolean value that indicates whether a given input can be added to the session.
            preconditionFailure("This session can't handle this trype of input: \(cameraInput)")
        }
        
        captureSession.addInput(cameraInput) // Adds a given input to the session.
        
        if captureSession.canSetSessionPreset(.hd1920x1080) {
            captureSession.sessionPreset = .hd1920x1080
        }
        
        captureSession.commitConfiguration() // ends configuration
        
        cameraView.session = captureSession
    }
    
    private func bestCamera() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(.builtInUltraWideCamera,
                                                for: .video,
                                                position: .back) {
            return device
        }
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                for: .video,
                                                position: .back) {
            return device
        }
        preconditionFailure("No cameras on device match the specs that we need.")
    }

    @IBAction func recordButtonPressed(_ sender: Any) {

	}
	
	/// Creates a new file URL in the documents directory
	private func newRecordingURL() -> URL {
		let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

		let formatter = ISO8601DateFormatter()
		formatter.formatOptions = [.withInternetDateTime]

		let name = formatter.string(from: Date())
		let fileURL = documentsDirectory.appendingPathComponent(name).appendingPathExtension("mov")
		return fileURL
	}
}

