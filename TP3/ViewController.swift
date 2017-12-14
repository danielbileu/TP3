//
//  ViewController.swift
//  TP3
//
import UIKit

class ViewController: UIViewController {
    //---Des murs---
    @IBOutlet weak var mur_gauche: UIView!
    @IBOutlet weak var mur_droite: UIView!
    @IBOutlet weak var mur_haut: UIView!
    @IBOutlet var mur_bas: UIView!
    @IBOutlet weak var balle: UIView!
    //---touch---
    @IBOutlet weak var finger_mover: UIView!
    @IBOutlet weak var finDuJeux: UIView!
    //---Des targets---
    @IBOutlet weak var alienShip1: UIView!
    @IBOutlet weak var alienShip2: UIView!
    @IBOutlet weak var alienShip3: UIView!
    @IBOutlet weak var motherShip: UIView!
    //---Affichage des points---
    @IBOutlet weak var points_label: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
//---Pour donner de l'angle de la balle aprés qu'elle touche quelque target---
    var objet_bounce: Bounce!
    var cos: Double!
    var sin: Double!
    //---Controlateur du temps---
    var aTimer, scoreTimer: Timer!
    var sec = 0
    //---Compteur des points---
    var points = 0
    var tab_de_target: [UIView]!
    
    
    
//---Lorsque le document est prêt---
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //---Des aliens ships---
        tab_de_target = [alienShip2, alienShip1, alienShip3]
        //---Pour faire la balle bondir dans les murs---
        objet_bounce = Bounce(ball: balle, left_window: mur_gauche, right_window: mur_droite, top_window: mur_haut, bottom_window: mur_bas)
        balle.layer.cornerRadius = 12.5
        lancerAnimation()
    }
    
    //---Pour créer l'angle (au hasard) d'animation de la balle dans le début---
    func lancerAnimation() {
        let degrees: Double = Double(arc4random_uniform(360))//---angle au hasard---
        cos = __cospi(degrees/180)
        sin = __sinpi(degrees/180)
        aTimer = Timer.scheduledTimer(timeInterval: 0.004, target: self, selector: #selector(animation), userInfo: nil, repeats: true)//---pour donner la vitesse de la balle et definir la fonction que donne des attributes à balle---
        
    //---pour controller le temps---
        scoreTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(keeptime), userInfo: nil, repeats: true)
        
        
    }
    
    //---Pour faire la balle se animer---
    @objc func animation() {
        balle.center.x += CGFloat(cos)
        balle.center.y += CGFloat(sin)
        
        for target in tab_de_target {
            if balle.frame.intersects(target.frame) {
                let forRandomX: UInt32 = 375 - 23 - 23 - 18 + 1
                let forRandomY: UInt32 = 667 - 23 - 136 - 18 + 1
                target.center.x = CGFloat(arc4random_uniform(forRandomX) + 23 + 9)
                target.center.y = CGFloat(arc4random_uniform(forRandomY) + 23 + 9)
                let degrees = Double(arc4random_uniform(360))
                cos = __cospi(degrees/180)
                sin = __sinpi(degrees/180)
            }
        }
        
        if balle.frame.intersects(finDuJeux.frame) {
            aTimer.invalidate()
            aTimer = nil
        }
        sin = objet_bounce.returnCosSinAfterTouch(sin: sin, cos: cos)[0]
        cos = objet_bounce.returnCosSinAfterTouch(sin: sin, cos: cos)[1]
        
        //--For du target. Ici crées la intersection lorsque la balle touches le target---
        for t in tab_de_target {
            if balle.frame.intersects(t.frame){  //---renvoye le target touchée...---
                t.center.x = -200//---...à la position dehors de la superview---
                points += 100
                points_label.text = "\(points) points"
            }
        }
    }
    @objc func keeptime() {
        sec += 1
        timerLabel.text = "\(sec) seconds..."
        if balle.frame.intersects(mur_bas.frame)
        {
            scoreTimer.invalidate()
            scoreTimer = nil
            balle.removeFromSuperview()
            
        }
    }
    
    //---Pour créer le finger mover---
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        let touch: UITouch = touches.first!
        if touch.view == finger_mover {
        finger_mover.center.x = touch.location(in: self.view).x
        mur_bas.center.x = finger_mover.center.x
        }
    //---
    }
//--------------------------------------------------
//--------------------------------------------------
}
