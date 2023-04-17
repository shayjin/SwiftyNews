import XCTest
@testable import SwiftyNews

class SwiftyNewsTests: XCTestCase {


    func testConvertStateName() throws {
        let vc = HomeViewController()
        
        var state = vc.convertStateName("OH")

        XCTAssertEqual(state, "Ohio", "Not equal")
    }
    
    func testConvertEmail() throws {
        let vc = NewsViewController()
        
        var actual = vc.convertEmail(email: "shin.810@osu.edu")
        XCTAssertEqual("shin,810@osu,edu", actual)
        
        actual = vc.convertEmail(email: "champion_adam@gmail.com")
        XCTAssertEqual("champion_adam@gmail,com", actual)
        
        actual = vc.convertEmail(email: "1.2.,3.as,f.da.bas,dcda.,s@gmail.com")
        XCTAssertEqual("1,2,,3,as,f,da,bas,dcda,,s@gmail,com", actual)
    }
    
    func testRandomizeCountries() throws {
        let vc = HomeViewController()
        let countries = ["ae", "ar", "at", "au", "be", "bg", "br", "ca", "ch", "cn", "co", "cz", "de", "eg", "fr", "gb", "gr", "hk", "hu", "id", "ie", "il", "in", "it", "jp", "kr", "lt", "lv", "ma", "mx", "my", "ng", "nl", "no", "nz", "ph", "pl", "pt", "ro", "rs", "ru", "sa", "se", "sg", "sk", "th", "tr", "tw", "ua", "us", "ve", "za"]
        
        let chosenCountries = vc.randomizeCountries()
        
        XCTAssertTrue(chosenCountries.count == 5)
        
        for i in 0...4 {
            XCTAssertTrue(countries.contains(chosenCountries[i]))
        }
    }
    
    func testSimplify() throws {
        let news = News()
        
        news.simplify(url: "BitcoinBTCUSD +0.59%  and other cryptocurrencies were rising Thursday, with Ether—the second-largest digital asset—outperforming after a critical upgrade to the Ethereum blockchain network was completed. The price of Bitcoin has risen 1% over the past 24 hours to near $30,250, with the largest digital asset trading around its highest level since last June after breaking through the key $30,000 level late Monday. The $30,000 level is psychologically important because it represents where Bitcoin stood last summer before a string of business failures across the crypto industry turned a selloff into a brutal bear market. Bitcoin is consolidating around the $30,000 mark for the third day, moving in a tight $20,700 to $30,300 range,” said Alex Kuptsikevich, an analyst at broker FxPro. “The $30,000 mark was significant for Bitcoin in 2021 and the first half of 2022, acting as a market mode switch. Last year, Bitcoin consolidated around this price for about five weeks before plunging sharply. There is a greater chance of a mirror dynamic, with the bulls taking a long time to gather their strength before making a decisive move higher. Bitcoin is likely to continue reacting to macroeconomic forces that also impact the stock market, and swing in step with the Dow Jones Industrial Average and S&P 500. In focus are the future of interest rates and Federal Reserve monetary policy. Decades-high inflation pushed the Fed to dramatically tighten financial conditions last year—a major headwind for socks and cryptos alike—but the 2023 surge in cryptos has come amid expectations that the central bank will be more accommodative. Economic data due this week will be important in shaping the narrative. More immediately, crypto traders are focused on Ether ETHUSD +3.52%  after the Ethereum blockchain network completed its critical “Shanghai” upgrade late Wednesday. Ether prices were outperforming, up 6% over the past 24 hours and nearing the $2,000 mark. Shanghai is the biggest change to the Ethereum ecosystem since last year’s “Merge,” which transformed the network from a Bitcoin-style energy-intensive “proof of work” system to “proof of stake.” Under proof of stake, participating holders of Ether lock up their tokens as collateral while they validate transactions and secure the network, earning interest in the process. The Shanghai upgrade allows those tokens to begin to be withdrawn, raising the prospect of selling pressure as some investors withdraw staked Ether and sell it. But the Shanghai upgrade, which will make staking more straightforward, is also expected to make the trade more popular, which should support prices. For now, selling pressure appears to be muted after the successful upgrade. Beyond Bitcoin and Ether, smaller cryptos or altcoins were also higher, with CardanoADAUSD +0.33%  and Polygon each climbing 4%. Memecoins were also buoyant, with Dogecoin DOGEUSD +1.00%  up 4% and Shiba InuSHIBUSD +0.63%  rising 2%.")
        
        XCTAssertTrue(news.simplifiedText.count >= 0 && news.simplifiedText.count <= 3)
    }
}
