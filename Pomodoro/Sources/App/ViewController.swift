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
        
    var isStarted = false
    var isWorkTime = false
    var timer: Timer!
    var workTime = 10
    var restTime = 5
    let shape = CAShapeLayer()
    let config = UIImage.SymbolConfiguration(pointSize: 50, weight: .bold, scale: .default)

    // MARK: - Outlets
        
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "00:\(workTime)"
        label.font = .boldSystemFont(ofSize: 60)
        label.textColor = .systemRed
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var playPauseButton: UIButton = {
        let playPauseButton = UIButton()
        let image = UIImage(systemName: "play", withConfiguration: config)
        playPauseButton.setImage(image, for: .normal)
        playPauseButton.tintColor = .systemRed
        playPauseButton.addTarget(self, action: #selector(playPauseButtonPressed), for: .touchUpInside)
        playPauseButton.translatesAutoresizingMaskIntoConstraints = false

        return playPauseButton
    }()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .systemGray
            setupHierarchy()
            setupLayout()
    }
    
    // MARK: - Setup
    
    private func setupHierarchy() {
        view.addSubview(label)
        view.addSubview(playPauseButton)
//        view.addSubview(stackView)
//        stackView.addArrangedSubview(label)
//        stackView.addArrangedSubview(playPauseButton)
        createCircularPath()
    }
    
    private func setupLayout() {
        label.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view).offset(-40)
        }
        
        playPauseButton.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view).offset(50)
        }
        
//        stackView.snp.makeConstraints { make in
//                    make.center.equalTo(view)
//                }
    }

    // MARK: - Actions

    @objc private func playPauseButtonPressed() {
        if !isStarted && shape.strokeEnd == 0 {
            isStarted = true
            basicAnimation()
            timer = Timer.scheduledTimer(timeInterval: 1,
                                         target: self,
                                         selector: #selector(timerAction),
                                         userInfo: nil,
                                         repeats: true)
            let image = UIImage(systemName: "pause", withConfiguration: config)
            playPauseButton.setImage(image, for: .normal)
        } else if !isStarted {
            isStarted = true
            timer = Timer.scheduledTimer(timeInterval: 1,
                                         target: self,
                                         selector: #selector(timerAction),
                                         userInfo: nil,
                                         repeats: true)
            shape.speed = 1
            let image = UIImage(systemName: "pause", withConfiguration: config)
            playPauseButton.setImage(image, for: .normal)
        } else {
            timer.invalidate()
            shape.strokeEnd = CGFloat(workTime)
            shape.speed = 0
        
            let image = UIImage(systemName: "play", withConfiguration: config)
            playPauseButton.setImage(image, for: .normal)
            isStarted = false
        }
        
    }
    
    @objc private func timerAction() {
        if workTime > 0 {
            workTime -= 1
        } else if !isWorkTime {
            workTime = restTime
            isWorkTime = true
            playPauseButton.tintColor = .systemGreen
            label.textColor = .systemGreen
            shape.strokeColor = UIColor.systemGreen.cgColor
            shape.removeAllAnimations()
            timer.invalidate()
            let image = UIImage(systemName: "play", withConfiguration: config)
            playPauseButton.setImage(image, for: .normal)
            isStarted = false
        } else if isWorkTime {
            isWorkTime = false
            timer.invalidate()
        }
        if workTime < 10 {
            label.text = "00:0\(workTime)"
        } else {
            label.text = "00:\(workTime)"
        }
    }
    
    
    // MARK: - Animation
    
    func createCircularPath() {
        let circlePath = UIBezierPath(arcCenter: view.center, radius: 150, startAngle: -(.pi / 2), endAngle: .pi * 2, clockwise: true)
        
        let trackShape = CAShapeLayer()
        trackShape.path = circlePath.cgPath
        trackShape.lineWidth = 20
        trackShape.strokeColor = UIColor.black.cgColor
        trackShape.fillColor = UIColor.clear.cgColor
        view.layer.addSublayer(trackShape)
        
        shape.path = circlePath.cgPath
        shape.lineWidth = 10
        shape.strokeColor = UIColor.systemRed.cgColor
        shape.fillColor = UIColor.clear.cgColor
        shape.lineCap = .round
        shape.strokeEnd = 0
        view.layer.addSublayer(shape)
    }
    
    func basicAnimation() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.duration = CFTimeInterval(workTime)
        basicAnimation.fromValue = 0
        basicAnimation.toValue = 1
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        shape.add(basicAnimation, forKey: "animation")
    }
    
    
}
