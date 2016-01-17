//
//  PokemonDetailVC.swift
//  find-my-pokemon-by-glympe
//
//  Created by Γιώργος Λυμπερόπουλος on 13/01/16.
//  Copyright © 2016 glympe. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var defLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var pokedexLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var attackLbl: UILabel!
    @IBOutlet weak var evoLbl: UILabel!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var bgView: UIView!
    
        
    
    var pokemon: Pokemon!
    override func viewDidLoad() {
        super.viewDidLoad()
        showActivityIndicatory(activityView)
        nameLbl.text = pokemon.name
        mainImg.image = UIImage(named: "\(pokemon.pokedexId)")
        segmentedControl.selectedSegmentIndex = 0
        pokemon.downloadPokemonDetails { () -> () in
            //This will be called after download is done
            self.updateUI()
            self.activityIndicator.stopAnimating()
            self.activityIndicator.hidden = true
            self.activityView.hidden = true
            self.bgView.hidden = true
        }
        //activityIndicatorView.stopAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateUI(){
        typeLbl.text = pokemon.type
        descriptionLbl.text = pokemon.descPokemon
        defLbl.text = pokemon.defense
        heightLbl.text = pokemon.height
        pokedexLbl.text = "\(pokemon.pokedexId)"
        weightLbl.text = pokemon.weight
        attackLbl.text = pokemon.attack
        if pokemon.nextEvoId == "" {
            evoLbl.text = "No evolution"
            nextEvoImg.hidden = true
        }else{
            nextEvoImg.hidden = false
            nextEvoImg.image = UIImage(named: pokemon.nextEvoId)
            var str = "Next Evolution: \(pokemon.nextEvoTxt)"
            if pokemon.nextEvoLvl != "" {
                str += " - LVL: \(pokemon.nextEvoLvl)"
            }
            evoLbl.text = str
        }
        currentEvoImg.image = mainImg.image
    }
    @IBAction func indexChanged(sender: AnyObject) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            typeLbl.text = pokemon.type
        case 1:
            typeLbl.text = "No Type"
        default:
            break; 
        }
    }

    @IBAction func backBtn(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func showActivityIndicatory(uiView: UIView) {
        //let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
        activityIndicator.center = uiView.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle =
        UIActivityIndicatorViewStyle.WhiteLarge
        uiView.addSubview(activityIndicator)
        bgView.layer.cornerRadius = 10.0
        bgView.clipsToBounds = true
        activityIndicator.startAnimating()
        
    }
    
    }
