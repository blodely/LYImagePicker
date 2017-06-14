//
//  TestViewController.swift
//  LYIMAGEPICKER
//
//  CREATED BY LUO YU ON 2017-06-14.
//  COPYRIGHT © 2017 LUO YU. ALL RIGHTS RESERVED.
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
