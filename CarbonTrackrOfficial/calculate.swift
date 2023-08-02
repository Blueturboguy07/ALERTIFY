class Car {
    let evOrNot: String
    let numYearsOwned: Int
    let mileage: Int
    
    init(ev: String, num: Int, m: Int) {
        evOrNot = ev
        numYearsOwned = num
        mileage = m
    }
    
    func getImpact() -> Double {
        if evOrNot == "N" {
            return (Double(mileage) / Double(numYearsOwned)) * 0.79
        } else {
            return 0
        }
    }
}

var total: Double = 0

print("Enter your electricity bill: ")
if let electricBill = Double(readLine()!) {
    total += electricBill * 105
}

print("Does your home have Oil powered heating? (Y/N) ")
if let typeOfHeating = readLine(), typeOfHeating == "Y" {
    print("Enter your oil bill: ")
    if let oilBill = Double(readLine()!) {
        total += oilBill * 113
    }
}

print("Enter your gas bill: ")
if let gasBill = Double(readLine()!) {
    total += gasBill * 105
}

print("Do you have a car? (Y/N) ")
if let carOrNot = readLine(), carOrNot == "Y" {
    print("How many?? ")
    if let numCars = Int(readLine()!) {
        var listOfCars = [Car]()
        for i in 0..<numCars {
            print("Is Car#" + String(i+1) + " electric? (Y/N) ")
            if let ev = readLine() {
                print("When did you buy Car#" + String(i+1) + "? ")
                if let since = Int(readLine()!) {
                    let num = 2023 - since
                    print("What is the total mileage on Car#" + String(i+1) + "? ")
                    if let m = Int(readLine()!) {
                        listOfCars.append(Car(ev: ev, num: num, m: m))
                    }
                }
            }
        }
        for car in listOfCars {
            total += car.getImpact()
        }
    }
}

print("How many flights have you taken this year that were 4 hours or less? ")
if let numShortFlights = Double(readLine()!) {
    total += numShortFlights * 1440
}

print("How many flights have you taken this year that were more than 4 hours? ")
if let numLongFlights = Double(readLine()!) {
    total += numLongFlights * 4440
}

print("Does your household recycle? (Y/N) ")
if let doesRecycle = readLine(), doesRecycle == "N" {
    total += 350
}

print("Your total impact is: \(total)")
