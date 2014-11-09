// Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
import Foundation


let apiKey:String = "1e1bddc152a80f511722a4320eebc14f"
let baseURL = NSURL(string: "https://api.forecast.io/forecast/\(apiKey)/")
let forecastURL = NSURL(string: "37.8267,-122.423", relativeToURL: baseURL)

let weatherData = NSData(contentsOfURL: forecastURL!, options: nil, error: nil)
println(weatherData)

//CLOSURE
//{ (parameters) -> return type in
//    statements
//}
let languages = ["iOS":"Swift", "Android":"Java"]
var iosLanguage = languages["iOS"]



