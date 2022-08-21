//
//  ViewController.swift
//  Pomodoro
//
//  Created by Радик Ахметзянов on 20.08.2022.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    // MARK: - Properties
        
    var circularViewDuration: TimeInterval = 5
    var isStarted = false
    var isWorkTime = false
    var timer = Timer()
    var durationTimer = 5
    let shape = CAShapeLayer()

    // MARK: - Outlets
        
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .boldSystemFont(ofSize: 80)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var playPauseButton: UIButton = {
        let playPauseButton = UIButton()
        playPauseButton.setImage(UIImage(systemName: "play"), for: .normal)
        playPauseButton.tintColor = .black
        playPauseButton.addTarget(self, action: #selector(playPauseButtonPressed), for: .touchUpInside)
        playPauseButton.translatesAutoresizingMaskIntoConstraints = false

        return playPauseButton
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .white
            setupHierarchy()
            setupLayout()
    }
    
    // MARK: - Setup
    
    private func setupHierarchy() {
        view.addSubview(label)
        view.addSubview(playPauseButton)
        createCircularPath()
        label.text = "\(durationTimer)"
    }
    
    private func setupLayout() {
        label.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view).offset(-20)
        }
        
        playPauseButton.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view).offset(70)
            make.height.equalTo(50)
            make.width.equalTo(50)
        }
    }

    // MARK: - Actions

    @objc private func playPauseButtonPressed() {
        basicAnimation()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        timer.tolerance = 0.1
        playPauseButton.setImage(UIImage(systemName: "pause"), for: .normal)
    }
    
    @objc private func timerAction() {
        if durationTimer != 0 {
            durationTimer -= 1
            label.text = "\(durationTimer)"
        } else {
            timer.invalidate()
        }
    }
    
    // MARK: - Animation
    
    func createCircularPath() {
        let circlePath = UIBezierPath(arcCenter: view.center, radius: 150, startAngle: -(.pi / 2), endAngle: .pi * 2, clockwise: true)
        
        let trackShape = CAShapeLayer()
        trackShape.path = circlePath.cgPath
        trackShape.lineWidth = 10
        trackShape.strokeColor = UIColor.lightGray.cgColor
        trackShape.fillColor = UIColor.clear.cgColor
        view.layer.addSublayer(trackShape)
        
        shape.path = circlePath.cgPath
        shape.lineWidth = 20
        shape.strokeColor = UIColor.red.cgColor
        shape.fillColor = UIColor.clear.cgColor
        shape.lineCap = .round
        shape.strokeEnd = 0
        view.layer.addSublayer(shape)
    }
    
    func basicAnimation() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.duration = CFTimeInterval(durationTimer)
        basicAnimation.toValue = 1
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        shape.add(basicAnimation, forKey: "animation")
    }
}
