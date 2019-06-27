//
//  ViewController.swift
//  Anxiety
//
//  Created by Joel Menezes Hamon on 19/10/2018.
//  Copyright © 2018 Joel Menezes Hamon. All rights reserved.
//

import UIKit
import AVFoundation // Biblioteca para utilizar sons

class Cena8ViewController: UIViewController {
    
    @IBOutlet weak var Cena8ImageView: UIImageView!
    // var audioPlayer = AVAudioPlayer()
   
    @IBOutlet weak var key: UIImageView!
    
    @IBOutlet weak var fech: UIImageView!
    
    var keyViewOrigin: CGPoint!
    var labelEnd: Bool = false
    var initialView: Bool = false
    var timer: Timer!
    var movendo = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialView = true
        movendo = false
        // Do any additional setup after loading the view, typically from a nib.
        Cena8ImageView.isAccessibilityElement = true // Comando que transforma a ImageView em um objeto visível pelo crossover
  //      let Cena8Gif = UIImage.gifImageWithName("Cena_8") // Cria uma variável com a imagem Gif através da extensão da biblioteca ImageView que será utilizada na ImageView da Cena8
        
           let Cena8Image = UIImage.init(named: "Cena_8")
        
        Cena8ImageView.image = Cena8Image // Adicionando a variável à tela de ImageView
        
        fech.clipsToBounds = true
        fech.layer.cornerRadius = fech.frame.size.height / 2
//        fech.layer.borderColor = UIColor.red.cgColor
//        fech.layer.borderWidth = 3
        
        let imageFech = UIImage.init(named: "fech")
        fech.image = imageFech
        
        let gifChave = UIImage.gifImageWithName("chave") // variável com gif do asset da chave
        key.image = gifChave // setando o asset gif no ImageView
        
        keyViewOrigin = key.frame.origin // posicao da key Asset
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(Cena8ViewController.handlePan(sender:)))
        
        key.addGestureRecognizer(pan)
        
        view.bringSubviewToFront(key)
        
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(Cena8ViewController.update), userInfo: nil, repeats: true)

        
//        do {
//            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "chave", ofType: "wav")!)) // colocando a música através do diretório
//            audioPlayer.prepareToPlay() // preparando o áudio
//        } catch {
//            print(error) // erro de áudio
//        }
        
    }
    
    
    func shakeKey() {
        let center = key.center
        
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 2
        shake.autoreverses = true
        let fromPoint = CGPoint(x: center.x - 5, y: center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        let toPoint = CGPoint(x: center.x + 5, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)
        shake.fromValue = fromValue
        shake.toValue = toValue
        key.layer.add(shake, forKey: "position")
    }
    
    
//    func pulsedFech() {
//        let pulse = Pulsing(numberOfPulses: 1, radius: 60, position: fech.center)
//        pulse.animationDuration = 1.0
////        pulse.backgroundColor = UIColor.blue.cgColor
//         pulse.backgroundColor = #colorLiteral(red: 0.0736188814, green: 0.682425797, blue: 0.919788897, alpha: 1)
//        self.view.layer.insertSublayer(pulse, below: fech.layer)
//    }
    
    @objc func handlePan(sender: UIPanGestureRecognizer) {
        print ("Handle Pan")
        let keyView = sender.view!
        
        switch sender.state {
            
        case .began, .changed:
            moveViewWithPan(view: keyView, sender: sender)
            
        case .ended:
            if keyView.frame.intersects(fech.frame) {
                deleteView(view: keyView)
                initialView = false
                 performSegue(withIdentifier: "next", sender: nil)
            } else {
                returnViewToOrigin(view: keyView)
                shakeKey()
            }
            
        default:
            break
        }
    }
    
    @objc func update() {// Função de atualização para opreações constantes
//        pulsedFech()
        if movendo == false {
            shakeKey()
        }
    }
    
    
    
    func moveViewWithPan(view: UIView, sender: UIPanGestureRecognizer) {
        print ("Movendo")
        movendo = true
        let translation = sender.translation(in: view)
        
        view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: view)
    }
    
    func returnViewToOrigin(view: UIView) {
        print ("Voltando")
        movendo = false
        UIView.animate(withDuration: 0.3, animations: {
            view.frame.origin = self.keyViewOrigin
        })
    }
    
    
    func deleteView(view: UIView) {
        print ("Deletando")
        UIView.animate(withDuration: 0.3, animations: {
            view.alpha = 0.0
        })
    }
  
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
}
