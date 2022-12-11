//
//  CountryService.swift
//  MangoTest
//
//  Created by Юрий Девятаев on 03.12.2022.
//

import Foundation

protocol CountryService {
    var countries: [Country] { get }
    func country(for code: String) -> Country?
}

final class CountryServiceImp: CountryService {
    
    static let shared = CountryServiceImp()
    
    var countries: [Country]
    
    init() {
        
        var array = [Country]()
        Locale.isoRegionCodes.forEach {
            if let name = Locale.current.localizedString(forRegionCode: $0),
               let code = countryPrefixes[$0] {
                
                let country = Country(region: $0, name: name, code: "\(code)")
                array.append(country)
            }
        }
        
        self.countries = array
    }
    
    func country(for code: String) -> Country? {
        countries.first(where: { $0.code == code })
    }
}
