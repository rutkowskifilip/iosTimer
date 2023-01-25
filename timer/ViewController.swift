//
//  ViewController.swift
//  timer
//
//  Created by Filip Rutkowski on 28/11/2022.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, UIScrollViewDelegate  {
 
    


    @IBOutlet weak var sv: UIScrollView!
    
    @IBOutlet weak var pc: UIPageControl!
    

    @IBOutlet weak var table: UITableView!
    
    
    @IBOutlet weak var clearButton: UIButton!

 
    
    @IBOutlet weak var startButton: UIButton!
    var miliString = 0
    var secString = 0
    var minString = 0
    var roundMili = 0
    var roundSec = 0
    var roundMin = 0
    var roundString = ""
    var slides = Array<Any>()
    
    var timer : Timer?
    
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
     //zatrzymanie
        
        sv.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        sv.isPagingEnabled = true    // w przypadku dwóch widoków - nadmiarowe
        sv.delegate = self
        // odpowiednie paski przewijania
        sv.showsVerticalScrollIndicator = false
        sv.showsHorizontalScrollIndicator = false
        
        let slideA : SlideA = Bundle.main.loadNibNamed("SlideA", owner: self, options: nil)?.first as! SlideA
        let slideB : SlideB = Bundle.main.loadNibNamed("SlideB", owner: self, options: nil)?.first as! SlideB

        slideA.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        slideB.frame = CGRect(x: view.frame.width, y: 0, width: view.frame.width, height: view.frame.height)
                
        slides = [slideA, slideB]
        
        sv.addSubview(slideA)
        sv.addSubview(slideB)
        
        sv.contentSize = CGSize(width: view.frame.width*2, height: 400)
    
        pc.numberOfPages = slides.count
        print(pc.numberOfPages)
        clearButton.backgroundColor = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 0.75)
        startButton.backgroundColor = UIColor(red: 0/255, green: 200/255, blue: 0/255, alpha: 0.75)
        startButton.layer.cornerRadius = 45
        clearButton.layer.cornerRadius = 45
        startButton.tintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.75)
        clearButton.tintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.75)
        table.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(sv.contentOffset.x/view.frame.width)
        pc.currentPage = Int(pageIndex)
    }
    
    @IBAction func change(_ sender: UIPageControl) {
        let x = CGFloat(sender.currentPage) * view.frame.width
        UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.sv.contentOffset.x = CGFloat(x)
        }, completion: nil)
//        sv.contentOffset = CGPoint(x: x, y: 0)
       
    }
    @objc func changeSite(x: CGFloat){
        
    }
    var i = 0
    @IBAction func startTimer(_ sender: Any) {
        
         
        if(i%2==0){
            guard timer == nil else { return }
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(update), userInfo: nil, repeats: true)
            startButton.setTitle("Stop", for: .normal)
            startButton.backgroundColor = UIColor(red: 200/255, green: 0/255, blue: 0/255, alpha: 0.75)
            clearButton.setTitle("Runda", for: .normal)
            i+=1
        }else{
            print( (slides[0] as! SlideA).timerLabel.text ?? "nul")
            timer?.invalidate()
            timer = nil
            startButton.backgroundColor = UIColor(red: 0/255, green: 200/255, blue: 0/255, alpha: 0.75)
        
            startButton.setTitle("Start", for: .normal)
            clearButton.setTitle("Wyzeruj", for: .normal)
            i+=1
        }
    
       
    }
    @objc func update() {
        miliString+=1
        roundMili+=1
        if(miliString == 100){
            secString+=1
            miliString = 0
        }
        if(secString == 60){
            minString+=1
            secString = 0
        };
        if(roundMili == 100){
            roundSec+=1
            roundMili = 0
        }
        if(roundSec == 60){
            roundMin+=1
            roundSec = 0
        };
        let miliZero = (miliString<10) ? "0" : ""
        let secZero = (secString<10) ? "0" : ""
        let minZero = (minString<10) ? "0" : ""
        let roundMiliZero = (roundMili<10) ? "0" : ""
        let roundSecZero = (roundSec<10) ? "0" : ""
        let roundMinZero = (roundMin<10) ? "0" : ""
        (slides[0] as! SlideA).timerLabel.text = minZero+String(minString)+":"+secZero+String(secString)+","+miliZero+String(miliString)
        roundString = roundMinZero+String(roundMin)+":"+roundSecZero+String(roundSec)+","+roundMiliZero+String(roundMili)
    }
    var rounds = [String]()
    var times = [String]()
    var min = String()
    var max = String()
    @IBAction func clear(_ sender: Any) {
        if(i%2==0){
            miliString = 0
            secString = 0
            minString = 0
            (slides[0] as! SlideA).timerLabel.text = "00:00,00"
            clearButton.setTitle("Runda", for: .normal)
            rounds = []
            times = []
        }else{
            roundSec = 0
            roundMin = 0
            roundMili = 0
            times.append((slides[0] as! SlideA).timerLabel.text ?? "")
            if(rounds.count == 0){
                rounds.append((slides[0] as! SlideA).timerLabel.text ?? "")
                
            }else{
                rounds.append(roundString)
            }
            if(rounds.count > 1){
                min = rounds.min() ?? ""
                max = rounds.max() ?? ""
            }
            
        }
        table.reloadData()
    }
    var tab:[String] = ["a", "b", "c"]
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rounds.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let num = indexPath.row;
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell;
        
        cell.left.text = "Runda " + String(rounds.count - num)
        cell.mid.text  = rounds[rounds.count - num - 1]
        cell.right.text  = times[rounds.count - num - 1]
      
        if(rounds[rounds.count - num - 1] == min && rounds.count > 1){
            print("green", String(rounds.count - num))
            cell.left.textColor = UIColor(red: 0/255, green: 200/255, blue: 0/255, alpha: 1)
            cell.right.textColor = UIColor(red: 0/255, green: 200/255, blue: 0/255, alpha: 1)
            cell.mid.textColor = UIColor(red: 0/255, green: 200/255, blue: 0/255, alpha: 1)
        }else if(rounds[rounds.count - num - 1] == max && rounds.count > 1){
            print("red")
            cell.left.textColor = UIColor(red: 200/255, green: 0/255, blue: 0/255, alpha: 1)
            cell.right.textColor = UIColor(red: 200/255, green: 0/255, blue: 0/255, alpha: 1)
            cell.mid.textColor = UIColor(red: 200/255, green: 0/255, blue: 0/255, alpha: 1)
        }else{
            cell.left.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
            cell.right.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
            cell.mid.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        }
    
        return cell;
                    
    }
    
}

