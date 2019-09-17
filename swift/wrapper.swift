import Foundation

class SwissCalc{
    
    static func calculatePlanetPosition(swissKey: int32, dateTime: Date) -> SwiftPlanetPosition {
        
        var position = SwiftPlanetPosition();
        let tjd = SwissCalc.getJulianDateTime(dateTime: dateTime)
        
        //let pk = 1//test
        var planetPositions = Array(repeating: 0.0, count: 6)
        var error:UnsafeMutablePointer<CChar>!
        
        let optionsflag = SEFLG_SPEED //SEFLG_SPEED; //Tp calc speed of planet
        //    SEFLG_JPLEPH           /* use JPL ephemeris */
        //    SEFLG_SWIEPH           /* use Swiss Ephemeris */
        //    SEFLG_MOSEPH           /* use Moshier ephemeris */
        
        //let planet = PlanetsInfo.get(placementKey)
        
        //int32((planet?.swissKey)!)
        
        swe_calc_ut(tjd, swissKey, optionsflag, &planetPositions, error )
        
        position.longitude = planetPositions[0]
        position.latitude = planetPositions[1]
        position.distance = planetPositions[2]
        position.longitudeSpeed = planetPositions[3]
        position.latitudeSpeed = planetPositions[4]
        position.distanceSpeed = planetPositions[5]
        
        return position
    }
    
    
    static func calculateHouses(dateTime:Date, latitude: Double, longitude: Double, houseSystem: Int32) -> [Double] {
        let tjd = SwissCalc.getJulianDateTime(dateTime: dateTime)
        let defHouseSystem: Int32  = 80 //"P" = 80 ;   //House method, ascii code of one of the letters PKORCAEVXHTBG */
        var ascendantAndMidheaven: [Double] = Array(repeating: 0.0, count: 10)     /* array for 10 doubles */
        var houseCusps:[Double] = Array(repeating: 0.0, count: 13)
        swe_houses(tjd,latitude,longitude,defHouseSystem,&houseCusps,&ascendantAndMidheaven)  //& denotes inout parameter
        
        return houseCusps
    }
    
    
    static func getJulianDateTime(dateTime:Date) -> Double {
        let calender = NSCalendar(identifier: .gregorian)
        calender?.timeZone = TimeZone(identifier: "UTC")!
        
        let year = int32((calender?.component(.year, from: dateTime))!)
        let month = int32((calender?.component(.month, from: dateTime))!)
        let day = int32((calender?.component(.day, from: dateTime))!)
        let hour = Double((calender?.component(.hour, from: dateTime))!)
        let mins = Double((calender?.component(.minute, from: dateTime))!)
        let seconds = Double((calender?.component(.second, from: dateTime))!)
        let hourMins = hour + mins/60 + seconds/3600
        let timeJulianDay:Double = swe_julday(year as Int32, month, day, hourMins, SE_GREG_CAL)
        
        return timeJulianDay
    }
}
