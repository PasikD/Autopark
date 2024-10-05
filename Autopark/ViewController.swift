//
//  ViewController.swift
//  Autopark
//
//  Created by Денис Васильевич on 04.10.2024.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Создание грузов
        let cargo1 = Cargo(description: "Fragile cargo", weight: 50, type: .fragile)!
        let cargo2 = Cargo(description: "Perishable cargo", weight: 100, type: .perishable)!
        let cargo3 = Cargo(description: "Bulk cargo", weight: 200, type: .bulk)!

        // Создание транспортных средств
        let car = Vehicle(make: "Toyota", model: "Camry", year: 2020, capacity: 300, types: [.fragile, .perishable])
        let truck = Truck(make: "Ford", model: "F-150", year: 2021, capacity: 500, types: [.bulk], trailerAttached: true, trailerCapacity: 200, trailerTypes: [.bulk])

        // Создание автопарка
        let fleet = Fleet(vehicles: [car, truck])

        // Загрузка грузов
        car.loadCargo(cargo1)
        car.loadCargo(cargo2)
        truck.loadCargo(cargo3)

        // Вывод информации об автопарке
        fleet.info()
    }
}

enum CargoType: String {
    case fragile = "fragile"
    case perishable = "perishable"
    case bulk = "bulk"
}

struct Cargo {
    var description: String
    var weight: Int
    var type: CargoType

    init?(description: String, weight: Int, type: CargoType) {
        guard weight >= 0 else { return nil }
        self.description = description
        self.weight = weight
        self.type = type
    }
}

class Vehicle {
    var make: String
    var model: String
    var year: Int
    var capacity: Int
    var types: [CargoType]?
    var currentLoad: Int?

    init(make: String, model: String, year: Int, capacity: Int, types: [CargoType]? = nil) {
        self.make = make
        self.model = model
        self.year = year
        self.capacity = capacity
        self.types = types
        self.currentLoad = 0
    }

    func loadCargo(_ cargo: Cargo) {
        guard let currentLoad = currentLoad else { return }
        guard let types = types else {
            if currentLoad + cargo.weight <= capacity {
                self.currentLoad! += cargo.weight
            } else {
                print("Cargo exceeds capacity")
            }
            return
        }
        if types.contains(cargo.type) {
            if currentLoad + cargo.weight <= capacity {
                self.currentLoad! += cargo.weight
            } else {
                print("Cargo exceeds capacity")
            }
        } else {
            print("Cargo type not supported")
        }
    }

    func unloadCargo() {
        currentLoad = 0
    }
}

class Truck: Vehicle {
    var trailerAttached: Bool
    var trailerCapacity: Int?
    var trailerTypes: [CargoType]?

    init(make: String, model: String, year: Int, capacity: Int, types: [CargoType]? = nil, trailerAttached: Bool, trailerCapacity: Int? = nil, trailerTypes: [CargoType]? = nil) {
        self.trailerAttached = trailerAttached
        self.trailerCapacity = trailerCapacity
        self.trailerTypes = trailerTypes
        super.init(make: make, model: model, year: year, capacity: capacity, types: types)
    }

    override func loadCargo(_ cargo: Cargo) {
        guard let currentLoad = currentLoad else { return }
        guard let types = types else {
            if currentLoad + cargo.weight <= capacity {
                self.currentLoad! += cargo.weight
            } else {
                print("Cargo exceeds capacity")
            }
            return
        }
        if types.contains(cargo.type) {
            if currentLoad + cargo.weight <= capacity {
                self.currentLoad! += cargo.weight
            } else {
                print("Cargo exceeds capacity")
            }
        } else {
            print("Cargo type not supported")
        }

        if trailerAttached, let trailerCapacity = trailerCapacity, let trailerTypes = trailerTypes {
            if trailerTypes.contains(cargo.type) {
                if currentLoad + cargo.weight <= trailerCapacity {
                    self.currentLoad! += cargo.weight
                } else {
                    print("Cargo exceeds trailer capacity")
                }
            } else {
                print("Cargo type not supported by trailer")
            }
        }
    }
}

class Fleet {
    var vehicles: [Vehicle]

    init(vehicles: [Vehicle] = []) {
        self.vehicles = vehicles
    }

    func addVehicle(_ vehicle: Vehicle) {
        vehicles.append(vehicle)
    }

    func totalCapacity() -> Int {
        return vehicles.reduce(0) { $0 + $1.capacity }
    }

    func totalCurrentLoad() -> Int {
        return vehicles.reduce(0) { $0 + ($1.currentLoad ?? 0) }
    }

    func info() {
        print("Fleet Info:")
        print("Total Capacity: \(totalCapacity()) kg")
        print("Total Current Load: \(totalCurrentLoad()) kg")
        for vehicle in vehicles {
            print("Vehicle: \(vehicle.make) \(vehicle.model), Year: \(vehicle.year), Capacity: \(vehicle.capacity) kg, Current Load: \(vehicle.currentLoad ?? 0) kg")
        }
    }
}
