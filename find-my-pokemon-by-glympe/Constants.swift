//
//  Constants.swift
//  find-my-pokemon-by-glympe
//  Values that do not change and are accessible to whole applications
//
//  Created by Γιώργος Λυμπερόπουλος on 16/01/16.
//  Copyright © 2016 glympe. All rights reserved.
//

import Foundation

let URL_BASE = "http://pokeapi.co"
let URL_POKEMON = "/api/v1/pokemon/"

//Closure defining that download is complete and we can call the method
//no parameters and nothing is returned () -> ()
typealias DownloadComplete = () -> ()
