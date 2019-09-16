//
//  ViewController.swift
//  GuessTheFlag
//
//  Created by Juan Francisco Dorado Torres on 5/27/19.
//  Copyright © 2019 Juan Francisco Dorado Torres. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  // MARK: - Outlets

  @IBOutlet var button1: UIButton!
  @IBOutlet var button2: UIButton!
  @IBOutlet var button3: UIButton!

  // MARK: - Public Properties

  var countries = [String]()
  var score = 0
  var highestScore = 0
  var correctAnswer = 0

  // MARK: - View cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    countries += ["estonia", "france", "germany",
                  "ireland", "italy", "monaco",
                  "nigeria", "poland", "russia",
                  "spain", "uk", "us"]

    button1.layer.borderWidth = 1
    button2.layer.borderWidth = 1
    button3.layer.borderWidth = 1

    button1.layer.borderColor = UIColor.lightGray.cgColor
    button2.layer.borderColor = UIColor.lightGray.cgColor
    button3.layer.borderColor = UIColor.lightGray.cgColor

    let defaults = UserDefaults.standard
    highestScore = defaults.integer(forKey: "highestScore")
    defaults.synchronize()

    askQuestion()
  }

  // MARK: - Actions

  @IBAction func buttonTapped(_ sender: UIButton) {
    var title: String

    if sender.tag == correctAnswer {
      title = "Correct"
      score += 1
    } else {
      title = "Wrong"
      score -= 1
    }

    let ac: UIAlertController

    if score > highestScore {
      highestScore = score
      let defaults = UserDefaults.standard
      defaults.set(highestScore, forKey: "highestScore")
      defaults.synchronize()

      ac = UIAlertController(title: title, message: "You beat the highest score.\nYour score is \(score).", preferredStyle: .alert)
    } else {
      ac = UIAlertController(title: title, message: "Your score is \(score).", preferredStyle: .alert)
    }

    ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))

    UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
      sender.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
    }) { [weak self] finished in
      self?.present(ac, animated: true)
    }

  }

  // MARK: - Public Methods

  func askQuestion(action: UIAlertAction! = nil) {
    countries.shuffle()

    button1.setImage(UIImage(named: countries[0]), for: .normal)
    button2.setImage(UIImage(named: countries[1]), for: .normal)
    button3.setImage(UIImage(named: countries[2]), for: .normal)

    UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: { [weak self] in
      self?.button1.transform = .identity
      self?.button2.transform = .identity
      self?.button3.transform = .identity
    }, completion: nil)

    correctAnswer = Int.random(in: 0...2)
    title = countries[correctAnswer].uppercased()
  }
}

