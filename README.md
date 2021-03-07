[![5.2 Swift](https://img.shields.io/badge/Swift-5.2-green.svg)](https://github.com/Naereen/badges)
[![14 iOS](https://img.shields.io/badge/iOS-13x+-blue.svg)](https://github.com/Naereen/badges)

# CoreData
In this repository you find an example where explain how to use CoreData on your app.

## Details
In CoreData in diference with SQL you have this comparative table

| CoreData | SQL | 
| ------------- |:-------------:| 
| Entity | Tables | 
| Attributes | Fields |   
| Relations | Relations |

### Entities
All entities in project need to start with Uppercase letter

### Attributes
Attributes has a differents types to be assigned (Int16, 32, 64, string, etc.)
Attribute name not necessary must initialice with Uppercase letter.

## Explaination / Considerations
### Context

CoreData need a context to work, for that you need declarate it where you App need to use it. Maybe on AppDelegate or only in a ViewController
To declarate context, use follow example code

```swift
private var context: NSManagedObjectContext!

func connectToCoreData() -> NSManagedObjectContext {
    let delegate = UIApplication.shared.delegate as! AppDelegate
    return delegate.persistentContainer.viewContext
}

```

### Save data on CoreData
To save data on CoreData you need to get the Entity class declaration on it to show attributes and manipulate these. For that, you need this example code

```swift
let entityStudent = NSEntityDescription.insertNewObject(forEntityName: "Student", into: context) as! Student

entityStudent.nombre = nombre
entityStudent.edad = age
entityStudent.direccion = address
entityStudent.activo = activeSwitch.isOn

do {
    try context.save()    
    print("Save data success")
} catch let error as NSError {
    print("Error on save data: \(error.localizedDescription)")
}
```

### Show data from CoreData
To show data saved in CoreData, you need to call a fetch method from context. Check out this example

```swift
let coreDataInfo: NSFetchRequest<Student> = Student.fetchRequest()

do {
    
    let students = try context.fetch(coreDataInfo)
    print("Number of registers ==> \(students.count)")
    
    for student in students as [NSManagedObject] {
        let name = student.value(forKey: "name")
        let age = student.value(forKey: "age")
        let address = student.value(forKey: "address")
        let active = student.value(forKey: "active")
        
        print("Name: \(name ?? "WO name"), Age: \(age ?? "WO age"), Address: \(address ?? "WO address"), Active: \(active ?? "WO active")")
    }
    
} catch let error as NSError {
    print("Error on read data ==> \(error.localizedDescription)")
}
```

### Remove data on CoreData
To remove data saved in CoreData, you need create a NSFetchRequest and NSBatchDeleteRequest of your CoreData Entity. Check out this example

```swift
let coreDataInfo = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
let removeRequest = NSBatchDeleteRequest(fetchRequest: coreDataInfo)

do {
    try context.execute(removeRequest)
    print("Data removed")
} catch let error as NSError {
    print("Error removing data ==> \(error.localizedDescription)")
}
```
