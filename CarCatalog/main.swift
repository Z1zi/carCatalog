//  main.swift
//  CarCatalog
//  Created by Fedor Zverev on 14.10.2019.
//  Copyright © 2019 Fedor Zverev. All rights reserved.

import Foundation

var isQuit:Bool = false
var tmpCar : [String] = []
func loadDataFromFile ()->(String){
    var content:String = ""
    let file = "auto.txt"
    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        let fileURL = dir.appendingPathComponent(file)
        //reading
        do {
            content = try String(contentsOf: fileURL, encoding: .utf8)
        }
        catch {}
    }
    return(content)
}

var carCatalog : String = loadDataFromFile()
if carCatalog.isEmpty { carCatalog = "2009,Honda,Civic,Sedan\n2008,Kia,Ceed,Hatchback\n2018,BMW,Z4,Coupe"
    print ("Сохраненные данные не найдены! Загружен стартовый набор данных.")
}
var carArray: [[String]] = carCatalog
    .components(separatedBy: "\n")
    .map({
        $0.components(separatedBy: ",")
            .map({
                return $0
            })
    })
print("Загружено строк с данными: \(carArray.count)")

func saveArrayToFile (arrayToSave : [[String]]){
    var tempString = ""
    var tempArray : [String] = []
    arrayToSave.forEach {(temp) in
        tempString = temp.joined(separator: ",")
        tempArray.append(tempString)
    }
    tempString = tempArray.joined(separator: "\n")
    let file = "auto.txt"
    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        let fileURL = dir.appendingPathComponent(file)
        do {
            try tempString.write(to: fileURL, atomically: false, encoding: .utf8)
        }
        catch { print("Ошибка открытия файла!")}
    }
}
func deleteItem (_ : [[String]])->([[String]]){
    print("Введите индекс удаляемого автомобиля: 0 - \(carArray.count - 1)")
    if let tempIndexStr = readLine() {
        if let tempIndexInt = Int(tempIndexStr){
            carArray.remove(at: Int(tempIndexInt))
            saveArrayToFile(arrayToSave: carArray)
            print("Удалена запись с индексом \(String(describing: tempIndexInt))\nДанные записаны")
        }else{
            print("Несуществующий индекс! Введите число от 0 до \(carArray.count - 1)")
        }
    }else{
        print("Несуществующий индекс! Введите число от 0 до \(carArray.count - 1)")
    }
    return carArray
}
func quit (_ : [[String]])->([[String]]){
    isQuit=true
    saveArrayToFile(arrayToSave: carArray)
    return carArray
}
func viewItem(){
    print("Введите индекс просматриваемого авто: 0 - \(carArray.count - 1)")
    let indexStr = readLine()!
    let index = Int(indexStr)
    print("Индекс: \(indexStr)\nГод выпуска: \(carArray[index!][0])\nПроизводитель: \(carArray[index!][1])\nМодель: \(carArray[index!][2])\nТипа кузова: \(carArray[index!][3])")
}
func appendItem(_ : [[String]])->([[String]]){
    print("Введите год выпуска автомобиля:")
    if let tmpStr = readLine(){
        if (Int(tmpStr) != nil)&&(Int(tmpStr)! > 1768){
            tmpCar.append(tmpStr)
            print("Введите производителя автомобиля:")
            if let tmpStr = readLine(){
                if tmpStr != "" {tmpCar.append(tmpStr)}
                print("Введите модель автомобиля:")
                if let tmpStr = readLine(){
                    if tmpStr != "" {tmpCar.append(tmpStr)}
                    print("Введите тип кузова автомобиля:")
                    if let tmpStr = readLine(){
                        if tmpStr != "" {
                            tmpCar.append(tmpStr)
                            carArray.append(tmpCar)
                            saveArrayToFile(arrayToSave: carArray)
                        }
                    }else{print("Введите тип кузова")}
                }else{print("Введите модель")}
            }else{print("Введите производителя")}
        }else{print("Введите число больше 1768")}
    }
    tmpCar = []
    return carArray
}

func editItem(_ : [[String]])->[[String]]{
    print("Введите индекс редактируемого автомобиля: 0 - \(carArray.count - 1)")
    if let tmpStr = readLine(){
        if let tmpIndex = Int(tmpStr){
            if (tmpIndex >= 0)&&(tmpIndex <= carArray.count - 1) {
                tmpCar = carArray[tmpIndex]
                print("Введите год выпуска автомобиля: [\(carArray[tmpIndex][0])]")
                if let tmpStr = readLine(){
                    if (Int(tmpStr) != nil)&&(Int(tmpStr)! > 1768){
                        tmpCar[0] = tmpStr
                        print("Введите производителя автомобиля: [\(carArray[tmpIndex][1])]")
                        if let tmpStr = readLine(){
                            if tmpStr != "" {tmpCar[1] = tmpStr}
                            print("Введите модель автомобиля: [\(carArray[tmpIndex][2])]")
                            if let tmpStr = readLine(){
                                if tmpStr != "" {tmpCar[2] = tmpStr}
                                print("Введите тип кузова автомобиля: [\(carArray[tmpIndex][3])]")
                                if let tmpStr = readLine(){
                                    if tmpStr != "" {
                                        tmpCar[3] = tmpStr
                                        carArray[tmpIndex] = tmpCar
                                        tmpCar = [] ; saveArrayToFile(arrayToSave: carArray)
                                    }
                                }else{print("Введите тип кузова"); tmpCar = []}
                            }else{print("Введите модель"); tmpCar = []}
                        }else{print("Введите производителя"); tmpCar = []}
                    }else{print("Введите число больше 1768"); tmpCar = []}
                }
            }
        }
    }
    tmpCar = []
    return carArray
}

//функция главного меню
func MainMenu() {
    //  dump(carArray)
    print("Выберите операцию \n1 : Просмотр\n2 : Редактирование\n3 : Удаление\n4 : Добавить индекс\n5 : Выход")
    while !isQuit{
        let operation = readLine()
        switch operation {
        case "1": viewItem()
        case "2": carArray = editItem(carArray)
        case "3": carArray = deleteItem(carArray)
        case "4": carArray = appendItem(carArray)
        case "5": carArray = quit(carArray)
        case .none: MainMenu()
        case .some(_): MainMenu()
        }
    }
    
}
MainMenu()
