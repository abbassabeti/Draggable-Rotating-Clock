//
//  ViewController.swift
//  TakeHomeTest
//
//  Created by Abbas on 2/10/19.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit
import Alamofire
import SnapKit
import RxAlamofire
import RxSwift
import RxCocoa
import Foundation


class ViewController: UIViewController {
    @IBOutlet weak var square: RotatingView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sliderView: UIView!
    
    
    var timer = Timer()
    var panGesture       = UIPanGestureRecognizer()
    var manager : SessionManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        square.backgroundColor = UIColor.blue.withAlphaComponent(0.2)
        square.layer.borderWidth = 2
        square.layer.borderColor = UIColor.black.cgColor
        sliderView.backgroundColor = UIColor.gray
        DispatchQueue.main.async {
            self.square.rotate()
        }
        square.isUserInteractionEnabled = true
        self.sliderView.snp.makeConstraints { (make) in
            make.height.equalTo(50)
        }
        self.square.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-100)
        }
        self.manager = {
            let config = URLSessionConfiguration.default
            config.timeoutIntervalForRequest = 30
            config.timeoutIntervalForResource = 30
            let mgr = Alamofire.SessionManager(configuration: config)
            
            return mgr
        }()

        
        DispatchQueue.main.async {
            self.updateCounting()
        }
        self.view.bringSubviewToFront(square)
        
    }

    func scheduledTimerWithTimeInterval(){
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounting(){
        self.manager?.request(AppConfiguration.restAddress, method: .get, parameters: nil,encoding: URLEncoding(), headers: nil).responseData { [weak self] (data) in
            
            do{
                if let data = data.data {
                    print(String(data: data, encoding: String.Encoding.utf8))
                    let result = try JSONDecoder().decode(TimeBusinessModel.self, from: data)
                    
                    DispatchQueue.main.async {
                        self?.timeLabel.text = result.getTime()
                    }
                }else {
                    print ("error")
                }
            }catch let error {
                print("error: \(error)")
            }
            self?.updateCounting()
        }
    }
    
    func rectIntersectionInPerc(r1:CGRect, r2:CGRect) -> CGFloat {
        if (r1.intersects(r2)) {
            let interRect:CGRect = r1.intersection(r2);
            
            return (interRect.width * interRect.height) / (r1.width * r1.height)
        }
        return 0;
    }
    
    
    
    @IBAction func recognizer(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        if let view = sender.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
        }
        sender.setTranslation(CGPoint.zero, in: self.view)
        
        switch sender.state {
            case .began:
                
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                    self.sliderView.snp.updateConstraints({ (make) in
                        make.height.equalTo(190)
                    })
                    self.view.layoutIfNeeded()
                }, completion: nil)
                break
            case .changed:
                self.square.snp.remakeConstraints{ (make) in
                    make.centerX.equalTo(self.square.frame.midX)
                    make.centerY.equalTo(self.square.frame.midY)
                }
            case .ended:
                let ratio = self.rectIntersectionInPerc(r1: self.square.frame, r2: self.sliderView.frame)
                self.square.setNeedsUpdateConstraints()
                if (ratio > 0.25){
                    
                    self.square.snp.remakeConstraints{ (make) in
                        make.center.equalTo(self.sliderView)
                    }
                }else{
                    self.square.snp.remakeConstraints{ (make) in
                        make.centerX.equalToSuperview()
                        make.centerY.equalToSuperview().offset(-100)
                    }
                    self.sliderView.snp.remakeConstraints({ (make) in
                        make.height.equalTo(50)
                    })
                }
                UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
                    //self.sliderHeight.constant = 0
                    self.view.layoutIfNeeded()
                }, completion: nil)
            
            default: ()
        }
    }
}
