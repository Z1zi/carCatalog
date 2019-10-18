//
//  main.swift
//  CarCatalog
//
//  Created by Fedor Zverev on 14.10.2019.
//  Copyright © 2019 Fedor Zverev. All rights reserved.
//

import Foundation

var isQuit:Bool = false

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
if carCatalog.isEmpty { carCatalog = "2009,Honda,Civic,Sedan\n2008,Kia,Ceed,Hatchback\n2018,BMW,Z4,Coupe\n"
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
print("Загружено \(carArray.count-1) автомобилей")

func saveArrayToFile (arrayToSave : [[String]]){
    var tempString = ""
    arrayToSave.forEach {(temp) in
        temp.forEach{ (temp) in
            tempString += temp
            tempString += ","
        }
        tempString += "\n"
    }
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
    print("Введите индекс удаляемого автомобиля: 0 - \(carArray.count - 2)")
    let tempIndex = readLine()
    carArray.remove(at: Int(tempIndex!)!-1)
    saveArrayToFile(arrayToSave: carArray)
    print("Удалена запись с индексом \(String(describing: tempIndex))\nДанные записаны")
    return carArray
}
func quit (_ : [[String]])->([[String]]){
    isQuit=true
    saveArrayToFile(arrayToSave: carArray)
    return carArray
}
func viewItem(){
    print("Введите индекс просматриваемого авто: 0 - \(carArray.count - 2)")
    let indexStr = readLine()!
    let index = Int(indexStr)
    print("Индекс: \(indexStr)\nГод выпуска: \(carArray[index!][0])\nПроизводитель: \(carArray[index!][1])\nМодель: \(carArray[index!][2])\nТипа кузова: \(carArray[index!][3])")
}
func appendItem(_ : [[String]])->([[String]]){
    print("Введите год выпуска автомобиля:")
    let tmpStr0 = readLine()
    print("Введите производителя автомобиля:")
    let tmpStr1 = readLine()
    print("Введите модель автомобиля:")
    let tmpStr2 = readLine()
    print("Введите тип кузова автомобиля:")
    let tmpStr3 = readLine()
    carArray.remove(at: carArray.count-1)
    carArray.append([tmpStr0!,tmpStr1!,tmpStr2!,tmpStr3!])
    saveArrayToFile(arrayToSave: carArray)
    return carArray
}

func editItem(_: [[String]])->[[String]]{
    print("Введите индекс редактируемого автомобиля: 0 - \(carArray.count - 2)")
    let tmpIndex = Int(readLine()!)
    print("Введите год выпуска:")
    carArray[tmpIndex!][0] = readLine()!
    print("Введите производителя:")
    carArray[tmpIndex!][1] = readLine()!
    print("Введите марку:")
    carArray[tmpIndex!][2] = readLine()!
    print("Введите тип кузова:")
    carArray[tmpIndex!][3] = readLine()!
    saveArrayToFile(arrayToSave: carArray)
    return carArray
}

//функция главного меню
func MainMenu() {
    
    print("Выберите операцию \n1 : Просмотр\n2 : Редактирование\n3 : Удаление\n4 : Добавить индекс\n5 : Выход")
    while !isQuit{
        let operation = readLine()
        switch operation {
        case "5": carArray = quit(carArray)
        case "3": carArray = deleteItem(carArray)
        case "2": carArray = editItem(carArray)
        case "1": viewItem()
        case "4": carArray = appendItem(carArray)
        case .none: MainMenu()
        case .some(_): MainMenu()
        }
    }
    
}
MainMenu()
