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
    var workTime: Double = 25
    var restTime: Double = 10
    let shape = CAShapeLayer()
    let config = UIImage.SymbolConfiguration(pointSize: 50, weight: .bold, scale: .default)

    // MARK: - Outlets
        
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "00:\(Int(workTime))"
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
            view.backgroundColor = .darkGray
            setupHierarchy()
            setupLayout()
    }
    
    // MARK: - Setup
    
    private func setupHierarchy() {
        view.addSubview(label)
        view.addSubview(playPauseButton)
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
    }

    // MARK: - Actions

    @objc private func playPauseButtonPressed() {
        if !isStarted && shape.timeOffset <= 0 {
            isStarted = true
            basicAnimation()
            createTimer()
            let image = UIImage(systemName: "pause", withConfiguration: config)
            playPauseButton.setImage(image, for: .normal)
        } else if !isStarted {
            isStarted = true
            resumeAnimation()
            createTimer()
            let image = UIImage(systemName: "pause", withConfiguration: config)
            playPauseButton.setImage(image, for: .normal)
        } else {
            pauseAnimation()
            timer.invalidate()
            let image = UIImage(systemName: "play", withConfiguration: config)
            playPauseButton.setImage(image, for: .normal)
            isStarted = false
        }
    }
    
    @objc private func timerAction() {
        if workTime > 0 {
            workTime -= 0.01
        } else if !isWorkTime {
            workTime = restTime
            isWorkTime = true
            playPauseButton.tintColor = .systemGreen
            label.textColor = .systemGreen
            shape.strokeColor = UIColor.systemGreen.cgColor
            shape.shadowColor = UIColor.systemGreen.cgColor
            shape.removeAllAnimations()
            timer.invalidate()
            let image = UIImage(systemName: "play", withConfiguration: config)
            playPauseButton.setImage(image, for: .normal)
            isStarted = false
        } else if isWorkTime {
            isWorkTime = false
            workTime = 25
            playPauseButton.tintColor = .systemRed
            label.textColor = .systemRed
            shape.strokeColor = UIColor.systemRed.cgColor
            shape.shadowColor = UIColor.systemRed.cgColor
            let image = UIImage(systemName: "play", withConfiguration: config)
            playPauseButton.setImage(image, for: .normal)
            timer.invalidate()
        }
        
        if workTime < 10 {
            label.text = "00:0\(Int(workTime))"
        } else {
            label.text = "00:\(Int(workTime))"
        }
    }
    
    private func createTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        }
    
    private func pauseAnimation() {
            let pausedTime = shape.convertTime(CACurrentMediaTime(), from: nil)
            shape.speed = 0
            shape.timeOffset = pausedTime
        }

    private func resumeAnimation() {
        let pausedTime = shape.timeOffset
        shape.speed = 1
        shape.timeOffset = 0
        shape.beginTime = 0
        let timeSincePause = shape.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        shape.beginTime = timeSincePause
    }
    
    // MARK: - Animation
    
    func createCircularPath() {
        let startPoint = CGFloat(-Double.pi / 2)
        let endPoint = CGFloat(3 * Double.pi / 2)
        let circlePath = UIBezierPath(arcCenter: view.center, radius: 150, startAngle: startPoint, endAngle: endPoint, clockwise: true)
        
        let trackShape = CAShapeLayer()
        trackShape.path = circlePath.cgPath
        trackShape.lineWidth = 15
        trackShape.strokeColor = UIColor.black.cgColor
        trackShape.fillColor = UIColor.clear.cgColor
        view.layer.addSublayer(trackShape)
        
        shape.path = circlePath.cgPath
        shape.lineWidth = 10
        shape.strokeColor = UIColor.systemRed.cgColor
        shape.fillColor = UIColor.clear.cgColor
        shape.lineCap = .round
        shape.strokeEnd = 0
        
        shape.shadowColor = UIColor.systemRed.cgColor
        shape.shadowOpacity = 1
        shape.shadowRadius = 10
        shape.shouldRasterize = true
        shape.rasterizationScale = UIScreen.main.scale
        shape.shadowOffset = .zero
        view.layer.addSublayer(shape)
    }
    
    func basicAnimation() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.duration = CFTimeInterval(workTime)
        basicAnimation.fromValue = 0
        basicAnimation.toValue = 1
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        shape.add(basicAnimation, forKey: "animation")
    }
}
