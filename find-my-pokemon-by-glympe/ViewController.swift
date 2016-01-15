//
//  ViewController.swift
//  find-my-pokemon-by-glympe
//
//  Created by Γιώργος Λυμπερόπουλος on 11/01/16.
//  Copyright © 2016 glympe. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collection: UICollectionView!
    
    var pokemon = [Pokemon]()
    var filteredPokemon = [Pokemon]()
    var musicPlayer: AVAudioPlayer!
    var inSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collection.delegate = self
        collection.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.Done
        
        //Looks for single or multiple taps.
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
//        view.addGestureRecognizer(tap)
        
        initAudio()
        parsePokemonCSV()
    }
    
    override func viewDidAppear(animated: Bool) {
        customiseMySearchBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Method to obey to added protocols
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        //Grab one that is not used and put it on screen
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PokemonCell", forIndexPath: indexPath) as? PokemonCell{
            //let pokemon = Pokemon(name: "Test", pokedexId: (indexPath.row + 1))
            //Grab current pokemon from array
            let poke: Pokemon!
            
            if inSearchMode {
                poke = filteredPokemon[indexPath.row]
            } else {
                poke = pokemon[indexPath.row]
            }
            
            
            
            cell.configureCell(poke)
            return cell        }else{
            return UICollectionViewCell()
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let poke: Pokemon!
        
        if inSearchMode {
            poke = filteredPokemon[indexPath.row]
        } else {
            poke = pokemon[indexPath.row]
        }
        
        print(poke.name)
        performSegueWithIdentifier("Pokemon", sender: poke)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //number of items in each section(view)
        if inSearchMode {
            return filteredPokemon.count
        }
        
        return pokemon.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        //set the size of the grid. if it was showing picture, it can be made dynamic so it adapts to pictures
        
        return CGSizeMake(105, 105)
    }
    
    func initAudio(){
        let path = NSBundle.mainBundle().pathForResource("music", ofType: "mp3")!
        do{
            //SetUp music Players
            musicPlayer = try AVAudioPlayer(contentsOfURL: NSURL(string: path)!)
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
        }catch let err as NSError{
            print(err.debugDescription)
        }
    }
    
    @IBAction func musicButtonPressed(sender: UIButton!) {
        if musicPlayer.playing {
            musicPlayer.stop()
            sender.alpha = 0.2
        }else {
            musicPlayer.play()
            sender.alpha = 1.0
        }
    }
    
    func parsePokemonCSV(){
        //Read the csv file from resources
        let path = NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv")!
        do{
            //Read the csv file
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            //print(rows)
            for row in rows{
                //Grab the name and the id of each pokemon
                let name = row["identifier"]!
                let pokeId = Int(row["id"]!)!
                let poke = Pokemon(name: name, pokedexId: pokeId)
                //Append to array
                pokemon.append(poke)
            }
        }catch let err as NSError{
            print(err.debugDescription)
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            view.endEditing(true)
            collection.reloadData()
        } else {
            inSearchMode = true
            let lower = searchBar.text!.lowercaseString
            
            filteredPokemon = pokemon.filter({$0.name.rangeOfString(lower) != nil})
            collection.reloadData()
        }
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func customiseMySearchBar(){
        for subView in self.searchBar.subviews
        {
            for subsubView in subView.subviews
            {
                if let textField = subsubView as? UITextField
                {
                    textField.textColor = UIColor.whiteColor()
                    if textField.respondsToSelector(Selector("attributedPlaceholder")) {
                        
                        let attributeDict = [NSForegroundColorAttributeName: UIColor.whiteColor()]
                        textField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: attributeDict)
                        textField.textColor = UIColor.whiteColor()
                        textField.font = UIFont(name: "Helvetica Neue", size: 16)
                    }
                    
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Pokemon" {
            if let detailsVC = segue.destinationViewController as? PokemonDetailVC {
                if let poke = sender as? Pokemon {
                    detailsVC.pokemon = poke
                }
            }
        }
    }

}

