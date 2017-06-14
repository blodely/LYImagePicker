//
//  TestViewController.swift
//  LYImagePicker
//
//  Created by 駱彧 on 14/6/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
	
	// MARK: - UI
	
	@IBOutlet weak var ivRet: UIImageView!
	@IBOutlet weak var lblRet: UILabel!
	@IBOutlet weak var btnAlbum: UIButton!
	@IBOutlet weak var btnCamera: UIButton!
	
	// MARK: - ACTION
	
	@IBAction func albumButtonPressed(_ sender: Any) {
	}
	
	@IBAction func cameraButtonPressed(_ sender: Any) {
	}
	
	// MARK: - INIT
	
	// MARK: VIEW LIFE CYCLE
	
	override func loadView() {
		super.loadView()
		
		self.navigationItem.title = "Test (LYImagePicker)"
	}

    override func viewDidLoad() {
        super.viewDidLoad()

        // DO ANY ADDITIONAL SETUP AFTER LOADING THE VIEW.
    }
	
	// MARK: MEMORY WARNINGS

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // DISPOSE OF ANY RESOURCES THAT CAN BE RECREATED.
    }
    

    /*
    // MARK: - NAVIGATION

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
